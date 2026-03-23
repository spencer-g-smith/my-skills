# my-skills

Shared skills for agent environments. Clone once, symlink everywhere, `git pull` to update.

## Install

```bash
git clone <repo-url> && cd my-skills
./install.sh
```

The installer detects which agent environments are available and symlinks skills into each:

| Target | Path | Condition |
|---|---|---|
| Claude Code | `~/.claude/skills/` | Always |
| OpenClaw | `~/.openclaw/workspace/skills/` | Only if `~/.openclaw` exists |

## Adding a skill

1. Create a folder under `skills/` with a `SKILL.md` inside:

```
skills/
  my-new-skill/
    SKILL.md
    references/    # optional supporting docs
```

2. Run `./install.sh` again to link it.

## Repo structure

```
my-skills/
  install.sh       # Interactive installer (macOS/Linux/Windows)
  skills/          # All shared skills live here
    expert-system/
    meeting-prep/
    vault-ops/
```

## How it works

`install.sh` creates symlinks from each target's skills directory back into this repo. Since they're symlinks, pulling new changes from the repo updates all linked environments instantly — no reinstall needed.
