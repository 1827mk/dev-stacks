---
name: careful
description: Careful workflow for complex tasks (complexity 0.4-0.59). Full team with verification.
---

# Careful Workflow

For complex tasks that need planning, implementation, and verification.

## When to Use

- Complexity: 0.4 - 0.59
- Security-related changes
- Cross-cutting concerns
- Database schema changes
- Performance optimizations

## Team

```
Team: [Thinker, Builder, Tester]
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
│  - Identify risks│
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Builder        │
│  - Implement    │
│  - Follow plan  │
│  - Handle errors│
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Tester         │
│  - Verify       │
│  - Run tests    │
│  - Check edges  │
└─────────────────┘
```

## Steps

### Step 1: Thinker Analyzes

Thinker:
- Deep analysis of requirements
- Research best practices
- Identify all affected files
- Plan implementation steps
- **Identify potential risks**

### Step 2: Builder Implements

Builder:
- Follow Thinker's plan carefully
- Research APIs/patterns as needed
- Implement with error handling
- Document changes

### Step 3: Tester Verifies

Tester:
- Verify requirements met
- Run existing tests
- Check edge cases
- Review code quality

## Output Format

```
🔍 CAREFUL WORKFLOW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Task: [task description]

🧠 Thinker: Analyzing...
   [Research findings]

   Plan:
   1. [Step 1]
   2. [Step 2]

   Risks identified:
   - [Risk 1]
   - [Risk 2]

🛠️ Builder: Implementing...
   - [Change 1]
   - [Change 2]

✅ Tester: Verifying...
   - [Test 1]: ✅ Pass
   - [Test 2]: ✅ Pass

   Edge cases checked:
   - [Case 1]: ✅ Handled

✅ Done! [Summary]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Examples

### Example 1: Add Authentication
```
User: "เพิ่ม JWT authentication ใน API"

🔍 CAREFUL WORKFLOW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Task: Add JWT authentication to API

🧠 Thinker: Analyzing...
   Research: JWT best practices from context7

   Plan:
   1. Create JWT utility functions
   2. Create auth middleware
   3. Apply to protected routes
   4. Add refresh token logic

   Risks identified:
   - Token expiration handling
   - Secret key management

🛠️ Builder: Implementing...
   - Created src/auth/jwt.ts
   - Created middleware/auth.ts
   - Applied to /api/* routes
   - Added refresh endpoint

✅ Tester: Verifying...
   - Token generation: ✅ Pass
   - Token validation: ✅ Pass
   - Expired token: ✅ Handled
   - Missing token: ✅ Handled

   Edge cases checked:
   - Malformed token: ✅ Returns 401

✅ Done! JWT authentication implemented
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Example 2: Database Migration
```
User: "เพิ่ม column status ในตาราง users"

🔍 CAREFUL WORKFLOW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Task: Add status column to users table

🧠 Thinker: Analyzing...
   Current schema: users table exists

   Plan:
   1. Create migration file
   2. Update User model
   3. Update related queries
   4. Add default value

   Risks identified:
   - Existing data needs default
   - Related queries affected

🛠️ Builder: Implementing...
   - Created migration: add_status_to_users
   - Updated User interface
   - Updated findByStatus query
   - Set default: 'active'

✅ Tester: Verifying...
   - Migration runs: ✅ Pass
   - New users have status: ✅ Pass
   - Existing users updated: ✅ Pass

   Edge cases checked:
   - Null status: ✅ Defaults to 'active'

✅ Done! Status column added
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Characteristics

| Aspect | Behavior |
|--------|----------|
| Planning | ✅ Thinker plans + risk analysis |
| Confirmation | ❌ Not needed (complexity < 0.6) |
| Verification | ✅ Tester verifies |
| Research | ✅ All agents |
| Audit | ✅ Full logging |

## Time Expectation

- Target: 3-5 minutes
- Maximum: 10 minutes

## Error Recovery

### Error Categories

| Category | Examples | Recovery |
|----------|----------|----------|
| **RECOVERABLE** | Wrong file path, typo in code | Auto-fix and continue |
| **RETRYABLE** | API timeout, rate limit | Retry with backoff |
| **PLANNING_ERROR** | Wrong approach, missed dependency | Return to Thinker for re-plan |
| **BUILD_ERROR** | Syntax error, type error | Fix and retry build phase |
| **TEST_FAILURE** | Tests fail, verification fails | Return to Builder or offer options |
| **BLOCKING** | Permission, guard blocked | Escalate to user |

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
       ├─ PLANNING ─────→ Thinker re-plan ──→ Confirm
       │
       ├─ BUILD ────────→ Fix ──→ Rebuild
       │
       ├─ TEST ─────────→ Options ──→ User/Builder
       │
       └─ BLOCKING ─────→ Report ──→ User decision
```

### Recovery Examples

**Test Failure - Detailed Options**:
```
🔍 CAREFUL WORKFLOW - TEST FAILURE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️ Tester found issues

   Failed tests:
   - auth.test.ts: Token refresh not working
   - middleware.test.ts: Expired token not handled

Edge cases failed:
   - Malformed token: Returns 500 instead of 401

Options:
   1. Return to Builder with findings
   2. View detailed error logs
   3. Rollback to checkpoint
   4. Accept partial success (not recommended)

Reply with 1, 2, 3, or 4.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Return to Builder from Tester**:
```
🔍 CAREFUL WORKFLOW - RETURNING TO BUILDER
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔄 Tester findings sent to Builder...

✅ Tester Report:
   Issues found:
   1. Token refresh: Missing try-catch
   2. Expired token: Wrong error code
   3. Malformed token: No validation

🛠️ Builder: Fixing issues...
   - Added error handling in refresh()
   - Fixed error code: 500 → 401
   - Added token format validation

✅ Tester: Re-verifying...
   - Token refresh: ✅ Pass
   - Expired token: ✅ Pass
   - Malformed token: ✅ Pass

All tests passed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Planning Error - Re-plan Required**:
```
🔍 CAREFUL WORKFLOW - RE-PLAN REQUIRED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️ Builder blocked: Database migration needed

   Issue: Adding 'status' column requires migration
   Current DB: SQLite with no migration tool

🔄 Returning to Thinker for updated plan...

🧠 Thinker: Re-analyzing...
   Research: SQLite migration strategies from context7

   Updated Plan:
   1. Install migration tool (knex-migrator)
   2. Create initial migration
   3. Add status column migration
   4. Update User model
   5. Add findByStatus query

   New risks:
   - Migration tool adds complexity
   - Need to handle existing data

   Continue with updated plan? [Y/n]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Rollback with Checkpoint

```
⏪ CAREFUL WORKFLOW - ROLLBACK
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️ Multiple test failures. Rolling back...

Checkpoint found: Before Builder started
   Time: 5 minutes ago
   Phase: After Thinker plan

Files to revert:
   - src/auth/jwt.ts (modified)
   - src/middleware/auth.ts (modified)
   - tests/auth.test.ts (modified)

Rollback options:
   1. Full rollback (all files)
   2. Selective rollback (choose files)
   3. Cancel, try to fix instead

Reply with 1, 2, or 3.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Phase-Specific Recovery

| Phase | Recovery Strategy |
|-------|-------------------|
| Thinker | Re-analyze with more context |
| Builder | Fix + retry, or return to Thinker |
| Tester | Report to Builder, or offer rollback |

### Retry Configuration

From `config/defaults.json`:

```json
{
  "error_recovery": {
    "max_retries": 3,
    "retry_delay_ms": 2000,
    "retry_backoff_multiplier": 2,
    "max_return_to_thinker": 2,
    "checkpoint_frequency": "per_phase"
  }
}
```

## Notes

- Good balance for security changes
- Tester catches issues before completion
- All agents have research capability
- Risk identification is key
- **Can return to Thinker up to 2 times**
- **Tester can send findings back to Builder**
- **Checkpoint per phase enables granular rollback**
- **Detailed error reports for debugging**
