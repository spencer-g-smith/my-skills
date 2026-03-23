# Template: App (TanStack Start)

## Source
`~/Projects/_Templates/golden-app-template`

## Post-Scaffold Setup

After copying and running `bun install`, generate the route tree and verify build:

```bash
bunx @tanstack/router-cli generate
bun run build
```

**Recovery:** If build fails on fresh copy:
- Regenerate route tree: `bunx @tanstack/router-cli generate`
- Run formatter: `bun run format`
- Check lint errors: `bun run lint`

## CLAUDE.md Template

```markdown
# <app-name>

## Stack
- Framework: TanStack Start + Nitro
- UI: React 19
- Styling: Tailwind CSS v4
- Runtime: Bun

## Commands
- `bun install` — install dependencies
- `bun run build` — build (strict: types → prettier → eslint → vite build)
- `bun run dev` — dev server (port 3000)
- `bun run lint` — ESLint with auto-fix
- `bun run format` — Prettier
- `bun run test` — Vitest
- `bun run typecheck` — TypeScript type check only

## Code Quality Rules
- Lint incrementally as you write — don't defer all linting to the end
- Never disable linting rules (`eslint-disable`). Fix the underlying typing issue.
- Run checks when done: `npx tsc --noEmit && bun run lint && bun run format`
- `bun run build` is the full gate — zero lint warnings allowed (`--max-warnings 0`)

## Conventions
- Named exports only (default exports restricted by ESLint, except route files)
- Strict equality only (`===`, enforced by `eqeqeq`)
- Self-closing JSX components (`<Foo />` not `<Foo></Foo>`)
- Ternary-only conditional rendering (`x ? <C /> : null`, not `x && <C />`)
- Path alias: `#/*` maps to `./src/*`
- `noUncheckedIndexedAccess` — always handle `undefined` from array/object indexing
- Commits: `feat:`, `fix:`, `chore:` prefixes

## TanStack Router
- Route tree (`src/routeTree.gen.ts`) auto-regenerates via the Vite plugin when dev server is running or on build
- After adding/removing route files, run `bunx @tanstack/router-cli generate` if not using dev server
- Never hand-edit `src/routeTree.gen.ts`

## Design Principles
- Simple over clever — if removing something doesn't hurt, remove it
- Suggestive over exhaustive — don't over-explain in UI copy
- Would you stop scrolling for this? If not, rethink.
- Prefer simple, timeless UI over novelty
- Keep motion subtle, prioritize readability and spacing

## Project Notes
[Project-specific context — business purpose, key APIs, data model, etc.]
```
