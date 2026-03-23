# Template: Static (Astro)

## Source
`~/Projects/_Templates/golden-static-template`

## Post-Scaffold Setup

After copying and running `bun install`, verify build:

```bash
bun run build
```

No route generation step needed — Astro uses file-based routing automatically.

**Recovery:** If build fails on fresh copy:
- Check type errors: `bun run typecheck`
- Check lint errors: `bun run lint`
- Check formatting: `bun run format`

## CLAUDE.md Template

```markdown
# <app-name>

## Stack
- Framework: Astro 5
- Styling: Tailwind CSS v4
- Runtime: Bun

## Commands
- `bun install` — install dependencies
- `bun run build` — build (strict: types → prettier → eslint → vitest → astro build)
- `bun run dev` — dev server
- `bun run lint` — ESLint
- `bun run format` — Prettier
- `bun run typecheck` — TypeScript type check only
- `bun run test` — Vitest

## Code Quality Rules
- Lint incrementally as you write — don't defer all linting to the end
- Never disable linting rules (`eslint-disable`). Fix the underlying typing issue.
- Run checks when done: `npx tsc --noEmit && bun run lint && bun run format`
- `bun run build` is the full gate — zero lint warnings allowed (`--max-warnings 0`)

## Conventions
- `noUncheckedIndexedAccess` — always handle `undefined` from array/object indexing
- Commits: `feat:`, `fix:`, `chore:` prefixes
- Content-first — prefer static/server-rendered output, avoid unnecessary JS
- Pages go in `src/pages/` (Astro file-based routing)
- Prefer `.astro` components over framework components unless interactivity is needed

## Design Principles
- Simple over clever — if removing something doesn't hurt, remove it
- Suggestive over exhaustive — don't over-explain in copy
- Would you stop scrolling for this? If not, rethink.
- Prioritize readability and spacing
- Keep pages fast — static is the default, JS is the exception

## Project Notes
[Project-specific context — business purpose, content structure, etc.]
```
