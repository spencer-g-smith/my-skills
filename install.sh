#!/bin/bash

# -------------------------------------------------------
# CSP Skills Installer
# Connects shared skills from this repo to your local
# agent environments so they stay up to date.
# -------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_SOURCE="$SCRIPT_DIR/skills"

# -------------------------------------------------------
# Detect install targets
# -------------------------------------------------------
TARGETS=()
TARGET_LABELS=()

# Claude Code (always)
CLAUDE_TARGET="$HOME/.claude/skills"
mkdir -p "$CLAUDE_TARGET"
TARGETS+=("$CLAUDE_TARGET")
TARGET_LABELS+=("Claude Code")

# OpenClaw (only if installed)
OPENCLAW_TARGET="$HOME/.openclaw/workspace/skills"
if [ -d "$HOME/.openclaw" ]; then
  mkdir -p "$OPENCLAW_TARGET"
  TARGETS+=("$OPENCLAW_TARGET")
  TARGET_LABELS+=("OpenClaw")
fi

# Find all skill directories (folders containing a SKILL.md)
SKILLS=()
while IFS= read -r skill_md; do
  skill_dir="$(dirname "$skill_md")"
  skill_name="$(basename "$skill_dir")"
  SKILLS+=("$skill_name")
done < <(find "$SKILLS_SOURCE" -mindepth 2 -maxdepth 2 -name "SKILL.md" 2>/dev/null | sort)

if [ ${#SKILLS[@]} -eq 0 ]; then
  echo ""
  echo "No skills found in the repository yet."
  echo "Add a skill folder with a SKILL.md file to skills/ to get started."
  echo ""
  exit 0
fi

TOTAL=${#SKILLS[@]}

# -------------------------------------------------------
# Colors
# -------------------------------------------------------
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
WHITE='\033[97m'

# Build status arrays (a skill is "installed" only if symlinked in ALL targets)
STATUSES=()
for skill in "${SKILLS[@]}"; do
  all_linked=true
  has_local=false
  for t in "${TARGETS[@]}"; do
    if [ -L "$t/$skill" ]; then
      : # symlinked, good
    elif [ -e "$t/$skill" ]; then
      has_local=true
      all_linked=false
    else
      all_linked=false
    fi
  done
  if [ "$all_linked" = true ]; then
    STATUSES+=("installed")
  elif [ "$has_local" = true ]; then
    STATUSES+=("local")
  else
    STATUSES+=("available")
  fi
done

# Show welcome message
echo ""
echo -e "${CYAN}${BOLD}==================================="
echo "  CSP Skills Installer"
echo -e "===================================${RESET}"
echo ""
echo -e "This will connect shared skills to your local agent environments."
echo -e "Once installed, skills stay up to date whenever you pull from the repo."
echo ""
echo -e "${BOLD}Detected targets:${RESET}"
for i in "${!TARGETS[@]}"; do
  echo -e "  ${GREEN}•${RESET} ${TARGET_LABELS[$i]} ${DIM}(${TARGETS[$i]})${RESET}"
done
echo ""

# --- Determine input mode ---
# Use simple number-entry on Windows (Git Bash / Cygwin / MSYS)
# Use interactive arrow-key menu everywhere else (macOS, Linux)
USE_SIMPLE_MODE=false
if [ "$OSTYPE" = "msys" ] || [ "$OSTYPE" = "cygwin" ] || [ "$OSTYPE" = "win32" ]; then
  USE_SIMPLE_MODE=true
fi

# -------------------------------------------------------
# Simple mode (Windows)
# -------------------------------------------------------
simple_select() {
  echo -e "${BOLD}Available skills:${RESET}"
  echo ""
  for i in "${!SKILLS[@]}"; do
    local skill="${SKILLS[$i]}"
    local num=$((i + 1))

    local status=""
    if [ "${STATUSES[$i]}" = "installed" ]; then
      status="${DIM} (already installed)${RESET}"
    elif [ "${STATUSES[$i]}" = "local" ]; then
      status="${DIM} (local copy exists - will skip)${RESET}"
    fi

    echo -e "  ${CYAN}${num})${RESET} ${BOLD}${skill}${RESET}${status}"
  done

  echo ""
  echo -e "${DIM}-----------------------------------${RESET}"
  echo ""
  echo "What would you like to install?"
  echo ""
  echo "  - Enter skill numbers separated by spaces (e.g., 1 3)"
  echo -e "  - Type ${BOLD}'all'${RESET} to install everything"
  echo -e "  - Type ${BOLD}'quit'${RESET} to exit"
  echo ""
  printf "${CYAN}${BOLD}> ${RESET}"
  read -r choice

  if [ -z "$choice" ] || [ "$choice" = "quit" ] || [ "$choice" = "q" ]; then
    echo ""
    echo "No changes made. You can run this script again anytime."
    echo ""
    exit 0
  fi

  CHOSEN=()
  if [ "$choice" = "all" ] || [ "$choice" = "a" ]; then
    CHOSEN=("${SKILLS[@]}")
  else
    for num in $choice; do
      if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "$TOTAL" ]; then
        CHOSEN+=("${SKILLS[$((num - 1))]}")
      else
        echo ""
        echo "Skipping invalid selection: $num"
      fi
    done
  fi
}

# -------------------------------------------------------
# Interactive mode (macOS / Linux)
# -------------------------------------------------------

selected_count() {
  local count=0
  for s in "${SELECTED[@]}"; do
    if [ "$s" = "1" ]; then
      count=$((count + 1))
    fi
  done
  echo "$count"
}

MENU_LINES=0

draw_menu() {
  # On redraw, move cursor up and clear the previous menu
  if [ "$1" = "redraw" ] && [ "$MENU_LINES" -gt 0 ]; then
    printf '\033[%dA' "$MENU_LINES"
    for ((l=0; l<MENU_LINES; l++)); do
      printf '\033[2K\n'
    done
    printf '\033[%dA' "$MENU_LINES"
  fi

  MENU_LINES=0

  for i in "${!SKILLS[@]}"; do
    local skill="${SKILLS[$i]}"
    local status="${STATUSES[$i]}"
    local selected="${SELECTED[$i]}"

    # Cursor indicator
    local cursor_char="  "
    if [ "$i" -eq "$CURSOR" ]; then
      cursor_char="${YELLOW}${BOLD}> ${RESET}"
    fi

    # Checkbox
    local checkbox="${DIM}[ ]${RESET}"
    if [ "$selected" = "1" ]; then
      checkbox="${GREEN}${BOLD}[x]${RESET}"
    fi

    # Skill name (bold if on cursor row)
    local skill_display="${skill}"
    if [ "$i" -eq "$CURSOR" ]; then
      skill_display="${BOLD}${WHITE}${skill}${RESET}"
    fi

    # Status label
    local label=""
    if [ "$status" = "installed" ]; then
      label="${DIM} (already installed)${RESET}"
    elif [ "$status" = "local" ]; then
      label="${DIM} (local copy exists - will skip)${RESET}"
    fi

    echo -e "${cursor_char}${checkbox} ${skill_display}${label}"
    MENU_LINES=$((MENU_LINES + 1))
  done

  echo ""
  echo -e "  ${DIM}up/down: move  space: toggle  a: all  n: none  enter: install  q: quit${RESET}"
  echo ""
  local count
  count=$(selected_count)
  echo -e "  ${CYAN}${BOLD}${count}${RESET} of ${TOTAL} selected"
  MENU_LINES=$((MENU_LINES + 4))
}

interactive_select() {
  # Initialize selection array (pre-select available skills)
  SELECTED=()
  for i in "${!SKILLS[@]}"; do
    if [ "${STATUSES[$i]}" = "available" ]; then
      SELECTED+=("1")
    else
      SELECTED+=("0")
    fi
  done

  CURSOR=0

  # Draw menu for the first time
  draw_menu "first"

  # Hide cursor
  tput civis
  trap 'tput cnorm' EXIT

  # Read input loop
  while true; do
    IFS= read -rsn1 key

    # Handle escape sequences (arrow keys)
    if [ "$key" = $'\x1b' ]; then
      read -rsn1 -t 1 seq1
      read -rsn1 -t 1 seq2
      key="${key}${seq1}${seq2}"
    fi

    case "$key" in
      $'\x1b[A' | k) # Up arrow or k
        if [ "$CURSOR" -gt 0 ]; then
          CURSOR=$((CURSOR - 1))
        fi
        ;;
      $'\x1b[B' | j) # Down arrow or j
        if [ "$CURSOR" -lt $((TOTAL - 1)) ]; then
          CURSOR=$((CURSOR + 1))
        fi
        ;;
      " ") # Space - toggle selection
        if [ "${SELECTED[$CURSOR]}" = "1" ]; then
          SELECTED[$CURSOR]="0"
        else
          SELECTED[$CURSOR]="1"
        fi
        ;;
      a) # Select all
        for i in "${!SELECTED[@]}"; do
          SELECTED[$i]="1"
        done
        ;;
      n) # Select none
        for i in "${!SELECTED[@]}"; do
          SELECTED[$i]="0"
        done
        ;;
      "" | $'\n') # Enter - confirm
        break
        ;;
      q) # Quit
        tput cnorm
        echo ""
        echo ""
        echo -e "${DIM}No changes made. You can run this script again anytime.${RESET}"
        echo ""
        exit 0
        ;;
    esac

    draw_menu "redraw"
  done

  # Restore cursor
  tput cnorm

  # Gather selected skills
  CHOSEN=()
  for i in "${!SKILLS[@]}"; do
    if [ "${SELECTED[$i]}" = "1" ]; then
      CHOSEN+=("${SKILLS[$i]}")
    fi
  done
}

# -------------------------------------------------------
# Run the appropriate selection mode
# -------------------------------------------------------
if [ "$USE_SIMPLE_MODE" = true ]; then
  simple_select
else
  interactive_select
fi

if [ ${#CHOSEN[@]} -eq 0 ]; then
  echo ""
  echo ""
  echo -e "${DIM}No skills selected. You can run this script again anytime.${RESET}"
  echo ""
  exit 0
fi

# -------------------------------------------------------
# Install selected skills to all targets
# -------------------------------------------------------
echo ""
echo ""
total_installed=0
total_skipped=0

for i in "${!TARGETS[@]}"; do
  target_dir="${TARGETS[$i]}"
  label="${TARGET_LABELS[$i]}"

  echo -e "${DIM}-----------------------------------${RESET}"
  echo -e "${BOLD}${CYAN}  ${label}${RESET} ${DIM}${target_dir}${RESET}"
  echo -e "${DIM}-----------------------------------${RESET}"
  echo ""

  installed=0
  skipped=0

  for skill in "${CHOSEN[@]}"; do
    target="$target_dir/$skill"
    source="$SKILLS_SOURCE/$skill"

    if [ -L "$target" ]; then
      echo -e "  ${DIM}Already installed: ${skill}${RESET}"
      skipped=$((skipped + 1))
    elif [ -e "$target" ]; then
      echo -e "  ${DIM}Skipped: ${skill} (local copy exists)${RESET}"
      skipped=$((skipped + 1))
    else
      ln -s "$source" "$target"
      echo -e "  ${GREEN}${BOLD}Installed:${RESET} ${skill}"
      installed=$((installed + 1))
    fi
  done

  total_installed=$((total_installed + installed))
  total_skipped=$((total_skipped + skipped))
  echo ""
done

echo -e "${DIM}-----------------------------------${RESET}"
echo ""
if [ $total_installed -gt 0 ]; then
  echo -e "${GREEN}${BOLD}Done!${RESET} Installed ${BOLD}${total_installed}${RESET} link(s) across ${BOLD}${#TARGETS[@]}${RESET} target(s), skipped ${total_skipped}."
  echo ""
  echo -e "Your installed skills will stay up to date automatically."
  echo -e "Just pull the latest from the repo and you're good to go."
else
  echo -e "Done! Installed ${total_installed} link(s), skipped ${total_skipped}."
fi
echo ""
