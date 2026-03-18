---
name: ds:help
description: Display help documentation for Dev-Stacks commands and concepts.
---

# /ds:help

Display help for Dev-Stacks.

## Usage

```
/ds:help [topic]
```

## Topics

| Topic | Description |
|-------|-------------|
| `commands` | List all commands (default) |
| `workflows` | Explain workflow levels |
| `agents` | Agent descriptions |
| `research` | Research capability |
| `examples` | Usage examples |

## Default Output (commands)

```
┌─────────────────────────────────────────────────────────┐
│ 📖 DEV-STACKS HELP                                       │
├─────────────────────────────────────────────────────────┤
│ Commands:                                                │
│   /ds:status   - View system status                     │
│   /ds:undo     - Undo changes                           │
│   /ds:learn    - Manage patterns                        │
│   /ds:doctor   - Diagnose and recover                   │
│   /ds:help     - This help message                      │
├─────────────────────────────────────────────────────────┤
│ Topics:                                                  │
│   /ds:help workflows  - Workflow explanations           │
│   /ds:help agents     - Agent descriptions              │
│   /ds:help research   - Research capability             │
│   /ds:help examples   - Usage examples                  │
├─────────────────────────────────────────────────────────┤
│ Just describe what you want to do in natural language!  │
│ Dev-Stacks will understand and help you.                │
└─────────────────────────────────────────────────────────┘
```

## Workflows Topic

```
┌─────────────────────────────────────────────────────────┐
│ 📖 DEV-STACKS WORKFLOWS                                  │
├─────────────────────────────────────────────────────────┤
│ QUICK (0.0-0.19)                                         │
│   • Builder only                                         │
│   • No confirmation needed                               │
│   • For: typos, simple changes, quick fixes             │
├─────────────────────────────────────────────────────────┤
│ STANDARD (0.2-0.39)                                      │
│   • Thinker + Builder                                    │
│   • Plan then implement                                  │
│   • For: new features, moderate changes                 │
├─────────────────────────────────────────────────────────┤
│ CAREFUL (0.4-0.59)                                       │
│   • Thinker + Builder + Tester                           │
│   • Plan, implement, verify                              │
│   • For: complex features, security changes              │
├─────────────────────────────────────────────────────────┤
│ FULL (0.6-1.0)                                           │
│   • Full team + User confirmation                        │
│   • Maximum caution                                      │
│   • For: payment, auth, database, breaking changes       │
└─────────────────────────────────────────────────────────┘
```

## Agents Topic

```
┌─────────────────────────────────────────────────────────┐
│ 📖 DEV-STACKS AGENTS                                     │
├─────────────────────────────────────────────────────────┤
│ 🧠 Thinker                                               │
│   Role: Plan, analyze, research                          │
│   Invoked: STANDARD, CAREFUL, FULL                       │
│   Tools: All MCP tools for research                      │
├─────────────────────────────────────────────────────────┤
│ 🛠️ Builder                                               │
│   Role: Implement, modify, fix                           │
│   Invoked: Always                                        │
│   Tools: All MCP tools for implementation                │
├─────────────────────────────────────────────────────────┤
│ ✅ Tester                                                 │
│   Role: Verify, validate, test                           │
│   Invoked: CAREFUL, FULL                                 │
│   Tools: MCP tools for verification                      │
└─────────────────────────────────────────────────────────┘
```

## Research Topic

```
┌─────────────────────────────────────────────────────────┐
│ 📖 DEV-STACKS RESEARCH CAPABILITY                        │
├─────────────────────────────────────────────────────────┤
│ All agents can research when knowledge is insufficient   │
├─────────────────────────────────────────────────────────┤
│ Research Tools:                                          │
│   • context7   - Library documentation                   │
│   • web_reader - Web content, tutorials                 │
│   • WebSearch  - General search, solutions               │
│   • fetch      - Specific URLs, GitHub                  │
├─────────────────────────────────────────────────────────┤
│ When Research Happens:                                   │
│   • Unknown library/framework                            │
│   • Unfamiliar API                                       │
│   • New error to solve                                   │
│   • Best practice needed                                 │
├─────────────────────────────────────────────────────────┤
│ Like a team of expert developers - if they don't know,  │
│ they look it up!                                         │
└─────────────────────────────────────────────────────────┘
```

## Examples Topic

```
┌─────────────────────────────────────────────────────────┐
│ 📖 DEV-STACKS EXAMPLES                                   │
├─────────────────────────────────────────────────────────┤
│ Quick Fix:                                               │
│   "แก้ typo ใน README ตรงคำว่า 'intallation'"            │
│   → Builder fixes immediately                            │
├─────────────────────────────────────────────────────────┤
│ Add Feature:                                             │
│   "เพิ่ม email validation ในฟอร์ม login"                │
│   → Thinker plans → Builder implements                  │
├─────────────────────────────────────────────────────────┤
│ Investigate:                                             │
│   "ทำไม API /users ช้า?"                                │
│   → Thinker investigates → Reports findings            │
├─────────────────────────────────────────────────────────┤
│ With Research:                                           │
│   "ใช้ Zod สำหรับ validation"                            │
│   → Agent researches Zod → Learns patterns → Implements │
└─────────────────────────────────────────────────────────┘
```

## Tips

```
💡 Tips:
1. Speak naturally - Thai, English, or mixed
2. Be specific about targets (files, functions)
3. Provide context when helpful
4. Trust the agents - they'll research when needed
5. Use commands for control and visibility
```
