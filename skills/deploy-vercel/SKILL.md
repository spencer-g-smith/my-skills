---
name: deploy-vercel
description: Vercel operations for existing projects — deploy, connect GitHub auto-deploy, add domains, manage environment variables, redeploy, rollback, and cleanup. Use when a project already exists and needs Vercel hosting/configuration. Prefer GitHub-connected deployments for all new projects.
---

# Deploy Vercel — GitHub-First Operations

Manages Vercel deployment/configuration for projects that already exist in `~/Projects/`.

For creating new projects from scratch, use the `init-project` skill.

## Policy (default)

For **new projects**, always use **GitHub-connected deploys** (not CLI upload-only deploys).

- ✅ Preferred: push to GitHub, then let Vercel deploy from Git
- 🚫 Avoid as default for new projects: `vercel --prod` as the primary deployment path

Use direct CLI deploys only for emergency/manual one-offs.

## Prerequisites

- `vercel` CLI authenticated
- `gh` authenticated
- Project exists in `~/Projects/<app-name>`
- Repo exists and is pushed to GitHub (`origin` set)

## First-Time Setup (GitHub auto-deploy)

```bash
cd ~/Projects/<app-name>

# Ensure remote exists
git remote -v

# Connect Vercel project to GitHub repo
vercel --yes
vercel git connect https://github.com/spencer-g-smith/<app-name>.git
```

## Deploy (GitHub path)

Use git pushes to deploy:

```bash
cd ~/Projects/<app-name>
git add .
git commit -m "feat: <change>"
git push
```

- Push to default production branch (`main`) → production deploy
- PR branches → preview deploys

## Verify Auto-Deploy

```bash
vercel ls <app-name>
```

Look for a deployment triggered right after push.

## Manual Deploy (fallback only)

```bash
cd ~/Projects/<app-name>
vercel --prod --yes
```

Use only when GitHub path is unavailable or urgent.

## Custom Domain

Add a subdomain on spencer-smith.io:

```bash
vercel domains add <app-name>.spencer-smith.io
```

Replace/update a domain:

```bash
vercel domains add <new-domain>
vercel domains rm <old-domain>
```

DNS wildcard is pre-configured on Cloudflare.

## Environment Variables

```bash
# Add a variable
vercel env add <KEY> production

# List variables
vercel env ls

# Remove a variable
vercel env rm <KEY> production
```

## Rollback

```bash
vercel ls <app-name>
vercel rollback <deployment-url>
```

## Cleanup

```bash
vercel rm <app-name> -y
```

This does not delete GitHub repo or local files — only the Vercel project.
