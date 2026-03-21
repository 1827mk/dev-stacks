---
name: team
description: Use this skill when the user runs /dev-stacks:team or when task complexity >= 0.6 requiring coordinated parallel review. Lead agent + parallel security and correctness reviewers.
version: 3.0.0
---

# dev-stacks team

Coordinated agent team for complex tasks (complexity ≥ 0.6).

## When to use
- Complexity ≥ 0.6
- Multiple components affected simultaneously
- Security or payment critical
- Requires independent parallel review

## Team structure

**Lead** (orchestrates): thinker role — plans, spawns builders and reviewers, integrates results.

**Security Reviewer** (parallel): reviewer agent focused on auth, input validation, injection risks, secrets.

**Correctness Reviewer** (parallel): reviewer agent focused on requirements, enterprise constraints, regressions.

## Process

1. Lead spawns **thinker** agent → waits for `THINKER ANALYSIS`.
2. Lead spawns **builder** agent → waits for `BUILDER IMPLEMENTATION`.
3. Lead spawns **security reviewer** and **correctness reviewer** in parallel.
4. Both reviewers must return `Result: PASSED` before work is complete.
5. If either returns `Result: FAILED`: lead spawns **builder** again with all required fixes combined, then re-runs both reviewers.
6. Lead reports final summary.

## Output
```
TEAM COMPLETE
Thinker: [plan summary]
Builder: [files changed]
Security review: PASSED / FAILED — [findings]
Correctness review: PASSED / FAILED — [findings]
Status: DONE / [action needed]
```
