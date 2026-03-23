---
description: Scan project and build DNA — run once per project, or after major refactor
argument-hint: [optional: project path, defaults to current directory]
allowed-tools: Read, Write, Glob, LS, Grep, Bash, mcp__serena__check_onboarding_performed, mcp__serena__onboarding, mcp__serena__list_dir, mcp__serena__find_file, mcp__serena__find_symbol, mcp__serena__read_file, mcp__serena__get_symbols_overview, mcp__serena__search_for_pattern, mcp__serena__list_memories, mcp__serena__write_memory, mcp__filesystem__read_file, mcp__filesystem__list_directory
model: opus
---

# dev-stacks: init

Use the **dna-builder** skill. Follow every step exactly.

After DNA is written, ask user to confirm the detected stack:
```
Detected: [name] | [languages] | [frameworks]
Risk areas: [list]
Is this correct? (yes / correct me)
```

Wait for confirmation before finalising.
