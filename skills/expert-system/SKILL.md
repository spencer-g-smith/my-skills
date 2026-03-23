---
name: expert-system
description: Search and browse a curated repository of recent research and insights about business, AI development, economics, and corporate strategy. Query real-time macroeconomic data (GDP, unemployment, inflation, rates) and company financial data (income statements, balance sheets, cash flows, key metrics) by asking natural-language questions. Use when you need current intelligence from earnings transcripts, tech blogs, podcast transcripts, synthesized research, or when the user asks about any company's financials, stock metrics, or macroeconomic indicators.
---

# Expert System

Pull the latest business and AI development intelligence from the Expert System API. The system ingests public company earnings transcripts, blog posts, podcast transcripts, economics analysis, and business strategy content, then processes it into atomic takeaways and synthesized research insights. It also provides natural-language interfaces to macroeconomic (FRED) and company financial (Alpha Vantage) data.

## Authentication

All requests require a Bearer token. Set via skill env in `~/.openclaw/openclaw.json`:

```json5
{
  skills: {
    entries: {
      "expert-system": {
        env: { "EXPERT_SYSTEM_API_KEY": "esak_..." }
      }
    }
  }
}
```

## Workflows

### Ad-hoc Research

When the user asks about a specific topic (e.g., "what's happening with Zillow" or "latest on housing market"):

1. **Search**: Use `search` with a natural-language query to find relevant takeaways. This returns lightweight results (title, summary, IDs). Use `--recent` to favor newer content.
2. **Read takeaways**: Use `takeaways --ids` with IDs from search results to get the full takeaway text, references, and document URL.
3. **Always cite sources**: When presenting data or making claims retrieved from the Expert System, you must include the source name and a direct link to the original document provided in the takeaway or document metadata.
4. **If helpful; Read sources**: Use `documents --ids` with document IDs from takeaways to read the full source text.

### Passive News Briefing

When browsing for what's new or running as a recurring job:

1. **Research insights**: Use `research` to read the latest synthesized insights. These connect multiple takeaways into coherent analysis and are the highest-signal starting point.
2. **Recent takeaways**: Use `takeaways-recent` to scan the latest raw takeaways across all sources.
3. **Drill down**: Use `takeaways --ids` or `documents --ids` to go deeper on anything interesting.

### Company Financial Analysis

When the user asks about a company's financials, valuation, earnings, revenue, margins, balance sheet, cash flow, or any stock/company metric:

1. **Query financials**: Use `financial --query` with a natural-language question. The system resolves ticker symbols and retrieves the relevant data (overview, income statement, balance sheet, cash flow).
2. **Present results**: Format the returned data clearly, highlighting the specific metrics the user asked about.
3. **Combine with research**: For deeper context, also use `search` to find relevant takeaways about the company (e.g., earnings call analysis, strategy commentary).

Available financial data includes: company overview & key metrics (P/E, EPS, market cap, margins, growth rates, analyst targets), quarterly income statements, quarterly balance sheets, and quarterly cash flow statements.

### Macroeconomic Analysis

When the user asks about macroeconomic conditions, interest rates, inflation, employment, GDP, housing, or any economic indicator:

1. **Query macro data**: Use `macro --query` with a natural-language question. The system queries the relevant FRED series and returns the data.
2. **Present results**: Format the returned data clearly, highlighting trends and the specific indicators the user asked about.
3. **Combine with research**: For deeper context, also use `search` to find relevant expert takeaways on the macro topic.

Available macro data covers: GDP & real economy, labor market (unemployment, payrolls, JOLTS), inflation (CPI, PCE, trimmed-mean), wages & income, monetary policy & Fed liquidity, interest rates & yield curve, credit & financial stress, housing (starts, permits, prices, mortgage rates), and consumer sentiment.

## Commands

Base URL: `https://expert-system.starmode.dev/api/v1`

### 1. Semantic Search (primary entry point)

Search across all takeaways by meaning. Returns titles, summaries, and IDs for drill-down.

```bash
EXPERT_SYSTEM_API_KEY="$EXPERT_SYSTEM_API_KEY" python3 {baseDir}/scripts/query.py search --query "enterprise AI agent architecture"
EXPERT_SYSTEM_API_KEY="$EXPERT_SYSTEM_API_KEY" python3 {baseDir}/scripts/query.py search --query "procurement automation" --limit 20 --recent
```

- `--query TEXT` (required, natural-language search string)
- `--limit N` (optional, default 10, max 100)
- `--recent` (optional, time-weighted reranking to favor newer content)

### 2. Takeaways by ID

Fetch full takeaway text and references for specific IDs returned by search.

```bash
EXPERT_SYSTEM_API_KEY="$EXPERT_SYSTEM_API_KEY" python3 {baseDir}/scripts/query.py takeaways --ids tak_abc123,tak_def456
```

- `--ids` (required, comma-separated, max 50)

### 3. Recent Takeaways

Get the latest atomic takeaways sorted by publication date (newest first).

```bash
EXPERT_SYSTEM_API_KEY="$EXPERT_SYSTEM_API_KEY" python3 {baseDir}/scripts/query.py takeaways-recent --limit 10
```

- `--limit N` (optional, default 10, max 100)

### 4. Documents by ID

Fetch full source documents including article text.

```bash
EXPERT_SYSTEM_API_KEY="$EXPERT_SYSTEM_API_KEY" python3 {baseDir}/scripts/query.py documents --ids doc_xyz789,doc_abc123
```

- `--ids` (required, comma-separated, max 50)

### 5. Research Insights

Get AI-synthesized research insights with linked takeaways. Supports cursor pagination.

```bash
EXPERT_SYSTEM_API_KEY="$EXPERT_SYSTEM_API_KEY" python3 {baseDir}/scripts/query.py research --limit 5
EXPERT_SYSTEM_API_KEY="$EXPERT_SYSTEM_API_KEY" python3 {baseDir}/scripts/query.py research --date 2026-03-05
EXPERT_SYSTEM_API_KEY="$EXPERT_SYSTEM_API_KEY" python3 {baseDir}/scripts/query.py research --cursor <opaque_cursor>
```

- `--limit N` (optional, default 4, max 100)
- `--date YYYY-MM-DD` (optional, filter to single day UTC)
- `--cursor STRING` (optional, for pagination)

### 6. Macroeconomic Data Query

Query real-time macroeconomic data from FRED using natural language.

```bash
EXPERT_SYSTEM_API_KEY="$EXPERT_SYSTEM_API_KEY" python3 {baseDir}/scripts/query.py macro --query "what is the current unemployment rate and how has it trended over the past year"
EXPERT_SYSTEM_API_KEY="$EXPERT_SYSTEM_API_KEY" python3 {baseDir}/scripts/query.py macro --query "compare CPI and PCE inflation over the last 6 months"
EXPERT_SYSTEM_API_KEY="$EXPERT_SYSTEM_API_KEY" python3 {baseDir}/scripts/query.py macro --query "current fed funds rate and 10-year treasury yield"
```

- `--query TEXT` (required, natural-language macro question)

### 7. Company Financial Data Query

Query company financial data from Alpha Vantage using natural language.

```bash
EXPERT_SYSTEM_API_KEY="$EXPERT_SYSTEM_API_KEY" python3 {baseDir}/scripts/query.py financial --query "what is Apple's current P/E ratio and revenue growth"
EXPERT_SYSTEM_API_KEY="$EXPERT_SYSTEM_API_KEY" python3 {baseDir}/scripts/query.py financial --query "compare Microsoft and Google's operating margins and R&D spending"
EXPERT_SYSTEM_API_KEY="$EXPERT_SYSTEM_API_KEY" python3 {baseDir}/scripts/query.py financial --query "show me Tesla's quarterly cash flow from operations for the last 4 quarters"
```

- `--query TEXT` (required, natural-language financial question)

## Output

All commands output formatted markdown by default. Use `--raw` for JSON output suitable for piping.
