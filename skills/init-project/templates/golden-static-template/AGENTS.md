# AGENTS.md — Golden Static Template Rules

Use this template for static/content sites.

## Mission

Ship clean, fast Astro pages without bypassing quality gates.

## Required Commands

```bash
bun install
bun run build
```

## Build Gate (must pass)

`bun run build` must pass all checks:

- TypeScript (`tsc --noEmit`)
- Prettier (`--check`)
- ESLint (`--max-warnings 0`)
- Vitest
- Astro production build

## Working Rules

- Keep pages simple and content-first.
- Prefer server-rendered/static output; avoid unnecessary JS.
- Keep commits small and explicit (`feat:`, `fix:`, `chore:`).
- Never commit secrets.

## Deployment Notes

- Template intentionally has no Vercel project binding.
- For a new repo, configure deployment in that repo context.
