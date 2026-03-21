---
description: Run task through dev-stacks workflow — auto-selects quick/standard/careful/full
argument-hint: [task description]
allowed-tools: Read, Bash, mcp__serena__read_file, mcp__serena__list_memories, mcp__serena__read_memory
model: sonnet
---

# dev-stacks: run

Task: $ARGUMENTS

Steps:
1. Check `.dev-stacks/snapshot.md` — if exists with unfinished task, ask: resume or start fresh?
2. Check `.dev-stacks/dna.json` — load as context for agents.
3. Use **orchestrator** skill to route and execute.
