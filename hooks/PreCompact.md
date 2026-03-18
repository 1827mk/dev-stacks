---
name: PreCompact
description: Backup session state before context compaction to preserve work.
---

# PreCompact Hook

Executed before Claude Code compacts the context (removes old messages).

## Purpose

Preserve session state before compaction:
1. Save checkpoint
2. Archive current session log
3. Backup DNA if updated
4. Store pattern progress

## Execution Steps

### Step 1: Log PreCompact Start

**CONSOLE:**
```
🔍 [DEV-STACKS] Context compaction detected... Backing up session state.
```

**LOG FILE:**
```
[2026-03-18 11:00:00] [INFO] ═══════════════════════════════════════════════════
[2026-03-18 11:00:00] [INFO] [PreCompact] CONTEXT COMPACTION TRIGGERED
[2026-03-18 11:00:00] [INFO]   └─ Session ID: abc123
[2026-03-18 11:00:00] [INFO]   └─ Context size: Large
[2026-03-18 11:00:00] [INFO] ═══════════════════════════════════════════════════
```

### Step 2: Save Checkpoint

Save current checkpoint to `.dev-stacks/checkpoint.json`:
- Current task state
- Files touched
- Decisions made
- Pattern progress

**LOG FILE:**
```
[2026-03-18 11:00:01] [INFO] [PreCompact] Step 1/4: Saving checkpoint...
[2026-03-18 11:00:01] [INFO]   └─ Checkpoint saved: .dev-stacks/checkpoint.json
[2026-03-18 11:00:01] [INFO]   └─ Undo stack: 5 items
```

### Step 3: Archive Session Log

Read current session log and write to archive:
1. Read `.dev-stacks/logs/session-*.log` (find current session)
2. Create `.dev-stacks/logs/archive/` directory
3. Write to `.dev-stacks/logs/archive/session-*-precompact.log`

**LOG FILE:**
```
[2026-03-18 11:00:02] [INFO] [PreCompact] Step 2/4: Archiving session log...
[2026-03-18 11:00:02] [INFO]   └─ Source: session-2026-03-18-100000.log
[2026-03-18 11:00:02] [INFO]   └─ Archive: archive/session-2026-03-18-100000-precompact.log
```

### Step 4: Backup DNA (if updated)

If DNA was modified during session:
```
.dev-stacks/dna.json
→ .dev-stacks/backups/dna-2026-03-18-110000.json
```

**LOG FILE:**
```
[2026-03-18 11:00:03] [INFO] [PreCompact] Step 3/4: Backing up DNA...
[2026-03-18 11:00:03] [INFO]   └─ DNA modified: Yes
[2026-03-18 11:00:03] [INFO]   └─ Backup: backups/dna-2026-03-18-110000.json
```

### Step 5: Store Pattern Progress

Save any patterns learned but not yet persisted:
- Patterns in progress
- Confidence scores
- Trigger keywords

**LOG FILE:**
```
[2026-03-18 11:00:04] [INFO] [PreCompact] Step 4/4: Storing pattern progress...
[2026-03-18 11:00:04] [INFO]   └─ Patterns in progress: 1
[2026-03-18 11:00:04] [INFO]   └─ Saved to: .dev-stacks/patterns-pending.json
```

### Final Output

**CONSOLE:**
```
✅ [DEV-STACKS] Session backed up before compaction
   └─ Checkpoint: .dev-stacks/checkpoint.json
   └─ Log archive: .dev-stacks/logs/archive/
```

**LOG FILE:**
```
[2026-03-18 11:00:05] [INFO] [PreCompact] ═══════════════════════════════════════
[2026-03-18 11:00:05] [INFO] [PreCompact] BACKUP COMPLETE - Safe to compact
[2026-03-18 11:00:05] [INFO] [PreCompact] ═══════════════════════════════════════
```

## Directory Structure

```
.dev-stacks/
├── checkpoint.json           # Current checkpoint
├── dna.json                  # Current DNA
├── backups/                  # PreCompact backups
│   ├── dna-2026-03-18-110000.json
│   └── checkpoint-2026-03-18-110000.json
├── logs/
│   ├── session-*.log         # Current session
│   └── archive/              # PreCompact archives
│       └── session-*-precompact.log
└── patterns-pending.json     # Patterns in progress
```

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `mcp__filesystem__read_text_file` | Read current checkpoint, DNA, session log |
| `mcp__filesystem__write_file` | Save backup files, archive log |
| `mcp__filesystem__create_directory` | Create backup/archive directories |
| `mcp__filesystem__get_file_info` | Check if files exist |

## Recovery

After compaction, session can be restored from:
1. `.dev-stacks/checkpoint.json` - Session state
2. `.dev-stacks/backups/` - PreCompact backups
3. `.dev-stacks/logs/archive/` - Archived logs

## Notes

- PreCompact ensures no work is lost during context compaction
- Archives are kept for 7 days by default
- Patterns pending are persisted after compaction
- DNA backups help recover from corruption
