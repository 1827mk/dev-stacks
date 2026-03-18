---
name: SessionStart
description: Initialize Dev-Stacks session - load DNA, patterns, and prepare for work.
---

# SessionStart Hook

Executed when Claude Code session starts.

## Purpose

Initialize Dev-Stacks environment:
1. Create `.dev-stacks/` directory structure
2. Initialize logging system
3. Load Project DNA from `.dev-stacks/dna.json`
4. Load patterns from MCP Memory
5. Load checkpoint from `.dev-stacks/checkpoint.json`
6. Display welcome message with status

## Directory Structure

Create on first run:
```
.dev-stacks/
├── logs/
│   ├── session-YYYY-MM-DD-HHMMSS.log  # Current session log
│   └── audit.jsonl                      # Audit trail
├── dna.json                             # Project DNA
├── checkpoint.json                      # Session checkpoint
└── config.json                          # Local config (optional)
```

## Execution Steps

### Step 1: Create Directory Structure + LOG

**ALWAYS OUTPUT TO CONSOLE:**
```
🔍 [DEV-STACKS] Session Start - Initializing...
```

Check and create directories:
```
.dev-stacks/           # Main directory
.dev-stacks/logs/      # Log files
```

**LOG TO FILE (`.dev-stacks/logs/session-YYYY-MM-DD-HHMMSS.log`):**
```
[2026-03-18 10:00:00] [INFO] ═══════════════════════════════════════════════════
[2026-03-18 10:00:00] [INFO] DEV-STACKS SESSION START
[2026-03-18 10:00:00] [INFO] Session ID: abc123-def456
[2026-03-18 10:00:00] [INFO] Project: /path/to/project
[2026-03-18 10:00:00] [INFO] ═══════════════════════════════════════════════════
[2026-03-18 10:00:00] [INFO] Step 1/5: Creating directory structure...
[2026-03-18 10:00:00] [INFO]   └─ Created: .dev-stacks/
[2026-03-18 10:00:00] [INFO]   └─ Created: .dev-stacks/logs/
```

### Step 2: Load Project DNA + LOG

Read `.dev-stacks/dna.json`:
- If exists, load project knowledge
- If not, create initial DNA by scanning project

**CONSOLE:**
```
🔍 [DEV-STACKS] Step 2/5: Loading DNA...
   └─ Status: ✅ Loaded (or 🆕 Created new)
```

**LOG FILE:**
```
[2026-03-18 10:00:01] [INFO] Step 2/5: Loading DNA...
[2026-03-18 10:00:01] [INFO]   └─ Source: .dev-stacks/dna.json
[2026-03-18 10:00:01] [INFO]   └─ Project type: TypeScript/Node
[2026-03-18 10:00:01] [INFO]   └─ Patterns: 5
[2026-03-18 10:00:01] [INFO]   └─ Risk areas: 2
```

### Step 3: Load Patterns + LOG

Query MCP Memory for patterns:
- Search for entities with type "dev-stacks-pattern"
- Load pattern count and confidence

**CONSOLE:**
```
🔍 [DEV-STACKS] Step 3/5: Loading patterns...
   └─ Found: 5 patterns (or 0 patterns)
```

**LOG FILE:**
```
[2026-03-18 10:00:02] [INFO] Step 3/5: Loading patterns from MCP Memory...
[2026-03-18 10:00:02] [INFO]   └─ Patterns found: 5
[2026-03-18 10:00:02] [INFO]   └─ Top pattern: "Form Validation" (0.92)
```

### Step 4: Load Checkpoint + LOG

Read `.dev-stacks/checkpoint.json`:
- If exists, check if session matches
- If different session, offer to restore or start fresh

**CONSOLE:**
```
🔍 [DEV-STACKS] Step 4/5: Loading checkpoint...
   └─ Status: ✅ Fresh session (or 🔄 Previous session found)
```

**LOG FILE:**
```
[2026-03-18 10:00:03] [INFO] Step 4/5: Loading checkpoint...
[2026-03-18 10:00:03] [INFO]   └─ Previous session: None (fresh start)
```

Or if previous session:
```
[2026-03-18 10:00:03] [INFO] Step 4/5: Loading checkpoint...
[2026-03-18 10:00:03] [INFO]   └─ Previous session: xyz789 (2 hours ago)
[2026-03-18 10:00:03] [INFO]   └─ Offering recovery options...
```

### Step 5: Display Welcome + LOG

**CONSOLE:**
```
🚀 DEV-STACKS INITIALIZED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Project: [name]
DNA: ✅ Loaded ([patterns] patterns, [risks] risk areas)
Session: [session_id]
Log: .dev-stacks/logs/session-YYYY-MM-DD-HHMMSS.log

Ready for work. Just describe what you need.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**LOG FILE:**
```
[2026-03-18 10:00:04] [INFO] Step 5/5: Initialization complete!
[2026-03-18 10:00:04] [INFO] ═══════════════════════════════════════════════════
[2026-03-18 10:00:04] [INFO] SESSION READY - Waiting for user input
[2026-03-18 10:00:04] [INFO] ═══════════════════════════════════════════════════
```

## First Run Initialization

If `.dev-stacks/` doesn't exist:

**CONSOLE:**
```
🚀 DEV-STACKS FIRST RUN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Setting up Dev-Stacks...

Creating:
  ✅ .dev-stacks/ directory
  ✅ .dev-stacks/logs/ directory
  ✅ dna.json (scanning project...)
  ✅ checkpoint.json (fresh session)
  ✅ logs/session-YYYY-MM-DD-HHMMSS.log

📚 Project DNA built:
  • Type: [project type]
  • Languages: [languages]
  • Frameworks: [frameworks]
  • Patterns detected: [count]

Ready for work. Just describe what you need.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**LOG FILE:**
```
[2026-03-18 10:00:00] [INFO] ═══════════════════════════════════════════════════
[2026-03-18 10:00:00] [INFO] DEV-STACKS FIRST RUN - Creating new installation
[2026-03-18 10:00:00] [INFO] ═══════════════════════════════════════════════════
[2026-03-18 10:00:00] [INFO] Creating directory: .dev-stacks/
[2026-03-18 10:00:00] [INFO] Creating directory: .dev-stacks/logs/
[2026-03-18 10:00:01] [INFO] Scanning project for DNA...
[2026-03-18 10:00:05] [INFO] DNA scan complete:
[2026-03-18 10:00:05] [INFO]   └─ Type: TypeScript/Node
[2026-03-18 10:00:05] [INFO]   └─ Languages: TypeScript, JavaScript
[2026-03-18 10:00:05] [INFO]   └─ Frameworks: React, Express
[2026-03-18 10:00:05] [INFO]   └─ Patterns: 3
[2026-03-18 10:00:05] [INFO] ═══════════════════════════════════════════════════
[2026-03-18 10:00:05] [INFO] INITIALIZATION COMPLETE
[2026-03-18 10:00:05] [INFO] ═══════════════════════════════════════════════════
```

## Log File Format

Each session creates a new log file: `session-YYYY-MM-DD-HHMMSS.log`

**Log levels:**
- `[INFO]` - Normal operations
- `[WARN]` - Warnings (non-critical)
- `[ERROR]` - Errors (critical)
- `[DEBUG]` - Debug info (verbose)

**Example log entry:**
```
[2026-03-18 10:30:15] [INFO] [UserPromptSubmit] Intent detected: FIX_BUG
[2026-03-18 10:30:16] [INFO] [UserPromptSubmit] Complexity: 0.12 (Quick)
[2026-03-18 10:30:17] [INFO] [PostToolUse] Tool: Edit | File: README.md | Success
```

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `mcp__filesystem__get_file_info` | Check if files exist |
| `mcp__filesystem__read_text_file` | Load DNA, checkpoint |
| `mcp__filesystem__write_file` | Create DNA, checkpoint, logs |
| `mcp__filesystem__directory_tree` | Scan project structure |
| `mcp__filesystem__create_directory` | Create .dev-stacks directories |
| `mcp__memory__search_nodes` | Load patterns |

## Recovery Offer

If previous session found:

**CONSOLE:**
```
🔄 SESSION RECOVERY AVAILABLE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Found previous session: [session_id]
Last activity: [time] ago

Session state:
  • Phase: [phase]
  • Task: [task description]
  • Files touched: [count]

Options:
  1. Continue from checkpoint
  2. Start fresh (checkpoint saved)

Reply with 1 or 2.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**LOG FILE:**
```
[2026-03-18 10:00:03] [INFO] Previous session found: xyz789
[2026-03-18 10:00:03] [INFO]   └─ Last activity: 2 hours ago
[2026-03-18 10:00:03] [INFO]   └─ Phase: BUILDING
[2026-03-18 10:00:03] [INFO]   └─ Task: Add login validation
[2026-03-18 10:00:03] [INFO]   └─ Files touched: 3
[2026-03-18 10:00:03] [INFO] Offering recovery options to user...
```

### Step 6: Initialize Audit Log (if needed)

Create `.dev-stacks/logs/audit.jsonl` if it doesn't exist.

**LOG FILE:**
```
[2026-03-18 10:00:05] [INFO] Step 6/6: Checking audit log...
[2026-03-18 10:00:05] [INFO]   └─ audit.jsonl: Ready
```

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `mcp__filesystem__get_file_info` | Check if files exist |
| `mcp__filesystem__read_text_file` | Load DNA, checkpoint |
| `mcp__filesystem__write_file` | Create DNA, checkpoint, logs, audit.jsonl |
| `mcp__filesystem__directory_tree` | Scan project structure |
| `mcp__filesystem__create_directory` | Create .dev-stacks directories |
| `mcp__memory__search_nodes` | Load patterns |

## Notes

- Log files are per-session with timestamp
- Audit log (audit.jsonl) is append-only across sessions
- DNA is refreshed at start of each session
- Patterns are loaded from MCP Memory (persistent)
- Checkpoint helps recover from interruptions
