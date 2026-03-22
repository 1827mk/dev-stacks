---
description: Full 5-phase execution — scout → architect → builder → verifier → sentinel → chronicler
argument-hint: [task description]
allowed-tools: Read, Bash, mcp__serena__read_file, mcp__serena__list_memories, mcp__serena__read_memory, mcp__memory__search_nodes
model: sonnet
---

# dev-stacks: do

Task: $ARGUMENTS

Use the **orchestrator** skill. Follow every step exactly.

Before starting:
1. Check `.dev-stacks/snapshot.md` — if unfinished task exists, ask: resume or start fresh?
2. Load `.dev-stacks/dna.json` and `.dev-stacks/plan.md` if they exist
3. If task is ambiguous — ask ONE clarifying question before spawning any agent
