---
name: ds:learn
description: Manage pattern memory - list, show, save, delete, export, import patterns.
---

# /ds:learn

Manage pattern memory.

## Usage

```
/ds:learn [action] [pattern]
```

## Actions

| Action | Description |
|--------|-------------|
| `list` | List all patterns (default) |
| `show` | Show pattern details |
| `save` | Save current task as pattern |
| `forget` | Delete a pattern |
| `export` | Export patterns to file |
| `import` | Import patterns from file |

---

## Action: list

List all learned patterns.

```
/ds:learn list
```

### Output

```
📚 LEARNED PATTERNS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   Pattern              Uses  Conf   Last Used
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1   Form Validation      5     0.80   2 days ago
2   API Endpoint         3     0.67   1 week ago
3   Login Flow           2     1.00   3 days ago
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total: 3 patterns
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Action: show

Show details of a specific pattern.

```
/ds:learn show "Form Validation"
```

### Output

```
📚 PATTERN: Form Validation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Intent: ADD_FEATURE
Confidence: 0.80 (4/5 successful)

Trigger Keywords:
   validation, form, email, password

Solution Steps:
   1. Create Zod schema for form
   2. Integrate with React Hook Form
   3. Add error message display
   4. Test validation rules

Code Example:
   const schema = z.object({
     email: z.string().email(),
     password: z.string().min(8)
   });

Statistics:
   - Created: 2026-03-15
   - Last used: 2026-03-18
   - Uses: 5
   - Success: 4
   - Failures: 1
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Action: save

Manually save current task as a pattern.

```
/ds:learn save
```

### Output

```
📚 SAVE PATTERN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Based on recent task: [task description]

Suggested name: "[auto-generated]"
Trigger keywords: [auto-detected]

Solution Steps:
1. [Step extracted from task]
2. [Step extracted from task]

Edit pattern details? [Y/n]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[If Y, user can edit name, keywords, steps]

📚 PATTERN SAVED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Name: [Pattern Name]
Confidence: 1.0 (new)

This pattern will be suggested for similar tasks.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Action: forget

Delete a pattern.

```
/ds:learn forget "Pattern Name"
```

### Output

```
📚 FORGET PATTERN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Pattern: "Form Validation"
Confidence: 0.80
Uses: 5

Are you sure you want to delete this pattern? [Y/n]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[If Y]

📚 PATTERN DELETED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"Form Validation" removed from pattern memory.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Action: export

Export patterns to JSON file.

```
/ds:learn export [filename]
```

### Output

```
📚 EXPORT PATTERNS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Exporting 3 patterns...

Saved to: patterns-export.json

You can import these patterns in another project
using: /ds:learn import patterns-export.json
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Action: import

Import patterns from JSON file.

```
/ds:learn import patterns-export.json
```

### Output

```
📚 IMPORT PATTERNS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Reading: patterns-export.json
Found: 3 patterns

Importing:
   ✅ "Form Validation" (new)
   ⏭️ "API Endpoint" (duplicate, skipped)
   ✅ "Login Flow" (new)

Imported: 2 patterns
Skipped: 1 duplicate
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## MCP Memory Tools Used

| Tool | Actions |
|------|---------|
| `mcp__memory__search_nodes` | list |
| `mcp__memory__open_nodes` | show |
| `mcp__memory__create_entities` | save, import |
| `mcp__memory__delete_entities` | forget |
| `mcp__memory__read_graph` | export |

---

## Notes

- Patterns stored in MCP Memory (persistent)
- Confidence auto-updates with use
- Low-confidence patterns auto-deleted after 30 days
- Export/import for sharing between projects
