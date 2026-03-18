---
name: SessionStart
description: Initialize Dev-Stacks session - load DNA, patterns, and prepare for work.
---

# SessionStart Hook

Executed when Claude Code session starts.

## Purpose

Initialize Dev-Stacks environment:
1. Load Project DNA from `.dev-stack/dna.json`
2. Load patterns from MCP Memory
3. Load checkpoint from `.dev-stack/checkpoint.json`
4. Display welcome message with status

## Execution Steps

### Step 1: Check Initialization

Check if `.dev-stack/` directory exists:
- If not, create it and initialize

### Step 2: Load Project DNA

Read `.dev-stack/dna.json`:
- If exists, load project knowledge
- If not, create initial DNA by scanning project

### Step 3: Load Patterns

Query MCP Memory for patterns:
- Search for entities with type "dev-stacks-pattern"
- Load pattern count and confidence

### Step 4: Load Checkpoint

Read `.dev-stack/checkpoint.json`:
- If exists, check if session matches
- If different session, offer to restore or start fresh

### Step 5: Display Welcome

Show initialization status:
```
🚀 DEV-STACKS INITIALIZED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Project: [name]
DNA: ✅ Loaded ([patterns] patterns, [risks] risk areas)
Session: [session_id]

Ready for work. Just describe what you need.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## First Run Initialization

If `.dev-stack/` doesn't exist:

```
🚀 DEV-STACKS FIRST RUN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Setting up Dev-Stacks...

Creating:
  ✅ .dev-stack/ directory
  ✅ dna.json (scanning project...)
  ✅ checkpoint.json (fresh session)
  ✅ audit.jsonl (ready for logging)

📚 Project DNA built:
  • Type: [project type]
  • Languages: [languages]
  • Frameworks: [frameworks]
  • Patterns detected: [count]

Ready for work. Just describe what you need.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `mcp__filesystem__get_file_info` | Check if files exist |
| `mcp__filesystem__read_text_file` | Load DNA, checkpoint |
| `mcp__filesystem__write_file` | Create DNA, checkpoint |
| `mcp__filesystem__directory_tree` | Scan project structure |
| `mcp__memory__search_nodes` | Load patterns |

## Recovery Offer

If previous session found:

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

## Notes

- Silent initialization if everything is cached
- DNA is refreshed at start of each session
- Patterns are loaded from MCP Memory (persistent)
- Checkpoint helps recover from interruptions
