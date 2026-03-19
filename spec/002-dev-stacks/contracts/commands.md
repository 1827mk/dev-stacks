# Command Contracts: Dev-Stacks

**Feature**: 002-dev-stacks
**Created**: 2026-03-18

---

## Overview

Dev-Stacks มี 5 commands สำหรับ visibility, control, และ recovery

---

## Command: `/dev-stacks:status`

### Purpose
แสดงภาพรวมระบบทั้งหมดในที่เดียว

### Usage
```
/dev-stacks:status [--dna] [--patterns] [--history]
```

### Arguments
| Argument | Type | Description |
|----------|------|-------------|
| `--dna` | flag | แสดง Project DNA เต็ม |
| `--patterns` | flag | แสดง patterns ทั้งหมด |
| `--history` | flag | แสดงประวัติ session |

### Output Format
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
│   • Tokens saved: [estimate]                            │
├─────────────────────────────────────────────────────────┤
│ 👥 Available Agents                                      │
│   🧠 Thinker (opus) - [status]                          │
│   🛠️ Builder (sonnet) - [status]                        │
│   ✅ Tester (sonnet) - [status]                         │
└─────────────────────────────────────────────────────────┘
```

### Exit Codes
| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | No project DNA found |
| 2 | Plugin not initialized |

---

## Command: `/dev-stacks:undo`

### Purpose
ย้อนกลับการเปลี่ยนแปลงหลายระดับ

### Usage
```
/dev-stacks:undo [level]
```

### Arguments
| Argument | Type | Default | Description |
|----------|------|---------|-------------|
| `level` | enum | `action` | ระดับการ undo: `action`, `phase`, `checkpoint`, `commit` |

### Levels
| Level | ย้อนกลับไปถึง |
|-------|-------------|
| `action` | Action ล่าสุด |
| `phase` | Phase ล่าสุด (think/build/test) |
| `checkpoint` | Checkpoint ล่าสุด |
| `commit` | Git commit ล่าสุด |

### Output Format
```
┌─────────────────────────────────────────────────────────┐
│ ⏪ UNDO PREVIEW                                           │
├─────────────────────────────────────────────────────────┤
│ Level: [level]                                           │
│ Action: [description]                                    │
│ Time: [time] ago                                         │
├─────────────────────────────────────────────────────────┤
│ Changes to revert:                                       │
│   - [file1] ([action])                                  │
│   - [file2] ([action])                                  │
├─────────────────────────────────────────────────────────┤
│ Proceed? [Y/n]                                          │
└─────────────────────────────────────────────────────────┘
```

### Exit Codes
| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | Nothing to undo |
| 2 | User cancelled |
| 3 | Git error (for commit level) |

---

## Command: `/dev-stacks:learn`

### Purpose
จัดการ Pattern Memory

### Usage
```
/dev-stacks:learn [action] [pattern]
```

### Arguments
| Argument | Type | Default | Description |
|----------|------|---------|-------------|
| `action` | enum | `list` | Action: `list`, `show`, `add`, `forget`, `export`, `import` |
| `pattern` | string | - | Pattern name or ID (for show/forget) |

### Actions

#### `list` - แสดง patterns ทั้งหมด
```
/dev-stacks:learn list
```

Output:
```
┌─────────────────────────────────────────────────────────┐
│ 📚 LEARNED PATTERNS                                      │
├─────────────────────────────────────────────────────────┤
│ #   Pattern          Uses  Confidence  Last Used        │
├─────────────────────────────────────────────────────────┤
│ 1   [name]           [n]   [0.xx]      [time] ago      │
│ 2   [name]           [n]   [0.xx]      [time] ago      │
└─────────────────────────────────────────────────────────┘
```

#### `show` - แสดง pattern เฉพาะ
```
/dev-stacks:learn show <pattern-name>
```

Output: Full pattern details including trigger, solution, metadata

#### `add` - เพิ่ม pattern ใหม่
```
/dev-stacks:learn add
```

Interactive prompt for pattern details

#### `forget` - ลบ pattern
```
/dev-stacks:learn forget <pattern-id>
```

Requires confirmation

#### `export` - ส่งออก patterns
```
/dev-stacks:learn export [file]
```

Exports to JSON file (default: `patterns-export.json`)

#### `import` - นำเข้า patterns
```
/dev-stacks:learn import <file>
```

Imports from JSON file, skips duplicates

### Exit Codes
| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | Pattern not found |
| 2 | Invalid pattern format |
| 3 | User cancelled |

---

## Command: `/dev-stacks:doctor`

### Purpose
วินิจฉัยและกู้คืนระบบ

### Usage
```
/dev-stacks:doctor [action] [component] [--confirm]
```

### Arguments
| Argument | Type | Default | Description |
|----------|------|---------|-------------|
| `action` | enum | `check` | Action: `check`, `fix`, `reset` |
| `component` | string | - | Component to fix/reset (for fix/reset) |
| `--confirm` | flag | - | Confirm destructive action |

### Actions

#### `check` - ตรวจสอบสุขภาพระบบ
```
/dev-stacks:doctor
```

Output:
```
┌─────────────────────────────────────────────────────────┐
│ 🏥 DEV-STACKS DOCTOR                                     │
├─────────────────────────────────────────────────────────┤
│ Checking system health...                                │
│                                                          │
│ ✅ DNA: Valid ([size] KB)                               │
│ ✅ Checkpoint: Valid (last [time] ago)                  │
│ ✅ Patterns DB: [count] patterns, index OK              │
│ ⚠️  Audit log: Large ([size] MB) - consider cleanup      │
│ ✅ Guards: All active                                   │
│ ✅ Agents: All available                                │
├─────────────────────────────────────────────────────────┤
│ Status: [HEALTHY / WARNING / ERROR]                     │
└─────────────────────────────────────────────────────────┘
```

#### `fix` - แก้ไขปัญหาอัตโนมัติ
```
/dev-stacks:doctor fix [component]
```

Fixes detected issues automatically

#### `reset` - เริ่มใหม่ (destructive)
```
/dev-stacks:doctor reset <component> --confirm
```

Components:
- `dna` - Rebuild DNA only
- `patterns` - Clear all patterns
- `checkpoint` - Clear session state
- `all` - Factory reset

### Exit Codes
| Code | Meaning |
|------|---------|
| 0 | Success / Healthy |
| 1 | Warnings found |
| 2 | Errors found |
| 3 | Reset failed / User cancelled |

---

## Command: `/dev-stacks:help`

### Purpose
คู่มือการใช้งาน

### Usage
```
/dev-stacks:help [topic]
```

### Arguments
| Argument | Type | Default | Description |
|----------|------|---------|-------------|
| `topic` | enum | `commands` | Topic: `commands`, `workflows`, `agents`, `examples` |

### Topics

#### `commands` (default)
แสดงรายการ commands ทั้งหมด

#### `workflows`
อธิบายวิธีการทำงานของระบบ (Quick/Standard/Careful/Full)

#### `agents`
รายละเอียดของ agents (Thinker/Builder/Tester)

#### `examples`
ตัวอย่างการใช้งานจริง

### Output Format
```
┌─────────────────────────────────────────────────────────┐
│ 📖 DEV-STACKS HELP                                       │
├─────────────────────────────────────────────────────────┤
│ [Content based on topic]                                │
└─────────────────────────────────────────────────────────┘
```

### Exit Codes
| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | Unknown topic |

---

## Common Patterns

### Transparency Display

Before any action, show:
```
🎯 Intent: [CATEGORY] | Target: [TARGET]
📊 Complexity: [SCORE] ([WORKFLOW])
👥 Team: [AGENTS]
⚡ [AUTO / Proceeding in Xs...]
```

### Guard Intervention

When guard triggered:
```
🛡️ Guard: [BLOCKED / CONFIRM REQUIRED]
   [Type]: [Pattern matched]
   Reason: [Explanation]

   [Action required]
```

### Pattern Suggestion

When pattern found:
```
📚 Found relevant pattern:
   "[Pattern Name]" (confidence: [0.xx])
   Last used: [time] ago | Used [n] times

   Use this pattern? [Y/n]
```
