---
name: full
description: Full workflow for critical tasks (complexity 0.6-1.0). Full team with user confirmation required.
---

# Full Workflow

For critical, high-risk tasks that need maximum caution and user oversight.

## When to Use

- Complexity: 0.6 - 1.0
- Payment processing
- Authentication system changes
- Database schema changes (breaking)
- Security-related modifications
- System-wide refactoring

## Team

```
Team: [Thinker, Builder, Tester] + User Confirmation
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
│  - Deep analyze │
│  - Research     │
│  - Full plan    │
│  - Risk assessment│
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ ⚠️ CONFIRMATION │
│  User reviews   │
│  plan & risks   │
└────────┬────────┘
         │ User approves
         ▼
┌─────────────────┐
│  Builder        │
│  - Implement    │
│  - Careful exec │
│  - Error handling│
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Tester         │
│  - Full verify  │
│  - All tests    │
│  - Edge cases   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ 👤 USER REVIEW  │
│  Final approval │
└─────────────────┘
```

## Steps

### Step 1: Thinker Deep Analysis

Thinker:
- Comprehensive analysis
- Research all aspects
- Detailed implementation plan
- **Full risk assessment**
- **Rollback plan**

### Step 2: User Confirmation (First)

**Required before proceeding**

Show user:
- Complete plan
- All identified risks
- Files to be modified
- Rollback strategy

### Step 3: Builder Implementation

Builder:
- Follow plan exactly
- Implement carefully
- Handle all errors
- Create checkpoints

### Step 4: Tester Verification

Tester:
- Verify all requirements
- Run all tests
- Check all edge cases
- Review code quality

### Step 5: User Review (Final)

**Required before completion**

Show user:
- All changes made
- Test results
- Any issues found
- Final approval

## Output Format

### Phase 1: Plan + Confirmation
```
⚠️ FULL WORKFLOW - CONFIRMATION REQUIRED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Task: [task description]

🧠 Thinker: Deep analysis complete...

   Plan:
   1. [Step 1 - detailed]
   2. [Step 2 - detailed]
   3. [Step 3 - detailed]

   Files to modify:
   - [File 1]
   - [File 2]

   ⚠️ Risks:
   - [Risk 1]: [Mitigation]
   - [Risk 2]: [Mitigation]

   Rollback plan:
   - [How to undo changes]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
This is a CRITICAL task. Proceed? [Y/n]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Phase 2: Implementation + Verification
```
⚠️ FULL WORKFLOW - IMPLEMENTING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[User approved]

🛠️ Builder: Implementing...
   - [Change 1]
   - [Change 2]

✅ Tester: Verifying...
   - [Test 1]: ✅ Pass
   - [Test 2]: ✅ Pass

   Edge cases checked:
   - [Case 1]: ✅ Handled

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Implementation complete. Review changes? [Y/n]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Phase 3: Final Review
```
⚠️ FULL WORKFLOW - FINAL REVIEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Changes made:
   - [File 1]: [Description]
   - [File 2]: [Description]

Tests: All passed
Edge cases: All handled

Commit these changes? [Y/n]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Examples

### Example 1: Payment Integration
```
User: "เพิ่ม Stripe payment ในระบบ"

⚠️ FULL WORKFLOW - CONFIRMATION REQUIRED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Task: Add Stripe payment integration

🧠 Thinker: Deep analysis complete...
   Research: Stripe API docs from context7

   Plan:
   1. Install @stripe/stripe-js
   2. Create payment service
   3. Add payment routes
   4. Create webhook handler
   5. Add order status handling

   Files to modify:
   - package.json (new dependency)
   - src/services/payment.ts (new)
   - src/routes/payment.ts (new)
   - src/webhooks/stripe.ts (new)

   ⚠️ Risks:
   - Payment failure: Implement retry logic
   - Webhook security: Verify signatures
   - Idempotency: Use idempotency keys

   Rollback plan:
   - Remove routes, keep service
   - Database unaffected

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
This is a CRITICAL task. Proceed? [Y/n]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Example 2: Auth System Refactor
```
User: "เปลี่ยน auth system จาก session เป็น JWT"

⚠️ FULL WORKFLOW - CONFIRMATION REQUIRED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Task: Refactor auth from session to JWT

🧠 Thinker: Deep analysis complete...

   Plan:
   1. Create JWT service
   2. Update auth middleware
   3. Migrate login/logout routes
   4. Add refresh token logic
   5. Update client-side auth

   Files to modify:
   - src/auth/* (major changes)
   - src/middleware/auth.ts (rewrite)
   - src/routes/auth.ts (rewrite)
   - All protected routes (update)

   ⚠️ Risks:
   - Breaking existing sessions: Schedule migration
   - Token theft: Implement rotation
   - Logout complexity: Blacklist needed

   Rollback plan:
   - Keep session code, feature flag JWT
   - Database: No schema changes

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
This is a CRITICAL task. Proceed? [Y/n]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Characteristics

| Aspect | Behavior |
|--------|----------|
| Planning | ✅ Deep analysis + risk assessment |
| Confirmation | ✅ **REQUIRED** (twice) |
| Verification | ✅ Full testing |
| Research | ✅ All agents |
| Audit | ✅ Complete logging |
| Rollback | ✅ Plan required |

## Time Expectation

- Target: 5-15 minutes
- Maximum: 30+ minutes (depends on task)

## Notes

- Most cautious workflow
- User has final say
- Risk assessment is critical
- Rollback plan required
- All agents have research capability
