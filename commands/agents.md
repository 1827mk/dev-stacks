---
description: Main entry point — orchestrate any dev task automatically
argument-hint: [task description]
allowed-tools: Read, Bash, mcp__serena__read_file, mcp__serena__list_memories, mcp__serena__read_memory, mcp__memory__search_nodes
model: sonnet
---

# dev-stacks: agents

Task: $ARGUMENTS

## Steps

1. Check `.dev-stacks/snapshot.md` — if exists with unfinished task:
   - Show user: task description + remaining steps
   - Ask: "Resume this task or start fresh?"
   - Wait for answer before proceeding

2. Load `.dev-stacks/dna.json` if exists — pass as context to orchestrator

3. Load `.dev-stacks/registry.json` if exists — pass as context to orchestrator

4. Use **orchestrator** skill to classify, select workflow, and execute

5. If at any point the task is ambiguous — ask the user to clarify before spawning agents
