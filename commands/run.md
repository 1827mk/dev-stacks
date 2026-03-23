---
description: Alias for /dev-stacks — smart entry point that reads context and routes to the right workflow
argument-hint: [task description or question]
allowed-tools: Read, Bash, mcp__serena__read_file, mcp__serena__list_memories, mcp__serena__read_memory, mcp__memory__search_nodes
model: sonnet
---

# dev-stacks:run

> **Note:** This is an alias for `/dev-stacks`. Use either command interchangeably.

Task: $ARGUMENTS

## Steps

1. **Load context**
   - Read `.dev-stacks/snapshot.md` — if unfinished task exists, show user and ask: resume or start fresh?
   - Read `.dev-stacks/dna.json` — load project context
   - Read `.dev-stacks/state.json` — get last intent/complexity if < 30 min old

2. **Route based on task**
   - If task is a question/explanation → answer directly, no agents
   - If task is ambiguous → ask 1 clarifying question before routing
   - Otherwise → use **orchestrator** skill to classify and execute

3. **Never assume** — if unsure what the user wants, ask before spawning agents
