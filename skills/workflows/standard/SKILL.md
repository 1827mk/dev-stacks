---
name: standard
description: Standard workflow for moderate tasks (complexity 0.2-0.39). Thinker + Builder, plan then implement.
---

# Standard Workflow

For moderate tasks that benefit from planning but don't need extensive verification.

## When to Use

- Complexity: 0.2 - 0.39
- New features
- Multiple file changes
- Business logic changes
- API implementations

## Team

```
Team: [Thinker, Builder]
```

## Process

```
┌─────────────────┐
│  User Input     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Thinker        │
│  - Analyze      │
│  - Research     │
│  - Plan         │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Builder        │
│  - Implement    │
│  - Follow plan  │
└─────────────────┘
```

## Steps

### Step 1: Thinker Analyzes

Thinker:
- Analyzes requirements
- Researches if needed (context7, web, etc.)
- Identifies files to modify
- Creates implementation plan

### Step 2: Builder Implements

Builder:
- Follows Thinker's plan
- Researches APIs if needed
- Makes changes
- Reports completion

## Output Format

```
📋 STANDARD WORKFLOW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Task: [task description]

🧠 Thinker: Analyzing...
   [Research findings if any]

   Plan:
   1. [Step 1]
   2. [Step 2]
   3. [Step 3]

🛠️ Builder: Implementing...
   - [Change 1]
   - [Change 2]

✅ Done! [Summary]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Examples

### Example 1: Add Validation
```
User: "เพิ่ม email validation ในฟอร์ม login"

📋 STANDARD WORKFLOW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Task: Add email validation to login form

🧠 Thinker: Analyzing...
   Research: Zod validation patterns from context7

   Plan:
   1. Create validation schema in src/validations/auth.ts
   2. Integrate with React Hook Form in LoginForm.tsx
   3. Add error message display

🛠️ Builder: Implementing...
   - Created loginSchema with email validation
   - Added zodResolver to useForm
   - Updated error display

✅ Done! Email validation added to login form
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Example 2: Create API Endpoint
```
User: "สร้าง GET /api/users/profile endpoint"

📋 STANDARD WORKFLOW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Task: Create user profile API endpoint

🧠 Thinker: Analyzing...
   Found existing pattern: /api/users/me endpoint

   Plan:
   1. Create route in routes/users.ts
   2. Add controller in controllers/users.ts
   3. Add authentication middleware

🛠️ Builder: Implementing...
   - Added GET /api/users/profile route
   - Created getProfile controller
   - Applied auth middleware

✅ Done! Profile endpoint ready at GET /api/users/profile
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Example 3: Refactor Component
```
User: "แยก LoginForm เป็น component เล็กๆ"

📋 STANDARD WORKFLOW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Task: Refactor LoginForm into smaller components

🧠 Thinker: Analyzing...
   Current structure: Single 200-line component

   Plan:
   1. Extract FormInput component
   2. Extract FormButton component
   3. Extract FormError component
   4. Update LoginForm to use new components

🛠️ Builder: Implementing...
   - Created FormInput.tsx
   - Created FormButton.tsx
   - Created FormError.tsx
   - Refactored LoginForm.tsx

✅ Done! LoginForm now uses 3 sub-components
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Characteristics

| Aspect | Behavior |
|--------|----------|
| Planning | ✅ Thinker plans |
| Confirmation | ❌ Not needed |
| Verification | ❌ None |
| Research | ✅ Both agents |
| Audit | ✅ Logged |

## Time Expectation

- Target: 1-3 minutes
- Maximum: 5 minutes

## Error Recovery

### Error Categories

| Category | Examples | Recovery |
|----------|----------|----------|
| **RECOVERABLE** | Wrong file path, missing import | Auto-fix and continue |
| **RETRYABLE** | API timeout, rate limit | Retry with exponential backoff |
| **PLANNING_ERROR** | Wrong approach, missing dependency | Return to Thinker for re-plan |
| **BLOCKING** | Permission denied, test failures | Escalate to user with options |

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
       ├─ RECOVERABLE ──→ Auto-fix ──→ Continue
       │
       ├─ RETRYABLE ────→ Backoff ──→ Retry (max 3)
       │
       ├─ PLANNING ─────→ Return to Thinker ──→ Re-plan
       │
       └─ BLOCKING ─────→ Report ──→ User decision
```

### Recovery Examples

**Planning Error - Return to Thinker**:
```
📋 STANDARD WORKFLOW - PLANNING ERROR
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️ Implementation blocked: Missing dependency

   Builder encountered:
   - Required package 'zod' not installed

🔄 Returning to Thinker for re-plan...

🧠 Thinker: Adjusting plan...
   Original plan assumed zod exists.

   Updated Plan:
   1. Install zod package: npm install zod
   2. Create validation schema
   3. Integrate with form

   Proceed with updated plan? [Y/n]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Test Failure - Offer Options**:
```
📋 STANDARD WORKFLOW - TEST FAILURE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️ Tests failed after implementation

   Failed tests:
   - login.test.ts: Email validation failing

Options:
   1. Fix the failing tests
   2. Review implementation
   3. Rollback changes
   4. Continue anyway (not recommended)

Reply with 1, 2, 3, or 4.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Auto-Recoverable**:
```
📋 STANDARD WORKFLOW - AUTO RECOVERY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
❌ Error: Cannot find module '../validations/auth'

🔄 Recovering...
   - Checking for similar files...
   - Found: src/validations/auth.ts (path mismatch)

   Auto-fixing: Updating import path

✅ Recovered. Continuing implementation...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Rollback Procedure

```
⏪ STANDARD WORKFLOW - ROLLBACK
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Rolling back to last checkpoint...

Files to revert:
   - src/components/LoginForm.tsx (modified)
   - src/validations/auth.ts (created)

Preview changes? [Y/n]

[On Y]
   --- a/src/components/LoginForm.tsx
   +++ b/src/components/LoginForm.tsx
   [diff preview]

Proceed with rollback? [Y/n]

✅ Rollback complete.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Checkpoint Strategy

Standard workflow creates checkpoints:
- After Thinker completes plan
- Before Builder starts implementation
- After each significant change

```
💾 CHECKPOINT SAVED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Phase: BUILDING
Task: Add email validation
Progress: 50%

Undo available: /dev-stacks:undo
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Retry Configuration

From `config/defaults.json`:

```json
{
  "error_recovery": {
    "max_retries": 3,
    "retry_delay_ms": 2000,
    "max_return_to_thinker": 1,
    "auto_recover_enabled": true
  }
}
```

## Notes

- Most common workflow
- Balance of speed and quality
- Thinker ensures good approach
- Builder has research capability
- **Can return to Thinker 1 time**
- **Auto-recovery for simple errors**
- **Checkpoint enables instant rollback**
