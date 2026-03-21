---
description: Build project DNA and registry — scan codebase, MCP servers, and tools
allowed-tools: Read, Write, Glob, LS, Grep, Bash, mcp__serena__check_onboarding_performed, mcp__serena__onboarding, mcp__serena__list_dir, mcp__serena__find_file, mcp__serena__find_symbol, mcp__serena__read_file, mcp__serena__get_symbols_overview, mcp__serena__search_for_pattern, mcp__serena__list_memories, mcp__serena__write_memory, mcp__filesystem__read_file, mcp__filesystem__list_directory
model: opus
---

# dev-stacks: registry

Build or rebuild the dev-stacks project registry and DNA.

## Steps

1. Use **dna-builder** skill — scan codebase, write `.dev-stacks/dna.json`

2. Use **registry-builder** skill — scan MCP servers, write `.dev-stacks/registry.json`

3. Ask user to confirm the detected stack and risk areas:
   ```
   Detected: [project name] | [languages] | [frameworks]
   Risk areas: [list]
   Is this correct? (yes / correct me)
   ```
   Wait for confirmation before saving final version.

4. Report:
   ```
   Registry ready
   DNA: .dev-stacks/dna.json
   Registry: .dev-stacks/registry.json
   Next: /dev-stacks:agents [your task]
   ```
