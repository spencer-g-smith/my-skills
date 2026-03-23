---
name: pr-description
description: Create clear, concise pull request descriptions from branch diffs and recent commits. Use when asked to draft or generate a PR description.
---

# PR Description

## Workflow

1. Identify the base branch (default `origin/main`).
2. Collect the change set:
   - `git status -sb` for clean/dirty state
   - `git log --oneline --decorate --reverse <base>..HEAD` for commit intent
   - `git diff <base>...HEAD` for file-level changes
3. Build the PR description:
   - Use `## Summary` and `## Test plan` sections
   - Keep summary to 1-3 bullets, focused on outcomes
   - Note new dependencies, scripts, or migrations explicitly
   - Call out behavior changes or data model updates
4. Test plan:
   - If tests were run, list exact commands
   - If not, say "Not run (not requested)"

## Output Template

```markdown
## Summary

- [Outcome-focused bullet]
- [Outcome-focused bullet]

## Test plan

- [e.g. `bun run build` passes]
```
