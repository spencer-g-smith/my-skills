---
name: vault-ops
description: Manage Spencer's notes system end-to-end. Use whenever adding to, reading from, or organizing Spencer's notes, todos, and knowledge base. This is the operational source of truth for AI vault work.
---

# Vault Ops

Use this as the single operating contract for AI vault operations. 

## Source of Truth
- This skill + files under `references/` are the operational source of truth.
- Prefer Obsidian CLI (`obsidian`) for vault operations. Use direct filesystem edits only when needed.

## Obsidian CLI Quick Reference

| Command | Use |
|---|---|
| `obsidian search query="..." path="Coupa/"` | Find notes by content (optionally scoped to folder) |
| `obsidian tags counts sort=count` | Audit tag usage vault-wide |
| `obsidian tags path="Coupa/Context/note.md"` | Check tags on a specific file |
| `obsidian backlinks file="Note Name"` | Check what links to a note |
| `obsidian unresolved` | Find broken wikilinks |
| `obsidian tasks todo` | List all open tasks |
| `obsidian tasks done` | List completed tasks |
| `obsidian append path="To Do's.md" content="- [ ] Item (YYYY-MM-DD)"` | Add a to-do |
| `obsidian task path="To Do's.md" line=N done` | Mark a task complete |

Run `obsidian help` for the full command list.

## Core Philosophy
- Treat the vault as a thinking system, not a file dump.
- Capture first, organize second.
- Prefer deep linked notes over shallow note sprawl.
- Note titles should be claims, not generic topics.

## Directory Model (Current)
- `Inbox/` = universal capture, processed to Inbox Zero daily.
- `Daily/Raw/` = immutable archived daily notes from inbox (date-titled).
- `Daily/Archive/` = archived non-daily inbox artifacts.
- `Daily/Reports/` = daily temporal index and summary of what changed.
- `Coupa/Context/` = durable business context (strategy, market dynamics, operating facts).
- `Coupa/Workbench/` = active in-flight work docs.
- `Coupa/Archive/` = no-longer-in-flight Coupa work.
- `Coupa/People/`, `Coupa/1-on-1s/`, `Coupa/AI Roundup/`, `Coupa/Runbook/` = stable functional areas.

## Orientation Pattern
1. Scan relevant folders for current state.
2. Read the relevant `_MOC.md` for navigation and priority context.
3. Follow key `[[wikilinks]]` before making edits.

## Routing Rules
- `Coupa/Context/`: durable, non-project business truths.
- `Coupa/Workbench/`: active execution artifacts.
- `Coupa/Archive/`: complete/paused/superseded workbench items.
- `Workshop/`: builds/projects outside Coupa day-job execution.
- `Personal/`: life/family/finance/self-development.

## Link Governance
- Add natural inline `[[wikilinks]]` while writing (err on over-linking).
- Preserve and improve backlinks when updating notes.
- Fix broken links when encountered.
- Update relevant `_MOC.md` only when navigation meaningfully changes.

## Tag System (Atomic + Governed Core)
Use tags as a cross-cutting topic layer.
Folders encode lifecycle/state; tags encode meaning.

### Tag model
- Prefer atomic tags (e.g., `#strategy`, `#market`, `#dependency`).
- Additional ad-hoc tags are allowed.
- Govern and keep consistent the core tag set below.

### Core governed tags

**Coupa knowledge**
- `#coupa`
- `#strategy`
- `#market`
- `#pricing`
- `#product`
- `#analytics`
- `#data`
- `#architecture`
- `#networkeffect`
- `#ai`
- `#engineering`

**Execution / operations**
- `#work`
- `#project`
- `#planning`
- `#meeting`
- `#meeting-prep`
- `#decision`
- `#dependency`
- `#blocker`

**People**
- `#person`

### Tag governance rules
1. Use 3–6 tags per note.
2. Avoid synonyms if a core tag already exists.
3. Keep core tags stable; optional tags may sprawl.
4. If a non-core tag becomes frequent, consider promoting it to core.

## Conventions
- Dates: `YYYY-MM-DD`
- People notes: one file per person (`Coupa/People` or `Personal/People`).
- 1:1 notes: dated files per person in `Coupa/1-on-1s/<Name>/YYYY-MM-DD.md`.
- Daily raw capture: `Inbox/YYYY-MM-DD.md`
- Daily reports: `Daily/Reports/YYYY-MM-DD-report.md`
- Use claim-based note filenames.
- Do not duplicate filename/title as an H1 inside note content.
- Tasks live in `To Do's.md`. Format: `- [ ] Item (YYYY-MM-DD)`. Completed `[x]` items are deleted nightly (logged in daily report).

## Knowledge Base Governance
When Spencer asks to save reading/learning material (article, X post, link, etc), use:
- `references/knowledge-base-governance.md`

## Nightly Maintenance
For nightly vault maintenance runs, execute:
- `references/daily-maintenance.md`

## Weekly Maintenance
For weekly knowledge-base distillation runs, execute:
- `references/weekly-maintenance.md`
