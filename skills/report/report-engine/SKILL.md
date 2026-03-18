---
name: report-engine
description: Generate reports from Dev-Stacks session data - session summary, DNA reports, pattern analysis, audit reports.
---

# Report Engine Skill

Generate various reports from Dev-Stacks data.

## Purpose

Create reports for:
1. Session summaries
2. DNA documentation
3. Pattern analysis
4. Audit trails
5. Project health

## Report Types

### 1. Session Summary Report

Generate summary of current/last session.

**Trigger**: `/dev-stacks:report session` or after task completion

**Output Format:**
```
📊 SESSION REPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Generated: 2026-03-18 12:00:00

SESSION INFO
  Session ID: abc123-def456
  Duration: 45 minutes
  Status: Completed

WORK COMPLETED
  Tasks: 2
  ├── ✅ Add email validation to login form
  └── ✅ Fix typo in README

FILES TOUCHED
  Modified: 2
  ├── src/auth/login.ts
  └── README.md

PATTERNS USED
  └── Form Validation Pattern (confidence: 0.92)

AGENTS ACTIVE
  ├── Thinker (10 turns)
  ├── Builder (15 turns)
  └── Tester (3 turns)

WORKFLOW BREAKDOWN
  ├── Quick: 1 task (50%)
  └── Standard: 1 task (50%)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 2. DNA Report

Generate Project DNA documentation.

**Trigger**: `/dev-stacks:report dna`

**Output Format:**
```
🧬 PROJECT DNA REPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Generated: 2026-03-18 12:00:00
Last Updated: 2026-03-18 11:30:00

PROJECT INFO
  Name: my-project
  Type: FULLSTACK
  Languages: TypeScript, JavaScript
  Frameworks: React, Express, SQLite

ARCHITECTURE
  Frontend: React 18 + TypeScript
  Backend: Express.js + SQLite
  Build: Vite
  Testing: Vitest

PATTERNS DETECTED
  Count: 5
  ├── Form Validation (confidence: 0.92)
  ├── API Error Handling (confidence: 0.85)
  ├── Component Structure (confidence: 0.78)
  ├── Authentication Flow (confidence: 0.95)
  └── Database Queries (confidence: 0.70)

RISK AREAS
  Count: 2
  ├── ⚠️ Authentication (high complexity)
  └── ⚠️ Payment (external dependencies)

KEY FILES
  Entry Points: 3
  ├── src/main.tsx
  ├── src/App.tsx
  └── server/index.ts

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 3. Pattern Analysis Report

Analyze learned patterns.

**Trigger**: `/dev-stacks:report patterns`

**Output Format:**
```
📚 PATTERN ANALYSIS REPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Generated: 2026-03-18 12:00:00

PATTERN STATISTICS
  Total Patterns: 5
  Average Confidence: 0.84
  Most Used: Form Validation (3 times)

PATTERN LIST
  1. Form Validation Pattern
     Confidence: 0.92 | Uses: 3 | Last: 2 days ago
     Keywords: validation, form, login, email

  2. API Error Handling Pattern
     Confidence: 0.85 | Uses: 2 | Last: 5 days ago
     Keywords: error, api, handling, response

  3. Component Structure Pattern
     Confidence: 0.78 | Uses: 1 | Last: 1 week ago
     Keywords: component, structure, react

  4. Authentication Flow Pattern
     Confidence: 0.95 | Uses: 4 | Last: 1 day ago
     Keywords: auth, login, session, jwt

  5. Database Queries Pattern
     Confidence: 0.70 | Uses: 2 | Last: 3 days ago
     Keywords: query, database, sql, sqlite

PATTERNS BY CATEGORY
  ├── ADD_FEATURE: 3 patterns
  ├── FIX_BUG: 1 pattern
  └── INVESTIGATE: 1 pattern

RECOMMENDATIONS
  ✅ Strong patterns: Authentication Flow
  ⚠️ Needs reinforcement: Database Queries
  ❌ Consider removal: None

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 4. Audit Report

Generate audit trail report.

**Trigger**: `/dev-stacks:report audit [--days 7]`

**Prerequisites:**
- Requires `.dev-stacks/logs/audit.jsonl` file
- If file doesn't exist, show: "⚠️ No audit data available. Audit logging starts with next session."

**Output Format:**
```
📝 AUDIT REPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Generated: 2026-03-18 12:00:00
Period: Last 7 days

SUMMARY
  Total Actions: 156
  Successful: 152 (97.4%)
  Failed: 4 (2.6%)

TOOL USAGE
  ├── Read: 45 (28.8%)
  ├── Edit: 38 (24.4%)
  ├── Bash: 32 (20.5%)
  ├── Write: 25 (16.0%)
  └── Others: 16 (10.3%)

FILES MODIFIED
  Count: 12 unique files
  Most Modified:
  ├── src/auth/login.ts (5 edits)
  └── src/components/Form.tsx (3 edits)

GUARD BLOCKS
  Count: 2
  ├── Scope Guard: 1 (package.json)
  └── Secret Scanner: 1 (API key detected)

ERRORS
  Count: 4
  ├── File not found: 2
  └── Permission denied: 2

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 5. Project Health Report

Overall project health check.

**Trigger**: `/dev-stacks:report health`

**Output Format:**
```
🏥 PROJECT HEALTH REPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Generated: 2026-03-18 12:00:00

OVERALL SCORE: 85/100 ✅

BREAKDOWN
  DNA Quality: 90/100 ✅
  ├── Fresh: Yes (updated 2 hours ago)
  ├── Complete: Yes (all sections)
  └── Accurate: High confidence

  Pattern Memory: 80/100 ✅
  ├── Patterns: 5 learned
  ├── Avg Confidence: 0.84
  └── Coverage: Good

  Code Health: 85/100 ✅
  ├── Tests: Configured
  ├── Linting: Configured
  └── Documentation: Present

  Session Health: 90/100 ✅
  ├── Checkpoints: Regular
  ├── Audit Log: Active
  └── Backups: Recent

RISK ASSESSMENT
  ├── Authentication: ⚠️ Medium Risk
  │   └─ Recommendation: Add more patterns
  └── Payment: ⚠️ Medium Risk
      └─ Recommendation: Manual review recommended

RECOMMENDATIONS
  1. ✅ DNA is healthy and up-to-date
  2. ⚠️ Consider adding patterns for payment
  3. ✅ Audit trail is complete
  4. ✅ Session recovery available

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Command Integration

Add to `/dev-stacks:report` command:

```
/dev-stacks:report [type] [options]

Types:
  session   - Session summary (default)
  dna       - DNA documentation
  patterns  - Pattern analysis
  audit     - Audit trail [--days N]
  health    - Project health check

Options:
  --output PATH  - Save report to file
  --format TYPE  - Output format (text, json, markdown)
  --days N       - Days to include (for audit)
```

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `mcp__filesystem__read_text_file` | Read DNA, checkpoint, audit log |
| `mcp__filesystem__write_file` | Save report to file |
| `mcp__memory__search_nodes` | Search patterns (fallback: return empty) |
| `mcp__memory__read_graph` | Get all patterns (fallback: return empty) |

## Fallback Behavior

| Data Source | Fallback |
|-------------|----------|
| `mcp__memory__*` tools | Return empty pattern list, continue report |
| `.dev-stacks/dna.json` | Show "DNA not initialized" message |
| `.dev-stacks/checkpoint.json` | Show "No session data" message |
| `.dev-stacks/logs/audit.jsonl` | Show "No audit data available" message |

## Output Formats

| Format | Description |
|--------|-------------|
| `text` | Console-friendly (default) |
| `json` | Structured data |
| `markdown` | Documentation format |

## Notes

- Reports are generated from live data
- Can be saved to `.dev-stacks/reports/` directory
- Audit reports can span multiple sessions
- Health report includes recommendations
