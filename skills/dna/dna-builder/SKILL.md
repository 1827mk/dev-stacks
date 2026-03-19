---
name: dna-builder
description: Build/update Project DNA - codebase knowledge. Use on first run or structural changes.
---

# DNA Builder

Build and maintain Project DNA in `.dev-stacks/dna.json`.

## DNA Structure

```json
{
  "version": "1.0.0",
  "identity": {
    "name": "project-name",
    "type": "FULLSTACK|FRONTEND|BACKEND|LIBRARY|CLI|MOBILE|MONOREPO",
    "languages": ["TypeScript"],
    "frameworks": ["React", "Express"],
    "build_tools": ["npm", "vite"],
    "testing": ["Jest"]
  },
  "architecture": {
    "entry_points": [{"path": "src/index.tsx", "type": "FRONTEND"}],
    "key_modules": [{"path": "src/auth", "risk_level": "CRITICAL"}],
    "config_files": [{"path": "tsconfig.json"}]
  },
  "patterns": {
    "naming_conventions": {"components": "PascalCase", "files": "kebab-case"},
    "file_organization": "FEATURE_BASED|LAYERED",
    "testing_strategy": "UNIT|INTEGRATION|E2E"
  },
  "risk_areas": {
    "paths": ["src/auth", "src/payment"],
    "details": {"src/auth": {"severity": "CRITICAL", "guards": ["NEEDS_CONFIRMATION"]}}
  },
  "learned": {
    "common_tasks": [{"description": "Add validation", "frequency": 5}],
    "successful_patterns": [{"name": "Form Validation", "confidence": 0.92}]
  },
  "metrics": {"total_files": 150, "lines_of_code": 15000}
}
```

## Detection

| Signal | Detection |
|--------|-----------|
| Type | package.json + index.html = FRONTEND; + server.ts = BACKEND |
| Language | .ts=TypeScript, .py=Python, .go=Go |
| Framework | react, vue, express, fastapi from package.json |
| Risk | auth/, payment/, users/ paths |

## Operations

| Trigger | Action |
|---------|--------|
| First run | Full scan → build DNA |
| Task success | Update learned patterns |
| DNA age > 7 days | Refresh recommendation |

## MCP Tools
- `directory_tree` - scan structure
- `read_text_file` - read configs
- `write_file` - save DNA
- `search_files` - find patterns

## Commands
- `/dev-stacks:init` - build DNA
- `/dev-stacks:doctor --refresh-dna` - refresh
