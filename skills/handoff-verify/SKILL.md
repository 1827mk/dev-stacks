---
name: handoff-verify
description: Use this skill to spawn a fresh-context agent that verifies work independently — without bias from the current session. Used in full workflow and /dev-stacks:check.
version: 4.0.0
---

# Handoff Verify Skill

Spawn a fresh agent with zero context to independently verify the work.

## Why this matters

After a long session, Claude may have blind spots. A fresh agent with only the essentials sees the code with new eyes — catching what the original session missed.

## Process

1. Collect essentials to pass to fresh agent:
   - The original task description (from state.json or snapshot.md)
   - List of files changed (from builder output)
   - The architect plan (from plan.md)

2. Spawn a fresh **verifier** subagent with ONLY these essentials as context (not the full conversation)

3. Fresh agent's job:
   - Read each changed file fresh with Serena
   - Verify implementation matches the original task
   - Run tests if available
   - Check for obvious errors that session bias might have missed

4. Report findings to user

## Output — REQUIRED

Fresh agent must output:

```
HANDOFF VERIFIED

Files reviewed: [list]
Task match: yes / [what's missing]
Tests: [result or "not run"]

Issues found (fresh eyes):
- [issue at file:line] / (none)

Verdict: CLEAN / NEEDS ATTENTION
```
