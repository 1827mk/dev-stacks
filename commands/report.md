---
name: dev-stacks:report
description: Generate reports from Dev-Stacks data - session, dna, patterns, audit, health.
argument-hint: "[session|dna|patterns|audit|health] [--output PATH] [--format text|json|md]"
---

# /dev-stacks:report

Generate various reports from Dev-Stacks session data.

## Usage

```
/dev-stacks:report [type] [options]
```

## Arguments

| Argument | Description |
|----------|-------------|
| `type` | Report type: session, dna, patterns, audit, health (default: session) |

## Options

| Option | Description |
|--------|-------------|
| `--output PATH` | Save report to file |
| `--format TYPE` | Output format: text, json, md (default: text) |
| `--days N` | Days to include (for audit, default: 7) |

## Report Types

### session (default)

Generate summary of current/last session.

**Example:**
```
/dev-stacks:report session
```

**Output:**
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

### dna

Generate Project DNA documentation.

**Example:**
```
/dev-stacks:report dna
```

**Output:**
```
🧬 PROJECT DNA REPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PROJECT INFO
  Name: my-project
  Type: FULLSTACK
  Languages: TypeScript, JavaScript

ARCHITECTURE
  Frontend: React 18 + TypeScript
  Backend: Express.js + SQLite

PATTERNS DETECTED
  Count: 5
  ├── Form Validation (confidence: 0.92)
  ├── API Error Handling (confidence: 0.85)
  └── ...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### patterns

Analyze learned patterns.

**Example:**
```
/dev-stacks:report patterns
```

**Output:**
```
📚 PATTERN ANALYSIS REPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PATTERN STATISTICS
  Total Patterns: 5
  Average Confidence: 0.84
  Most Used: Form Validation (3 times)

PATTERN LIST
  1. Form Validation Pattern
     Confidence: 0.92 | Uses: 3
  2. API Error Handling Pattern
     Confidence: 0.85 | Uses: 2
  └── ...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### audit

Generate audit trail report.

**Example:**
```
/dev-stacks:report audit --days 7
```

**Output:**
```
📝 AUDIT REPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Period: Last 7 days

SUMMARY
  Total Actions: 156
  Successful: 152 (97.4%)
  Failed: 4 (2.6%)

TOOL USAGE
  ├── Read: 45 (28.8%)
  ├── Edit: 38 (24.4%)
  └── Bash: 32 (20.5%)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### health

Overall project health check.

**Example:**
```
/dev-stacks:report health
```

**Output:**
```
🏥 PROJECT HEALTH REPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
OVERALL SCORE: 85/100 ✅

BREAKDOWN
  DNA Quality: 90/100 ✅
  Pattern Memory: 80/100 ✅
  Code Health: 85/100 ✅
  Session Health: 90/100 ✅

RECOMMENDATIONS
  1. ✅ DNA is healthy and up-to-date
  2. ⚠️ Consider adding patterns for payment
  3. ✅ Audit trail is complete
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Saving Reports

Save to file with `--output`:
```
/dev-stacks:report dna --output .dev-stacks/reports/dna-report.md
```

## Output Formats

| Format | Flag | Use Case |
|--------|------|----------|
| text | `--format text` | Console viewing (default) |
| json | `--format json` | Programmatic processing |
| md | `--format md` | Documentation |

## Examples

```bash
# Quick session summary
/dev-stacks:report

# Full DNA documentation
/dev-stacks:report dna --format md --output docs/dna.md

# Pattern analysis
/dev-stacks:report patterns

# Last 30 days audit
/dev-stacks:report audit --days 30

# Health check
/dev-stacks:report health
```

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `mcp__filesystem__read_text_file` | Read DNA, checkpoint, logs |
| `mcp__filesystem__write_file` | Save reports |
| `mcp__memory__search_nodes` | Search patterns |
| `mcp__memory__read_graph` | Get all patterns |
