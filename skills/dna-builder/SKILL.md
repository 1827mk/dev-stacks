---
name: dna-builder
description: Use this skill when /dev-stacks:registry is run. Scans the codebase with Serena, builds .dev-stacks/dna.json — the project fingerprint all agents use.
version: 4.0.0
---

# DNA Builder Skill

## Process

1. `mcp__serena__check_onboarding_performed` → if false, run `mcp__serena__onboarding` first
2. `mcp__serena__list_dir` (root, non-recursive) → map structure
3. `mcp__serena__find_file` for: `pom.xml`, `build.gradle`, `package.json`, `go.mod`, `Cargo.toml`, `pyproject.toml`
4. Read build files → identify stack (languages, frameworks, build tool, deployment)
5. `mcp__serena__find_symbol` for: auth entry, data access layer, external call points, error handler
6. `mcp__serena__read_file` on 5 representative files → extract patterns (naming, error handling, logging, testing)
7. `mcp__serena__list_memories` → read existing memories

Write `.dev-stacks/dna.json`:
```json
{
  "version": "4.0.0",
  "created": "<ISO>",
  "project": {
    "name": "<n>",
    "type": "<monolith|microservice|library|frontend>",
    "languages": [],
    "frameworks": [],
    "build_tool": "<tool>",
    "deployment": "<platform>"
  },
  "structure": {
    "entry_points": [],
    "source_root": "<dir>",
    "test_root": "<dir>"
  },
  "critical_paths": {
    "auth": "<file:line>",
    "data_access": "<file:line>",
    "external_calls": "<file:line>",
    "error_handling": "<file:line>"
  },
  "patterns": {
    "naming": "<desc>",
    "error_handling": "<desc>",
    "logging": "<desc>",
    "testing": "<desc>"
  },
  "risk_areas": []
}
```

Write summary to `mcp__serena__write_memory` key `dev-stacks/dna`.

**Rule**: Unknown value → write `"unknown"`, never guess.

Report:
```
DNA built: [project name]
Stack: [languages + frameworks]
Critical paths: [N] mapped
Risk areas: [list]
```
