# Data Model: Dev-Stacks

**Feature**: 002-dev-stacks
**Created**: 2026-03-18
**Updated**: 2026-03-18

---

## Overview

Dev-Stacks ใช้ data models สำหรับ:
1. **Pattern Memory** - เก็บ patterns ที่เรียนรู้ (MCP Memory)
2. **Checkpoint** - เก็บสถานะ session (MCP Filesystem)
3. **Project DNA** - เก็บความรู้เกี่ยวกับ project (MCP Filesystem)
4. **Guard Rules** - เก็บ rules สำหรับ safety (JSON config)

**Storage Strategy**: Pure Markdown-First with MCP tools for persistence

---

## Entities

### 1. Intent

Represents user's goal from natural language input.

```
Intent
├── category: enum [FIX_BUG, ADD_FEATURE, MODIFY_BEHAVIOR, OPTIMIZE, INVESTIGATE, EXPLAIN, SETUP, DEPLOY, OTHER]
├── target: string          # What to act on (file, function, module)
├── description: string     # Original user input
├── language: enum [TH, EN, MIXED]
├── confidence: float       # 0.0-1.0
└── context: string[]       # Relevant context hints
```

**State Transitions**: N/A (immutable once created)

**Validation Rules**:
- `category` must be valid enum value
- `target` must not be empty if `category` is not OTHER
- `confidence` must be between 0.0 and 1.0

---

### 2. Task

Represents a unit of work to be executed.

```
Task
├── id: string (UUID)
├── intent: Intent
├── complexity: ComplexityScore
├── workflow: enum [QUICK, STANDARD, CAREFUL, FULL]
├── team: Agent[]           # Assigned agents
├── status: enum [PENDING, THINKING, BUILDING, TESTING, COMPLETED, FAILED]
├── created_at: timestamp
├── started_at: timestamp?
├── completed_at: timestamp?
├── result: TaskResult?
└── error: string?
```

**State Transitions**:
```
PENDING → THINKING → BUILDING → TESTING → COMPLETED
    │         │          │          │
    └─────────┴──────────┴──────────┴──→ FAILED
```

**Validation Rules**:
- `complexity.total` must be between 0.0 and 1.0
- `team` must have at least one agent
- `workflow` must match complexity range:
  - 0.0-0.19 → QUICK
  - 0.2-0.39 → STANDARD
  - 0.4-0.59 → CAREFUL
  - 0.6-1.0 → FULL

---

### 3. ComplexityScore

Represents the complexity assessment of a task.

```
ComplexityScore
├── files_affected: float    # 0.0-0.3
├── risk_level: float        # 0.0-0.3
├── dependencies: float      # 0.0-0.2
├── cross_cutting: float     # 0.0-0.2
├── total: float             # Sum of above (0.0-1.0)
├── factors: string[]        # Human-readable factors
└── recommendation: string   # Workflow recommendation
```

**Calculation**:
```
total = files_affected + risk_level + dependencies + cross_cutting
```

**Validation Rules**:
- Each component must be within its range
- `total` must equal sum of components

---

### 4. Pattern

Represents a reusable solution template.

**Storage**: MCP Memory (Knowledge Graph)

```
Pattern (as Entity in Knowledge Graph)
├── name: "Pattern: [pattern-name]"
├── entityType: "dev-stacks-pattern"
└── observations: [
      "trigger_keywords: [keywords that activate pattern]",
      "intent_category: [FIX_BUG | ADD_FEATURE | ...]",
      "solution_steps: [step-by-step instructions]",
      "code_example: [optional code template]",
      "use_count: [number]",
      "success_count: [number]",
      "failure_count: [number]",
      "confidence: [0.0-1.0]",
      "created_at: [ISO-8601]",
      "last_used_at: [ISO-8601]"
    ]
```

**MCP Memory Structure**:
```json
{
  "name": "Pattern: Login Form Validation",
  "entityType": "dev-stacks-pattern",
  "observations": [
    "trigger_keywords: [validation, form, login, email]",
    "intent_category: ADD_FEATURE",
    "solution_steps: [1. Find form component, 2. Add validation rules, 3. Update error messages]",
    "code_example: "..."",
    "use_count: 5",
    "success_count: 4",
    "failure_count: 1",
    "confidence: 0.8",
    "created_at: 2026-03-18T10:00:00Z",
    "last_used_at: 2026-03-18T15:30:00Z"
  ]
}
```

**State Transitions**:
- Confidence increases on successful use
- Confidence decreases on failure
- Pattern deleted if confidence < threshold and unused > 30 days

**Validation Rules**:
- `name` must be unique
- `confidence` = success_count / (success_count + failure_count)
- Pattern is invalid if use_count = 0 and age > 30 days

**MCP Tools Used**:
- `create_entities` - Store new pattern
- `search_nodes` - Find matching patterns
- `add_observations` - Update use/success counts
- `delete_entities` - Remove low-confidence patterns

---

### 5. Checkpoint

Represents session state for recovery.

**Storage**: MCP Filesystem (JSON file)

**File Location**: `.dev-stack/checkpoint.json`

```json
{
  "session_id": "uuid-v4",
  "timestamp": "2026-03-18T15:30:00Z",
  "state": {
    "phase": "BUILDING",
    "current_task": "Add login validation",
    "progress": 65
  },
  "context": {
    "files_touched": ["src/auth/login.ts", "src/auth/login.test.ts"],
    "decisions_made": [
      {
        "question": "Use JWT or session?",
        "answer": "JWT",
        "reason": "Stateless, easier to scale"
      }
    ],
    "patterns_used": ["Pattern: Form Validation"]
  },
  "recovery": {
    "base_commit": "abc123def456",
    "undo_stack": [
      {
        "timestamp": "2026-03-18T15:25:00Z",
        "action": "Edit src/auth/login.ts",
        "files_modified": ["src/auth/login.ts"],
        "git_diff": "--- a/src/auth/login.ts\n+++ b/src/auth/login.ts\n..."
      }
    ]
  },
  "next_steps": [
    "Add error handling",
    "Write tests"
  ]
}
```

**MCP Filesystem Tools Used**:
- `read_text_file` - Load checkpoint
- `write_file` - Save checkpoint
- `get_file_info` - Check if checkpoint exists

**Validation Rules**:
- `base_commit` must be valid git commit hash
- `undo_stack` max 20 entries (configurable)
- File must be valid JSON

---

### 6. ProjectDNA

Represents accumulated knowledge about the project.

**Storage**: MCP Filesystem (JSON file)

**File Location**: `.dev-stack/dna.json`

```json
{
  "version": "1.0.0",
  "updated": "2026-03-18T15:30:00Z",
  "identity": {
    "name": "my-project",
    "type": "FULLSTACK",
    "languages": ["TypeScript", "JavaScript"],
    "frameworks": ["React", "Express"],
    "build_tools": ["npm", "vite"]
  },
  "architecture": {
    "structure": {
      "name": "src",
      "type": "DIRECTORY",
      "purpose": "Source code",
      "children": [
        {"name": "components", "type": "DIRECTORY", "purpose": "React components"},
        {"name": "services", "type": "DIRECTORY", "purpose": "API services"}
      ]
    },
    "entry_points": ["src/index.tsx", "src/server.ts"],
    "key_modules": [
      {"path": "src/auth", "exports": ["login", "logout", "validateToken"]}
    ],
    "config_files": ["tsconfig.json", "vite.config.ts"]
  },
  "patterns": {
    "naming_conventions": {
      "components": "PascalCase",
      "functions": "camelCase",
      "files": "kebab-case"
    },
    "file_organization": "Feature-based structure",
    "testing_strategy": "Jest + React Testing Library",
    "common_imports": ["react", "express", "zod"]
  },
  "risk_areas": {
    "paths": ["src/auth", "src/payment"],
    "reasons": {
      "src/auth": "Authentication logic - high risk",
      "src/payment": "Payment processing - high risk"
    }
  },
  "learned": {
    "common_tasks": [
      {"description": "Add form validation", "frequency": 5},
      {"description": "Create API endpoint", "frequency": 3}
    ],
    "preferences": {
      "test_first": false,
      "use_types": true
    }
  }
}
```

**MCP Filesystem Tools Used**:
- `read_text_file` - Load DNA
- `write_file` - Save DNA
- `directory_tree` - Scan project structure

---

### 7. GuardRule

Represents a safety rule.

**Storage**: JSON file in plugin config

**File Location**: `dev-stacks/config/guards.json`

```json
{
  "rules": [
    {
      "id": "scope-env-files",
      "type": "SCOPE",
      "pattern": ".env*",
      "action": "BLOCK",
      "reason": "Environment files contain secrets",
      "severity": "CRITICAL",
      "enabled": true
    },
    {
      "id": "scope-config",
      "type": "SCOPE",
      "pattern": "*.config.*",
      "action": "CONFIRM",
      "reason": "Configuration files may affect project behavior",
      "severity": "MEDIUM",
      "enabled": true
    },
    {
      "id": "bash-rm-rf",
      "type": "BASH",
      "pattern": "rm -rf /",
      "action": "BLOCK",
      "reason": "Destructive command",
      "severity": "CRITICAL",
      "enabled": true
    }
  ]
}
```

**Guard Types**:
| Type | Purpose |
|------|---------|
| SCOPE | Path-based file protection |
| SECRET | Content pattern detection (secrets in code) |
| BASH | Command filtering |

**Validation Rules**:
- `pattern` must be valid glob (for SCOPE) or regex (for SECRET/BASH)
- `action` BLOCK for CRITICAL severity
- `action` CONFIRM for HIGH/MEDIUM severity

---

### 8. Research Finding

Represents information gathered from external sources.

**Storage**: Transient (in conversation context) or saved as Pattern

```typescript
interface ResearchFinding {
  topic: string;              // What was researched
  trigger: string;            // Why research was needed
  sources: Source[];          // Where information came from
  key_findings: string[];     // Main learnings
  code_examples: string[];    // Relevant code snippets
  best_practices: string[];   // Recommended practices
  gotchas: string[];          // Warnings/things to avoid
  timestamp: string;          // When researched
}
```

```
Source
├── type: enum [CONTEXT7 | WEB_READER | WEB_SEARCH | FETCH]
├── url: string?            // Original URL if applicable
├── title: string           // Source title
└── relevance: string       // Why this source was chosen
```

**Lifecycle**:
1. Created when agent identifies knowledge gap
2. Stored temporarily in conversation context
3. May be saved as Pattern if useful for future

**Not Persisted Separately** - Research findings flow through conversation context and may become Patterns

---

## Relationships

```
User Input
    │
    ▼
Intent ──────────────────┐
    │                    │
    ▼                    │
ComplexityScore          │
    │                    │
    ▼                    │
Task ◄───────────────────┘
    │
    ├──► Pattern (if pattern suggested)
    │         └── Stored in MCP Memory
    │
    └──► Checkpoint (created during execution)
              └── Stored in MCP Filesystem

Task (completed) ──► Pattern (extracted if successful)

Project DNA ◄─── All Tasks (learns from usage)
        └── Stored in MCP Filesystem
```

---

## Storage Locations

| Entity | Storage | MCP Tool | Format |
|--------|---------|----------|--------|
| Pattern | MCP Memory | `memory` | Knowledge Graph |
| Checkpoint | `.dev-stack/checkpoint.json` | `filesystem` | JSON |
| Project DNA | `.dev-stack/dna.json` | `filesystem` | JSON |
| Guard Rules | `config/guards.json` | `filesystem` | JSON |
| Audit Log | `.dev-stack/audit.jsonl` | `filesystem` | JSONL |

**Benefits of MCP Storage**:
- ✅ No SQLite dependencies
- ✅ Built-in Claude Code integration
- ✅ Semantic search via MCP Memory
- ✅ Human-readable JSON files

---

## Data Retention

| Data | Retention | Cleanup Policy |
|------|-----------|----------------|
| Patterns | Indefinite | Delete if confidence < 0.3 and unused > 30 days |
| Checkpoints | Session only | Delete on session end (keep last 3) |
| Audit Log | 30 days | Archive to `.dev-stack/archive/` |
| Undo Stack | 20 entries | FIFO when full |
