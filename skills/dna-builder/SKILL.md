---
name: dna-builder
description: Use this skill when the user runs /dev-stacks:init. Scans the codebase and builds .dev-stacks/dna.json — the project fingerprint that all agents read each session.
version: 3.0.0
---

# dev-stacks DNA builder

Build a structured fingerprint of the current codebase.

## Process

### 1. Check onboarding
Call `mcp__serena__check_onboarding_performed`. If not done, call `mcp__serena__onboarding` first.

### 2. Detect project structure
Use `mcp__serena__list_dir` (recursive) to map top-level directories.
Use `mcp__serena__find_file` to locate: `pom.xml`, `build.gradle`, `package.json`, `go.mod`, `Cargo.toml`, `requirements.txt`.

### 3. Identify stack
From build files determine: languages, frameworks, build tools, deployment context.

### 4. Map critical paths
Use `mcp__serena__find_symbol` to locate:
- Auth entry point (login, authenticate, JWT verify)
- Data access layer (repository, DAO, ORM config)
- External call points (HTTP clients, MQ producers)
- Global error handler

### 5. Detect patterns
Read 5–10 representative files with `mcp__serena__read_file`. Extract:
- Naming conventions, error handling style, logging pattern, test pattern.

### 6. Check existing memories
Call `mcp__serena__list_memories` — read any relevant memory files.

### 7. Write DNA file
Write `.dev-stacks/dna.json`:

```json
{
  "version": "3.0.0",
  "created": "<ISO timestamp>",
  "project": {
    "name": "<name>",
    "type": "<monolith|microservice|library|frontend>",
    "languages": ["<lang>"],
    "frameworks": ["<framework>"],
    "build_tool": "<tool>",
    "deployment": "<platform>"
  },
  "structure": {
    "entry_points": ["<file>"],
    "source_root": "<dir>",
    "test_root": "<dir>",
    "config_files": ["<file>"]
  },
  "critical_paths": {
    "auth": "<file:line>",
    "data_access": "<file:line>",
    "external_calls": "<file:line>",
    "error_handling": "<file:line>"
  },
  "patterns": {
    "naming": "<description>",
    "error_handling": "<description>",
    "logging": "<description>",
    "testing": "<description>"
  },
  "risk_areas": ["<area that needs extra care>"]
}
```

**Rule**: Never write a value you have not confirmed from reading a real file. Unknown → `"unknown"`.

### 8. Save to serena memory
Call `mcp__serena__write_memory` with key `dev-stacks/dna-summary` — write a one-paragraph summary for future sessions.

### 9. Report
```
DNA built: [project name]
Stack: [languages + frameworks]
Critical paths: [count] mapped
Risk areas: [list]
Saved to: .dev-stacks/dna.json + serena memory
```
