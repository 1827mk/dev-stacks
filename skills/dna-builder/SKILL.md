---
name: dna-builder
description: Use this skill when /dev-stacks:registry is run. Scans codebase with Serena, builds .dev-stacks/dna.json and registry.json for agent context.
version: 3.0.0
---

# DNA Builder Skill

Scan codebase → build project fingerprint → save for all agents.

## Process

### 1. Serena onboarding
Call `mcp__serena__check_onboarding_performed`. If false → call `mcp__serena__onboarding` first.

### 2. Project structure
Use `mcp__serena__list_dir` (recursive=false on root) to map top-level dirs.
Use `mcp__serena__find_file` to locate: `pom.xml`, `build.gradle`, `package.json`, `go.mod`, `Cargo.toml`, `pyproject.toml`.

### 3. Stack detection
Read build files → identify languages, frameworks, build tool, deployment context.

### 4. Critical paths
Use `mcp__serena__find_symbol` to locate:
- Auth entry (login, authenticate, verifyToken, JwtFilter)
- Data access (Repository, DAO, db.Query, gorm.DB)
- External calls (RestTemplate, http.Client, axios, fetch)
- Error handler (ControllerAdvice, middleware, ErrorBoundary)

### 5. Patterns
Read 5 representative files with `mcp__serena__read_file`. Extract naming, error handling, logging, testing conventions.

### 6. Write files

**`.dev-stacks/dna.json`:**
```json
{
  "version": "3.0.0",
  "created": "<ISO>",
  "project": {
    "name": "<name>",
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
    "naming": "<description>",
    "error_handling": "<description>",
    "logging": "<description>",
    "testing": "<description>"
  },
  "risk_areas": []
}
```

**`.dev-stacks/registry.json`:**
```json
{
  "version": "3.0.0",
  "updated": "<ISO>",
  "mcp_servers": ["serena", "memory", "filesystem", "context7", "fetch"],
  "intent_categories": { "<from orchestrator skill>" },
  "complexity_factors": { "<high/medium/low keywords>" }
}
```

**Rule**: Unknown value → write `"unknown"`, never guess.

### 7. Save to serena memory
`mcp__serena__write_memory` key `dev-stacks/dna` — one-paragraph project summary.

### 8. Report
```
Registry built: [project name]
Stack: [languages + frameworks]
Critical paths mapped: [N]
Risk areas: [list or "none"]
Files: .dev-stacks/dna.json, .dev-stacks/registry.json
```
