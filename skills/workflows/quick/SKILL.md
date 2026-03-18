---
name: quick
description: Quick workflow for simple tasks (complexity 0.0-0.19). Builder only, no confirmation.
---

# Quick Workflow

For simple, low-risk tasks that need no planning or verification.

## When to Use

- Complexity: 0.0 - 0.19
- Single file changes
- Simple fixes
- Documentation updates
- Style changes

## Team

```
Team: [Builder]
```

## Process

```
┌─────────────────┐
│  User Input     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Builder        │
│  - Understand   │
│  - Implement    │
│  - Done         │
└─────────────────┘
```

## Steps

### Step 1: Understand Task

Quick analysis:
- What file(s) to modify?
- What change to make?
- Any research needed?

### Step 2: Execute

Direct implementation:
- No planning phase
- No verification phase
- Just do it

### Step 3: Report

Brief completion message.

## Output Format

```
⚡ QUICK WORKFLOW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Task: [task description]

🛠️ Builder: Executing...
   - [Action taken]

✅ Done! [Summary of change]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Examples

### Example 1: Fix Typo
```
User: "แก้ typo ใน README ตรงคำว่า 'intallation'"

⚡ QUICK WORKFLOW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Task: Fix typo in README.md

🛠️ Builder: Executing...
   - Found typo in README.md:23
   - Changed 'intallation' → 'installation'

✅ Done! Typo fixed in README.md
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Example 2: Change Color
```
User: "เปลี่ยนสีปุ่ม submit เป็นสีน้ำเงิน"

⚡ QUICK WORKFLOW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Task: Change submit button color

🛠️ Builder: Executing...
   - Found button in src/components/Form.css
   - Changed background-color to blue

✅ Done! Submit button is now blue
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Example 3: Add Comment
```
User: "เพิ่ม comment ให้ฟังก์ชัน calculateTotal"

⚡ QUICK WORKFLOW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Task: Add comment to calculateTotal function

🛠️ Builder: Executing...
   - Found function in src/utils/calculator.ts
   - Added JSDoc comment

✅ Done! Function documented
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Characteristics

| Aspect | Behavior |
|--------|----------|
| Planning | ❌ None |
| Confirmation | ❌ Never |
| Verification | ❌ None |
| Research | ✅ If needed |
| Audit | ✅ Logged |

## Time Expectation

- Target: < 30 seconds
- Maximum: 2 minutes

## Error Recovery

### Error Categories

| Category | Examples | Recovery |
|----------|----------|----------|
| **RECOVERABLE** | File not found, syntax error, case mismatch | Auto-fix and retry |
| **RETRYABLE** | Network timeout, API rate limit | Retry up to 3 times with backoff |
| **BLOCKING** | Permission denied, disk full, guard blocked | Escalate to user |

### Recovery Flow

```
┌─────────────┐
│ Error Occurs│
└──────┬──────┘
       │
       ▼
┌─────────────────┐
│ Categorize Error│
└──────┬──────────┘
       │
       ├─ RECOVERABLE ──→ Auto-fix ──→ Retry
       │
       ├─ RETRYABLE ────→ Wait ──→ Retry (max 3)
       │
       └─ BLOCKING ─────→ Report ──→ Ask user
```

### Recovery Examples

**Auto-Recoverable**:
```
⚡ QUICK WORKFLOW - ERROR RECOVERY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
❌ Error: File README.md not found

🔄 Recovering...
   - Checking for similar files...
   - Found: readme.md (case mismatch)

   Auto-fixing: Using readme.md instead

✅ Recovered. Continuing...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Retryable**:
```
⚡ QUICK WORKFLOW - RETRY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️ Error: Network timeout (context7)

🔄 Retrying (1/3)...
   - Waiting 2 seconds...
   - Retrying...

✅ Retry successful. Continuing...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Blocking**:
```
⚡ QUICK WORKFLOW - BLOCKED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
❌ Error: Permission denied writing to .env

This error cannot be auto-recovered.

Options:
   1. Skip this change
   2. Request guard override
   3. Abort task

Reply with 1, 2, or 3.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Rollback (Quick Workflow)

Quick tasks usually don't need rollback, but checkpoint is still saved:

```
⏪ QUICK WORKFLOW - ROLLBACK
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Task failed after partial changes.

Rolling back:
   - Reverting README.md... ✅

Rollback complete.

Undo with: /ds:undo
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Retry Configuration

From `config/defaults.json`:

```json
{
  "error_recovery": {
    "max_retries": 3,
    "retry_delay_ms": 2000,
    "retry_backoff_multiplier": 2,
    "auto_recover_enabled": true
  }
}
```

## Notes

- Fastest workflow
- No user confirmation
- Builder has full research capability
- All actions logged
- **Auto-recovery for simple errors**
- **Checkpoint enables instant rollback**
