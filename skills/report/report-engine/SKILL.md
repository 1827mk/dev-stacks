---
name: report-engine
description: Generate reports from Dev-Stacks data. Session, DNA, patterns, audit, health.
---

# Report Engine

Generate reports from `.dev-stacks/` data.

## Report Types

| Type | Command | Data Source |
|------|---------|-------------|
| Session | `/dev-stacks:report session` | checkpoint.json |
| DNA | `/dev-stacks:report dna` | dna.json |
| Patterns | `/dev-stacks:report patterns` | MCP memory |
| Audit | `/dev-stacks:report audit --days 7` | logs/audit.jsonl |
| Health | `/dev-stacks:report health` | All sources |

## Output Format

```
[TYPE] REPORT
Generated: [timestamp]

SUMMARY
[key metrics]

BREAKDOWN
- [item]: [value]

RECOMMENDATIONS
1. [rec]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Session Report
- Tasks completed
- Files touched
- Agents active
- Workflow breakdown

## DNA Report
- Project info (type, languages, frameworks)
- Architecture summary
- Risk areas
- Key files

## Pattern Report
- Pattern count + confidence
- Usage frequency
- Category breakdown
- Recommendations

## Audit Report
- Total actions
- Tool usage breakdown
- Guard blocks
- Errors

## Health Report
- DNA quality score
- Pattern memory score
- Code health score
- Risk assessment

## Options
- `--output PATH` - save to file
- `--format text|json|md` - output format
- `--days N` - for audit reports

## Fallbacks
| Source Missing | Action |
|----------------|--------|
| dna.json | Show "Run /dev-stacks:init" |
| audit.jsonl | Show "No audit data" |
| MCP memory | Return empty patterns |

## MCP Tools
- `read_text_file` - read data files
- `write_file` - save reports
- `memory/search_nodes` - search patterns (optional)
