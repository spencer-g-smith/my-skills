---
name: init-project
description: Scaffold a new project from a golden template (app or static), create a GitHub repo, write CLAUDE.md, seed default skills, and optionally deploy to Vercel with GitHub auto-deploy enabled by default. Use when Spencer asks to build a new app or start a new project.
---

# Init Project — From Zero to Pod-Ready

Creates a project from a golden template with GitHub + Vercel Git integration so all future deploys run through GitHub pushes.

## Prerequisites

- `bun` installed
- `git` configured
- `gh` authenticated
- `vercel` authenticated (if deploying)

## Step 1 — Choose Template

| Template | When to use | Source |
|---|---|---|
| **App** | Interactive app with routes/state/components | `templates/golden-app-template` (relative to this skill) |
| **Static** | Blog/docs/content/presentation site | `templates/golden-static-template` (relative to this skill) |

Read the matching reference:
- App → `references/template-app.md`
- Static → `references/template-static.md`

## Step 2 — Scaffold

Resolve the template path relative to this skill's location, then copy it to the project directory:

```bash
SKILL_DIR="$(dirname "$(readlink -f "$0" 2>/dev/null || echo "$PWD")")"
# The templates live alongside this skill at: <skills-repo>/skills/init-project/templates/
cp -R <skill-dir>/templates/<chosen-template> ~/Projects/<app-name>
cd ~/Projects/<app-name>
rm -rf .git .vercel node_modules bun.lock
bun install
```

> **Note:** `<skill-dir>` is the directory containing this SKILL.md file. Claude Code knows this path at runtime — use it to locate `templates/`.

## Step 3 — Template-Specific Setup

Follow the chosen template reference (routes/content/config as needed).

## Step 4 — Verify Build

```bash
bun run build
```

## Step 5 — Initialize Git

```bash
git init
git checkout -b main
git add .
git commit -m "init: <app-name> from golden template"
```

## Step 6 — Create GitHub Repo + Push

```bash
gh repo create spencer-g-smith/<app-name> --source=. --private --remote=origin --push
```

## Step 7 — Write CLAUDE.md

Copy CLAUDE.md template from chosen template reference to project root and customize project notes.

## Step 8 — Seed Default Skills

```bash
mkdir -p .claude/skills/check .claude/skills/session-learnings .claude/skills/pr-description
```

| Reference file | Destination |
|---|---|
| `references/skill-check.md` | `.claude/skills/check/SKILL.md` |
| `references/skill-session-learnings.md` | `.claude/skills/session-learnings/SKILL.md` |
| `references/skill-pr-description.md` | `.claude/skills/pr-description/SKILL.md` |

## Step 9 — Commit Setup

```bash
git add CLAUDE.md .claude/
git commit -m "add CLAUDE.md and default skills"
git push
```

## Step 10 — Deploy to Vercel (GitHub-first)

Create/link Vercel project, then connect git integration:

```bash
cd ~/Projects/<app-name>
vercel --yes
vercel git connect https://github.com/spencer-g-smith/<app-name>.git
```

Optional domain:

```bash
vercel domains add <app-name>.spencer-smith.io
```

## Step 11 — Verify

Before handoff:
- [ ] `bun run build` passes
- [ ] `git remote -v` shows GitHub remote
- [ ] GitHub repo exists with `main`
- [ ] `CLAUDE.md` exists and is accurate
- [ ] `.claude/skills/` seeded
- [ ] `vercel ls <app-name>` shows deployment(s)
- [ ] Push to `main` triggers Vercel auto-deploy

## Cleanup

```bash
gh repo delete spencer-g-smith/<app-name> --yes
vercel rm <app-name> -y
rm -rf ~/Projects/<app-name>
```
