# Research Briefing Procedure

Surface relevant external intelligence from the Expert System to support Spencer's active projects and keep him aware of notable new developments. Use the `/expert-system` skill for all API commands referenced below.

## When to run

Execute during Phase 8 of daily maintenance, after the daily objective and prioritized todos have been constructed.

## Part A — Active Search (project-targeted)

Goal: find external intelligence directly relevant to Spencer's in-flight projects.

### A1 — Derive search queries from Workbench projects

Scan `Coupa/Workbench/` for active projects. For each project, read the MOC or primary doc to understand the strategic themes — not the tactical next-actions, but the underlying domain (e.g., "Apache Iceberg for enterprise analytics", "AI agent platform architecture", "invoice processing automation").

Derive 2–3 search queries that represent the most externally-researchable themes across active projects. Good queries target areas where earnings transcripts, technical blogs, and industry analysis would provide useful signal.

**Do not query:**
- Tactical items (scheduling, follow-ups, internal approvals)
- Topics too specific to Coupa internals to have external coverage
- Themes that haven't changed since the last briefing — rotate queries across projects over time rather than repeating the same searches daily

### A2 — Search

For each query:

```bash
search --query "<query>" --recent --limit 5
```

Use `--recent` to favor newer content.

### A3 — Read and curate

Fetch full text for the most promising hits (up to 10 total across queries):

```bash
takeaways --ids <comma-separated IDs>
```

Select 2–4 items that meet this bar:
- **Relevant to an active project**: maps clearly to a Workbench initiative
- **Actionable or perspective-shifting**: teaches something, challenges an assumption, or provides data Spencer can use in his work
- **Not stale**: timely relative to the project's current phase

If fewer than 1 item clears the bar, omit Part A from the output entirely.

## Part B — Passive Scan (discovery)

Goal: surface notable recent content that Spencer should be aware of, even if it doesn't map to a specific project.

### B1 — Pull recent takeaways

```bash
takeaways-recent --limit 15
```

### B2 — Filter for relevance

Scan the results against Spencer's broad professional context:
- Procurement / supply chain technology
- Enterprise SaaS / B2B platform strategy
- AI agents, LLM infrastructure, applied AI in enterprise
- Data engineering, analytics platforms, data-driven product
- Competitive landscape (Coupa competitors, adjacent players)
- And anything else that you think Spencer would find interesting! (even if just for fun)

### B3 — Curate

Select 2–4 items that are genuinely interesting or worth knowing. The bar here is lower than Part A — these don't need to map to a specific project, but they should be things Spencer would want to have seen. Skip commodity news or overly generic takes.

If nothing notable surfaced in the last day, omit Part B from the output entirely.

## Output

Append as `### Research briefing` inside `## Griffin's Morning Brief` on today's daily note, after open loops / upcoming deadlines.

```markdown
### Research briefing

Opening commentary about your selections or potential ideas that these spark... (Keep it fun and imaginative, let's spark some inspiration)

**From your projects:**
- **[Insight title]** — 1-line summary with relevance to the project. [Source](url)
- ...

**Recent notable:**
- **[Insight title]** — 1-line summary of why it's interesting. [Source](url)
- ...
```

Rules:
- Lead each bullet with the insight, not the source name
- Include the source URL so Spencer can drill down
- For Part A items, note which project it relates to if not obvious
- Either section can be omitted independently if nothing clears the bar
- If both sections are empty, skip `### Research briefing` entirely
- Keep the entire section under 15 lines
