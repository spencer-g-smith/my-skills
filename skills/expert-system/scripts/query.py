#!/usr/bin/env python3
"""Expert System API client for querying takeaways, documents, and research."""

import argparse
import json
import os
import sys
import urllib.request
import urllib.error
import urllib.parse

BASE_URL = "https://expert-system.starmode.dev/api/v1"


def _get_api_key():
    api_key = os.environ.get("EXPERT_SYSTEM_API_KEY")
    if not api_key:
        print("Error: EXPERT_SYSTEM_API_KEY not set", file=sys.stderr)
        sys.exit(1)
    return api_key


def _handle_http_error(e):
    body = e.read().decode()
    try:
        err = json.loads(body)
        print(f"Error {e.code}: {err.get('error', body)}", file=sys.stderr)
    except json.JSONDecodeError:
        print(f"Error {e.code}: {body}", file=sys.stderr)
    sys.exit(1)


def api_get(path, params=None):
    api_key = _get_api_key()
    url = f"{BASE_URL}{path}"
    if params:
        filtered = {k: v for k, v in params.items() if v is not None}
        if filtered:
            url += "?" + urllib.parse.urlencode(filtered)

    req = urllib.request.Request(url, headers={
        "Authorization": f"Bearer {api_key}",
        "Accept": "application/json",
    })

    try:
        with urllib.request.urlopen(req) as resp:
            return json.loads(resp.read().decode())
    except urllib.error.HTTPError as e:
        _handle_http_error(e)


def api_post(path, body):
    api_key = _get_api_key()
    url = f"{BASE_URL}{path}"
    data = json.dumps(body).encode()

    req = urllib.request.Request(url, data=data, method="POST", headers={
        "Authorization": f"Bearer {api_key}",
        "Accept": "application/json",
        "Content-Type": "application/json",
    })

    try:
        with urllib.request.urlopen(req) as resp:
            return json.loads(resp.read().decode())
    except urllib.error.HTTPError as e:
        _handle_http_error(e)


def format_takeaway(t):
    lines = []
    lines.append(f"## {t['title']}")
    lines.append("")
    lines.append(t["takeaway"])
    lines.append("")
    doc = t.get("document", {})
    if doc:
        parts = []
        if doc.get("source"):
            parts.append(f"**Source:** {doc['source']}")
        if doc.get("title"):
            parts.append(f"**Document:** {doc['title']}")
        if doc.get("publicationDate"):
            parts.append(f"**Published:** {doc['publicationDate'][:10]}")
        if doc.get("link"):
            parts.append(f"**Link:** {doc['link']}")
        lines.append(" | ".join(parts))
    refs = t.get("takeawayReferences", [])
    if refs:
        lines.append("")
        lines.append("### References")
        for r in refs:
            lines.append(f"  [{r['referenceNumber']}] {r['reference']}")
    lines.append("")
    return "\n".join(lines)


def format_document(d):
    lines = []
    lines.append(f"## {d['title']}")
    lines.append("")
    if d.get("source"):
        lines.append(f"**Source:** {d['source']}")
    if d.get("publicationDate"):
        lines.append(f"**Published:** {d['publicationDate'][:10]}")
    if d.get("link"):
        lines.append(f"**Link:** {d['link']}")
    if d.get("description"):
        lines.append("")
        lines.append(f"> {d['description']}")
    if d.get("articleText"):
        lines.append("")
        lines.append("---")
        lines.append("")
        lines.append(d["articleText"])
    lines.append("")
    return "\n".join(lines)


def format_research(r):
    lines = []
    lines.append(f"## {r['title']}")
    lines.append(f"*{r['createdAt'][:10]}*")
    lines.append("")
    if r.get("summary"):
        lines.append(f"**Summary:** {r['summary']}")
        lines.append("")
    if r.get("insight"):
        lines.append("### Insight")
        lines.append(r["insight"])
        lines.append("")
    if r.get("research"):
        lines.append("### Research")
        lines.append(r["research"])
        lines.append("")
    takeaways = r.get("takeaways", [])
    if takeaways:
        lines.append("### Linked Takeaways")
        for t in takeaways:
            lines.append(f"- `{t['id']}` {t['title']}")
        lines.append("")
    return "\n".join(lines)


def format_search_result(s):
    lines = []
    lines.append(f"## {s['title']}")
    lines.append(f"`{s['id']}`")
    if s.get("summary"):
        lines.append("")
        lines.append(s["summary"])
    if s.get("documentId"):
        lines.append("")
        lines.append(f"*Document ID: `{s['documentId']}`*")
    lines.append("")
    return "\n".join(lines)


def cmd_search(args):
    if not args.query:
        print("Error: --query required", file=sys.stderr)
        sys.exit(1)
    params = {"query": args.query, "limit": args.limit}
    if args.recent:
        params["recent"] = "true"
    data = api_get("/takeaways/search", params)
    if args.raw:
        print(json.dumps(data, indent=2))
        return
    items = data.get("items", [])
    if not items:
        print("No results found.")
        return
    print(f"# Search Results ({len(items)} results)\n")
    for s in items:
        print(format_search_result(s))


def cmd_takeaways_recent(args):
    data = api_get("/takeaways/recent", {"limit": args.limit})
    if args.raw:
        print(json.dumps(data, indent=2))
        return
    items = data.get("items", [])
    if not items:
        print("No recent takeaways found.")
        return
    print(f"# Recent Takeaways ({len(items)} results)\n")
    for t in items:
        print(format_takeaway(t))


def cmd_takeaways(args):
    if not args.ids:
        print("Error: --ids required", file=sys.stderr)
        sys.exit(1)
    data = api_get("/takeaways", {"ids": args.ids})
    if args.raw:
        print(json.dumps(data, indent=2))
        return
    items = data.get("items", [])
    if not items:
        print("No takeaways found for the given IDs.")
        return
    print(f"# Takeaways ({len(items)} results)\n")
    for t in items:
        print(format_takeaway(t))


def cmd_documents(args):
    if not args.ids:
        print("Error: --ids required", file=sys.stderr)
        sys.exit(1)
    data = api_get("/documents", {"ids": args.ids})
    if args.raw:
        print(json.dumps(data, indent=2))
        return
    items = data.get("items", [])
    if not items:
        print("No documents found for the given IDs.")
        return
    print(f"# Documents ({len(items)} results)\n")
    for d in items:
        print(format_document(d))


def format_macro_result(data):
    lines = []
    lines.append("# Macroeconomic Data\n")
    series = data.get("seriesQueried", [])
    if series:
        lines.append(f"**FRED Series Queried:** {', '.join(series)}\n")
    for item in data.get("data", []):
        lines.append("---")
        lines.append(json.dumps(item, indent=2))
        lines.append("")
    return "\n".join(lines)


def format_financial_result(data):
    lines = []
    lines.append("# Financial Data\n")
    tickers = data.get("tickersQueried", [])
    if tickers:
        lines.append(f"**Tickers Queried:** {', '.join(tickers)}\n")
    for item in data.get("data", []):
        lines.append("---")
        lines.append(json.dumps(item, indent=2))
        lines.append("")
    return "\n".join(lines)


def cmd_macro(args):
    if not args.query:
        print("Error: --query required", file=sys.stderr)
        sys.exit(1)
    data = api_post("/query/macro", {"query": args.query})
    if args.raw:
        print(json.dumps(data, indent=2))
        return
    print(format_macro_result(data))


def cmd_financial(args):
    if not args.query:
        print("Error: --query required", file=sys.stderr)
        sys.exit(1)
    data = api_post("/query/financial", {"query": args.query})
    if args.raw:
        print(json.dumps(data, indent=2))
        return
    print(format_financial_result(data))


def cmd_research(args):
    params = {"limit": args.limit, "date": args.date, "cursor": args.cursor}
    data = api_get("/research", params)
    if args.raw:
        print(json.dumps(data, indent=2))
        return
    items = data.get("items", [])
    if not items:
        print("No research insights found.")
        return
    print(f"# Research Insights ({len(items)} results)\n")
    for r in items:
        print(format_research(r))
    next_cursor = data.get("nextCursor")
    if next_cursor:
        print(f"\n---\n**Next page cursor:** `{next_cursor}`")


def main():
    parser = argparse.ArgumentParser(description="Expert System API client")
    parser.add_argument("--raw", action="store_true", help="Output raw JSON")
    sub = parser.add_subparsers(dest="command", required=True)

    p_recent = sub.add_parser("takeaways-recent", help="Get recent takeaways")
    p_recent.add_argument("--limit", type=int, default=10)

    p_tak = sub.add_parser("takeaways", help="Get takeaways by ID")
    p_tak.add_argument("--ids", required=True, help="Comma-separated takeaway IDs")

    p_doc = sub.add_parser("documents", help="Get documents by ID")
    p_doc.add_argument("--ids", required=True, help="Comma-separated document IDs")

    p_search = sub.add_parser("search", help="Semantic search across takeaways")
    p_search.add_argument("--query", required=True, help="Natural-language search query")
    p_search.add_argument("--limit", type=int, default=10)
    p_search.add_argument("--recent", action="store_true", help="Favor newer content in ranking")

    p_res = sub.add_parser("research", help="Get research insights")
    p_res.add_argument("--limit", type=int, default=4)
    p_res.add_argument("--date", help="Filter by date (YYYY-MM-DD)")
    p_res.add_argument("--cursor", help="Pagination cursor")

    p_macro = sub.add_parser("macro", help="Query macroeconomic data (FRED)")
    p_macro.add_argument("--query", required=True, help="Natural-language macro question")

    p_fin = sub.add_parser("financial", help="Query company financial data")
    p_fin.add_argument("--query", required=True, help="Natural-language financial question")

    args = parser.parse_args()

    commands = {
        "search": cmd_search,
        "takeaways-recent": cmd_takeaways_recent,
        "takeaways": cmd_takeaways,
        "documents": cmd_documents,
        "research": cmd_research,
        "macro": cmd_macro,
        "financial": cmd_financial,
    }
    commands[args.command](args)


if __name__ == "__main__":
    main()
