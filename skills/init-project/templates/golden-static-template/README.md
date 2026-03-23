# Golden Static Template (Astro)

Content-first Astro template for Spencer projects.

## Stack

- Astro
- Tailwind CSS v4
- TypeScript strict + `noUncheckedIndexedAccess`
- ESLint typed rules (`--max-warnings 0`)
- Prettier (+ Astro + Tailwind plugins)
- Vitest
- Bun

## Quick Start

```bash
bun install
bun run dev
```

## Quality Gate (required before deploy)

```bash
bun run build
```

`bun run build` runs, in order:

1. `tsc --noEmit`
2. `prettier --check .`
3. `eslint . --max-warnings 0`
4. `vitest run`
5. `astro build`

If any step fails, fix before deploying.

## Project Layout

```text
src/
  pages/
  styles/
public/
```

## Deploy

No Vercel link is included in this template by design.
When cloning for a new project, connect deployment target in the project repo only.
