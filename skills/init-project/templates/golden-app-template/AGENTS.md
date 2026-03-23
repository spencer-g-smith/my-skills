# AGENTS.md — Golden App Template Rules

This app is scaffolded from `golden-app-template`.

## Mission
Build quickly, but never bypass quality gates.

## Stack
- TanStack Start + Nitro
- Tailwind CSS v4
- TypeScript strict mode
- ESLint typed rules (`max-warnings 0`)
- Prettier (Tailwind plugin)
- Bun

## Required Commands (in order)
On fresh copy:
```bash
bun install
bunx @tanstack/router-cli generate
bun run format
bun run build
```

## Build Gate (must pass)
`bun run build` runs:
- `tsc`
- `prettier --check .`
- `eslint . --max-warnings 0`
- `vite build`

If any step fails, fix it before deploy.

## Generated Files Policy
- Do **not** hand-edit generated build artifacts.
- Keep these ignored from formatting/lint churn:
  - `.nitro`
  - `.output`
  - `src/routeTree.gen.ts`
  - `vercel.json`

## Routing
- After adding/removing routes, run:
```bash
bunx @tanstack/router-cli generate
```

## Deployment
Standard:
```bash
vercel --prod --yes
```
Custom domain:
```bash
vercel domains add <subdomain>.spencer-smith.io
```

## Domain move order (if re-pointing)
1. Remove from old project
2. Add to new project
3. Deploy production

## Git Hygiene
- Keep commits focused and small.
- Use clear commit messages (`feat:`, `fix:`, `chore:`).
- Never commit secrets.

## Public-Facing Taste
For user-facing pages:
- Prefer simple, timeless UI over novelty.
- Keep motion subtle.
- Prioritize readability and spacing.
- Follow brand tokens in this template.
