---
name: implement
description: Use this skill when the user runs /dev-stacks:implement or when a plan already exists and implementation should start immediately without re-planning. Spawns builder only.
version: 3.0.0
---

# dev-stacks implement

Direct implementation — skips thinker, goes straight to builder.

## Use when
- A thinker plan already exists in context
- Task is simple and clearly defined
- User says "just do it" / "ทำเลย"

## Pre-condition check
Before spawning builder, verify ONE of:
- `THINKER ANALYSIS` exists in context, OR
- The task is clearly bounded (single file, known change)

If neither: recommend `/dev-stacks:run` instead.

## Process
1. Spawn **builder** agent.
2. Pass thinker's plan as context if available.
3. Report `BUILDER IMPLEMENTATION` summary.

## After builder completes
Ask user: "Run reviewer? `/dev-stacks:review` to verify."
