# Daily Maintenance Runbook v2

## Guiding Principles
This system must be **self-sustaining, simple, and clean**.
- **Update over create.** Maintain and enrich existing notes rather than spawning new ones. Every new file is a maintenance burden.
- **Minimize bloat.** If information already lives somewhere, link to it — don't duplicate it. Keep notes concise and factual.
- **Keep it running.** The vault should stay healthy with zero manual intervention. When in doubt, do less — a skipped optional step is better than a broken run.

## Timing
This job runs at **4 AM**. All phases process **yesterday's** content. Use yesterday's date for inbox processing, archiving, and the daily report. Use today's date for Phase 8 (updating today's daily note).

## Weekend Mode
Check the current day of the week. On **Saturday and Sunday**, apply these adjustments:

| Phase | Weekend adjustment |
|---|---|
| Phase 3 (Synthesize & Route) | Route normally but don't expect Coupa execution content. Bias toward Personal/, Workshop/, and reading material destinations. |
| Phase 4 (To Do's) | Add new items and delete completed items as normal. **Skip** stale flagging. Do not surface Coupa work items in any output. |
| Phase 5 (Workbench Hygiene) | **Skip entirely.** |
| Phase 6 (Daily Report) | Write as usual. On Saturday, "Tomorrow" should not pull Coupa work items. On Sunday, "Tomorrow" resumes pulling Coupa items since Monday is a workday. |
| Phase 7 (Morning Report) | Send only if something material happened. Otherwise stay silent. |
| Phase 8 (Morning Brief) | Daily objective should be personal/rest/family-oriented. Pull todos only from personal items, reading queue, or Workshop — not Coupa. On **Sunday**, include a light Monday preview (top 2–3 Coupa items for the week ahead). |

## Inputs
- Vault root: `~/Documents/Griffin/`
- Inbox root: `Inbox/` (process **all** items from yesterday)
- Daily archive root: `Daily/Archive/YYYY-MM-DD/` for non-daily inbox items (yesterday's date)
- Yesterday's daily note: `Inbox/YYYY-MM-DD.md` (yesterday's date)
- Today's daily note: `Inbox/YYYY-MM-DD.md` (today's date — already exists via Obsidian)

---

## Phase 1 — Read & Orient

1. **Read every file in `Inbox/`.**

2. **Extract Spencer's explicit instructions first.**
   The daily note (`Inbox/YYYY-MM-DD.md`) contains a `## Notes for Griffin` section. These are direct orders. Parse them into a checklist and execute them during this run (or note them as carried-forward if they require future action). Spencer's instructions take priority over all automated sweeps below.

3. **Map daily capture sections to actions.**
   The daily note template has four sections. Each maps to specific downstream work:

   | Daily note section | Action |
   |---|---|
   | `## Notes for Griffin` | Execute instructions; carry forward what can't be done this run |
   | `## Meeting notes` | Route to `Coupa/1-on-1s/<Name>/` or create standalone meeting notes; extract action items to `To Do's.md` |
   | `## Important exchanges` | Route to People notes, Context, or Workbench as appropriate; extract action items |
   | `## Other` | Route using standard Coupa routing test (Phase 3) |

---

## Phase 2 — Archive Raw Inbox Files

Move raw inbox files to the daily record. This is mechanical — no synthesis, no routing decisions.

- Daily capture (`Inbox/YYYY-MM-DD.md`) → `Daily/Raw/YYYY-MM-DD.md`
- All other inbox files → `Daily/Archive/YYYY-MM-DD/`
- If Inbox contains only the daily capture, do not create `Daily/Archive/YYYY-MM-DD/`

After this phase, `Inbox/` is empty. The raw files are preserved as-is in `Daily/` for the historical record.

---

## Phase 3 — Synthesize & Route New Artifacts

Using the content read in Phase 1, create or update notes in their canonical destinations. These are **new or updated artifacts** — not the raw files themselves.

### Routing table

| Synthesized content | Destination |
|---|---|
| 1:1 / meeting content with a named person | `Coupa/1-on-1s/<Name>/YYYY-MM-DD.md` |
| People updates (role, context, relationship notes) | `Coupa/People/` or `Personal/People/` |
| Action items | `To Do's.md` |
| Durable Coupa business context (see routing test) | `Coupa/Context/` |
| Active/in-flight Coupa execution docs (see routing test) | `Coupa/Workbench/` |
| Completed/paused/superseded workbench docs | `Coupa/Archive/` |
| Other project/context updates | Relevant `Workshop/` or `Personal/` notes |
| New durable topics | Create claim-based note in appropriate directory |

### Coupa routing test (required)

When routing Coupa-related content, decide destination using this test:

- **`Coupa/Context/`** if the content captures durable business context: strategy, market dynamics, stable operating facts, enduring architecture/data truths.
  Rule of thumb: expected usefulness >30 days beyond a single project.

- **`Coupa/Workbench/`** if the content is execution-in-flight: meeting prep, drafts, active plans, temporary analysis, project work products.

- **`Coupa/Archive/`** when workbench content is complete, paused, superseded, or stale by archive criteria.

### Tags (apply while routing)

**`Coupa/Context/`** — Must include `#coupa` + at least one of: `#strategy` `#market` `#product` `#pricing` `#analytics` `#data` `#architecture` `#networkeffect` `#ai` `#engineering`. Optional: `#decision`.

**`Coupa/Workbench/`** — Must include `#coupa` + `#work` + at least one of: `#project` `#planning` `#meeting`. Add `#decision`, `#dependency`, or `#blocker` when applicable.

**`Coupa/Archive/`** — Preserve existing tags. Do not retag unless clearly incorrect.

**People notes** — Include `#person`. Add `#coupa` for work contacts.

Tag hygiene: ensure required tags on new/updated notes. Remove obvious synonyms. Do not perfect untouched legacy notes.

### Links & navigation (maintain while routing)
- Add forward `[[wikilinks]]` and backlinks from new/updated notes
- Fix broken links encountered during the run
- Update relevant `_MOC.md` files only when navigation meaningfully changed
- Connect obvious orphans

### Inbox verification
After all routing is complete, verify no unprocessed items from yesterday remain in `Inbox/`. Today's daily note (created in Phase 8) is expected.

---

## Phase 4 — Maintain To Do's

Update `To Do's.md` with the following actions:

**To-do quality gate:** Each item must be a discrete action completable in one session. Multi-step projects, initiatives, and ongoing responsibilities belong in Workbench notes — extract only the next concrete action into `To Do's.md`.

1. **Add** new action items at the top of the relevant section with a creation date: `- [ ] Do the thing (YYYY-MM-DD)`
2. **Delete completed items** — remove any line marked `[x]`. Log each deleted item in the daily report so there's an audit trail.
3. **Deduplicate** — if a new item matches an existing one, merge rather than double-list. Keep the older date.
4. **Flag stale items** — if `today - creation_date > 14 days` and no mention in recent daily notes, append `(stale)` so Spencer can triage.

---

## Phase 5 — Workbench & Context Hygiene

### Workbench sweep (`Coupa/Workbench/`)

Review every item in Workbench against the archive criteria. For each item, pick one action:

| Action | When |
|---|---|
| **Keep active** | Has open loops, recent updates, or upcoming deadlines |
| **Promote to Context** | Contains durable insight that outlives the project; extract the insight into a claim-based note in `Coupa/Context/`, leave or archive the original |
| **Archive** | Meets any archive criterion (see below) |

Record all promotions and archives in the daily report under the relevant section.

### Archive criteria (Coupa Workbench)

Move a Workbench note/folder to `Coupa/Archive/` if **any** condition is true:
- Explicitly complete, paused, or superseded
- Meeting-prep note is past meeting date and follow-ups are integrated elsewhere
- No meaningful update for 14+ days and no active open loop remains
- Initiative has a clear successor note/workspace

When archiving a folder, move the entire folder including any `_MOC.md` inside it.

Before archiving, add a one-line status at the top of the note:
```
Status: archived on YYYY-MM-DD — reason: <complete|paused|superseded|stale>
```

### Context review (`Coupa/Context/`)

Check Context notes **only when touched by today's routing** (not a full sweep every night). When reviewing a Context note:
- Verify claims still hold — if outdated by today's information, update or add a `> [!warning] Outdated as of YYYY-MM-DD` callout
- Ensure links to related Workbench/People notes are current
- Do not archive Context notes (they are durable by definition); update them instead

---

## Phase 6 — Create Daily Report

- File: `Daily/Reports/YYYY-MM-DD-report.md`
- Template: `Templates/Daily Report Template.md`
- Objective: searchable record of Spencer's day (not agent activity)
- Sources: inbox content + linked notes + known day context + work completed in Phases 2-5

### Required sections (match template exactly)

- **Today** — What Spencer worked on and accomplished.
- **Key meetings/conversations** — Who, what was discussed, what mattered.
- **Decisions** — Anything that was decided or committed to.
- **Completed** — Items removed from `To Do's.md` this run (audit trail for deleted `[x]` lines).
- **Open loops** — Unresolved items, waiting-on's, and items requiring follow-up. Pull from: today's meetings, inbox content, and any pre-existing open loops that remain unresolved.
- **Tomorrow** — Construct from these sources, in priority order:
  1. Explicit instructions from Spencer's `## Notes for Griffin` (carried forward)
  2. Open loops from today that have a next action
  3. Incomplete items in `To Do's.md` with time sensitivity
  4. Upcoming meetings or deadlines from context
- **Vault Ops** — Agent operations log for this run. Include:
  - Spencer's instructions received and status (done / carried forward)
  - Inbox files processed (count + names)
  - Notes created/updated (with paths)
  - Tags applied/cleaned
  - To Do changes (added / deleted / flagged stale)
  - Archives written (with reasons)
  - Promotions from Workbench to Context (if any)
  - MOC updates

### Writing rules
- Summarize Spencer's activity and outcomes, not agent maintenance actions
- Use `[[wikilinks]]` liberally to relevant notes, people, and artifacts
- Keep bullets concise and factual

---

## Phase 7 — Morning Griffin Report

Send a concise WhatsApp notification that daily maintenance is complete. Point Spencer to the daily report for full details:

- Brief summary of what was notable (1-3 lines max)
- Path to today's daily report: `Daily/Reports/YYYY-MM-DD-report.md`

The detailed operations log lives in the report's `## Vault Ops` section — do not duplicate it in WhatsApp.

---

## Phase 8 — Create/Update Today's Daily Note

- **File**: `Inbox/YYYY-MM-DD.md` (today's date)
- **Action**: If the file doesn't exist, create it from `Templates/Daily Note Template.md`. If it already exists (e.g. Obsidian created it, or Spencer captured something overnight), preserve any existing content.

### Append a `## Griffin's Morning Brief` section to the bottom of the note with:
1. **Daily objective** — One sentence: "Today's objective: ..." synthesized from the highest-priority open loops, upcoming meetings, and time-sensitive items. This should answer "what would make today a win?"
2. **Prioritized todos** — The top 3–5 most important items from `To Do's.md`, ordered by urgency/impact. Include carried-forward instructions from yesterday's `## Notes for Griffin`.
3. Open loops from yesterday that have a next action
4. Upcoming meetings or deadlines from context

---

## Definition of Done

- [ ] Spencer's instructions executed or carried forward
- [ ] No unprocessed items from yesterday remain in Inbox
- [ ] Raw inbox archived to `Daily/Raw/` and `Daily/Archive/` as appropriate
- [ ] Content routed, tagged, and linked per Phase 3 rules
- [ ] `To Do's.md` updated (new items, completed deleted, stale flagged, deduped)
- [ ] Workbench sweep completed (keep/promote/archive)
- [ ] Daily report written in `Daily/Reports/` as Spencer-day summary
- [ ] Today's daily note created/updated with morning brief
- [ ] WhatsApp notification sent (best-effort)
