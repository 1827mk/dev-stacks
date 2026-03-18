---
name: dev-stacks:status
description: Display Dev-Stacks status - project DNA, session stats, patterns, and agents.
allowed-tools:
  - mcp__filesystem__read_text_file
  - mcp__filesystem__get_file_info
  - mcp__memory__search_nodes
---

# /dev-stacks:status

Display comprehensive status of Dev-Stacks.

## Usage

```
/dev-stacks:status [--dna] [--patterns] [--history]
```

## Arguments

| Argument | Description |
|----------|-------------|
| `--dna` | Show full Project DNA |
| `--patterns` | Show all learned patterns |
| `--history` | Show session history |

## Output Format

```
┌─────────────────────────────────────────────────────────┐
│ 📊 DEV-STACKS STATUS                                     │
├─────────────────────────────────────────────────────────┤
│ Project: [name] ([type])                                 │
│ Session: [session_id] ([turns] turns)                   │
│ Last checkpoint: [time] ago                             │
├─────────────────────────────────────────────────────────┤
│ 🧠 DNA (Project Knowledge)                              │
│   • Architecture: [summary]                             │
│   • Patterns: [count] learned                           │
│   • Risk areas: [count] identified                      │
├─────────────────────────────────────────────────────────┤
│ 📈 Session Stats                                         │
│   • Tasks completed: [count]                            │
│   • Files touched: [count]                              │
│   • Patterns used: [count]                              │
├─────────────────────────────────────────────────────────┤
│ 👥 Available Agents                                      │
│   🧠 Thinker (opus) - Ready                             │
│   🛠️ Builder (opus) - Ready                            │
│   ✅ Tester (sonnet) - Ready                             │
└─────────────────────────────────────────────────────────┘
```

## What It Shows

### Default (no flags)
- Project overview
- Session stats
- Agent availability
- Quick DNA summary

### With --dna
- Full DNA details
- Architecture breakdown
- All learned patterns
- Risk areas

### With --patterns
- All patterns from MCP Memory
- Confidence scores
- Last used dates

### With --history
- Current session actions
- Files modified
- Decisions made

## Example

```
/dev-stacks:status

┌─────────────────────────────────────────────────────────┐
│ 📊 DEV-STACKS STATUS                                     │
├─────────────────────────────────────────────────────────┤
│ Project: my-app (FULLSTACK)                              │
│ Session: abc123-def (5 turns)                            │
│ Last checkpoint: 2 minutes ago                           │
├─────────────────────────────────────────────────────────┤
│ 🧠 DNA (Project Knowledge)                              │
│   • Architecture: React + Express + SQLite              │
│   • Patterns: 3 learned                                 │
│   • Risk areas: 2 identified (auth, payment)            │
├─────────────────────────────────────────────────────────┤
│ 📈 Session Stats                                         │
│   • Tasks completed: 2                                  │
│   • Files touched: 4                                    │
│   • Patterns used: 1                                    │
├─────────────────────────────────────────────────────────┤
│ 👥 Available Agents                                      │
│   🧠 Thinker (opus) - Ready                             │
│   🛠️ Builder (opus) - Ready                            │
│   ✅ Tester (sonnet) - Ready                             │
└─────────────────────────────────────────────────────────┘
```

## Error Cases

### No DNA Found
```
📊 DEV-STACKS STATUS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️ No DNA found. Run /dev-stacks:doctor to initialize.
```

### No Patterns Found
```
📊 DEV-STACKS STATUS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📚 No patterns learned yet.
   Complete tasks successfully to build pattern memory.
```
