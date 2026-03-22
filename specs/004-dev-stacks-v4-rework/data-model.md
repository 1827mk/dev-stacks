# Data Model: dev-stacks v4.0 Rework

**Feature**: dev-stacks v4.0 Rework
**Date**: 2026-03-22

## Overview

เอกสารนี้กำหนด data structures และ entities สำหรับ dev-stacks v4.0

---

## Core Entities

### 1. Instinct

**Purpose**: เก็บ learned patterns ที่สามารถ reuse ได้

**Storage**:
- Per-project: `.dev-stacks/instincts/*.json`
- Global: `~/.claude/instincts/*.json`

**Schema**:

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["id", "pattern", "confidence", "created"],
  "properties": {
    "id": {
      "type": "string",
      "format": "uuid",
      "description": "Unique identifier (UUID v4)"
    },
    "pattern": {
      "type": "string",
      "minLength": 10,
      "maxLength": 500,
      "description": "Human-readable pattern description"
    },
    "confidence": {
      "type": "number",
      "minimum": 0,
      "maximum": 1,
      "description": "Confidence score based on occurrences"
    },
    "projects": {
      "type": "array",
      "items": { "type": "string" },
      "description": "Projects where this pattern was observed"
    },
    "occurrences": {
      "type": "integer",
      "minimum": 1,
      "description": "Total number of times pattern observed"
    },
    "evidence": {
      "type": "array",
      "items": { "type": "string" },
      "maxItems": 10,
      "description": "Evidence examples (commit messages, file changes)"
    },
    "examples": {
      "type": "array",
      "items": { "type": "string" },
      "maxItems": 5,
      "description": "Code examples showing good vs bad"
    },
    "created": {
      "type": "string",
      "format": "date-time",
      "description": "ISO 8601 timestamp when instinct created"
    },
    "last_used": {
      "type": "string",
      "format": "date-time",
      "description": "When instinct was last referenced"
    },
    "auto_inject": {
      "type": "boolean",
      "default": false,
      "description": "Whether to auto-inject at session start"
    },
    "tags": {
      "type": "array",
      "items": { "type": "string" },
      "description": "Searchable tags"
    }
  }
}
```

**State Transitions**:

```
[Created] → confidence < 5 → [Learning]
[Learning] → confidence >= 5 → [Auto-Inject]
[Auto-Inject] → 2+ projects, 5+ occurrences → [Global]
[Global] → 10x repeat → [Permanent Rule]
```

**Validation Rules**:
- Pattern must be unique (no duplicates)
- Confidence calculated as: `min(occurrences / 10, 1.0)`
- Auto-inject threshold: `occurrences >= 5`
- Global promotion: `len(projects) >= 2 AND occurrences >= 5`

---

### 2. Agent Memory

**Purpose**: เก็บ learnings ของแต่ละ agent ข้าม sessions

**Storage**: `~/.claude/agent-memory/{agent-name}.json`

**Schema**:

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["agent", "memories"],
  "properties": {
    "agent": {
      "type": "string",
      "description": "Agent name (e.g., builder, reviewer)"
    },
    "memories": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["id", "timestamp", "task", "lesson"],
        "properties": {
          "id": {
            "type": "string",
            "format": "uuid"
          },
          "timestamp": {
            "type": "string",
            "format": "date-time"
          },
          "task": {
            "type": "string",
            "maxLength": 200,
            "description": "Task description that generated this lesson"
          },
          "lesson": {
            "type": "string",
            "maxLength": 500,
            "description": "What was learned"
          },
          "applies_to": {
            "type": "array",
            "items": { "type": "string" },
            "description": "Tags for when this lesson applies"
          },
          "confidence": {
            "type": "number",
            "minimum": 0,
            "maximum": 1,
            "default": 0.5
          },
          "evidence": {
            "type": "string",
            "description": "Evidence reference (commit, file, issue)"
          }
        }
      },
      "maxItems": 100
    },
    "last_cleanup": {
      "type": "string",
      "format": "date-time"
    }
  }
}
```

**Retention Policy**:
- Keep memories for 30 days
- Prune lowest confidence when exceeding 100 entries
- Run cleanup on session start

**Cross-Training (Canavar)**:

```jsonl
{"timestamp": "2026-03-22T10:00:00Z", "agent": "builder", "error": "Missing validation", "lesson": "Always validate input", "applies_to": ["all-agents"]}
```

---

### 3. Project DNA

**Purpose**: Fingerprint ของ project stack, patterns, conventions

**Storage**: `.dev-stacks/dna.json`

**Schema**:

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["project", "languages", "frameworks", "generated"],
  "properties": {
    "project": {
      "type": "string",
      "description": "Project name"
    },
    "languages": {
      "type": "array",
      "items": { "type": "string" },
      "description": "Detected languages (e.g., typescript, python)"
    },
    "frameworks": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "name": { "type": "string" },
          "version": { "type": "string" }
        }
      },
      "description": "Detected frameworks"
    },
    "patterns": {
      "type": "array",
      "items": { "type": "string" },
      "description": "Detected patterns (e.g., hexagonal-architecture, tdd)"
    },
    "conventions": {
      "type": "object",
      "properties": {
        "naming": { "type": "string" },
        "testing": { "type": "string" },
        "documentation": { "type": "string" }
      }
    },
    "mcp_servers": {
      "type": "array",
      "items": { "type": "string" },
      "description": "Connected MCP servers"
    },
    "generated": {
      "type": "string",
      "format": "date-time"
    },
    "last_updated": {
      "type": "string",
      "format": "date-time"
    }
  }
}
```

---

### 4. Registry

**Purpose**: Catalog ของ MCP servers และ plugins

**Storage**: `.dev-stacks/registry.json`

**Schema**:

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["generated"],
  "properties": {
    "mcp_servers": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["name", "status"],
        "properties": {
          "name": { "type": "string" },
          "status": { "type": "string", "enum": ["connected", "disconnected", "error"] },
          "tools": { "type": "array", "items": { "type": "string" } },
          "resources": { "type": "array", "items": { "type": "string" } },
          "classification": { "type": "string" }
        }
      }
    },
    "plugins": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["name", "version"],
        "properties": {
          "name": { "type": "string" },
          "version": { "type": "string" },
          "path": { "type": "string" },
          "agents": { "type": "integer" },
          "skills": { "type": "integer" },
          "commands": { "type": "integer" }
        }
      }
    },
    "generated": {
      "type": "string",
      "format": "date-time"
    }
  }
}
```

---

### 5. Snapshot

**Purpose**: Saved session state สำหรับ context recovery

**Storage**: `.dev-stacks/snapshot.md`

**Format**:

```markdown
# dev-stacks snapshot — {ISO-TIMESTAMP}

## Active task
Intent: {user intent} | Workflow: {workflow-name} | Phase: {current-phase}
Prompt: {original-prompt}

## Git state
Branch: {branch-name}
HEAD: {commit-hash}
Modified:
{list of modified files}

## On restore
1. Read this snapshot before anything else.
2. Check git diff to understand what changed.
3. Confirm with user before continuing any incomplete steps.
4. Do NOT re-run completed steps.
--- END SNAPSHOT ---
```

---

### 6. Skill

**Purpose**: Reusable workflow definition

**Storage**: `skills/{category}/{skill-name}/SKILL.md`

**Schema**:

```yaml
---
name: string (required)
description: string (required)
triggers:
  - string (list of trigger patterns)
steps:
  - string (ordered list of steps)
expected_outcomes:
  - string (what should happen)
---

# Skill: {skill-name}

{detailed instructions in markdown}
```

---

### 7. Security Event

**Purpose**: Audit log สำหรับ security-relevant actions

**Storage**: `~/.claude/security-events.log`

**Format** (JSONL):

```json
{
  "timestamp": "2026-03-22T10:00:00Z",
  "event": "secret_filtered" | "command_blocked" | "override_enabled" | "vulnerability_detected",
  "severity": "low" | "medium" | "high" | "critical",
  "pattern": "string (what was detected/blocked)",
  "context": {
    "file": "optional file path",
    "command": "optional command",
    "session_id": "session identifier"
  },
  "action_taken": "string (what the system did)",
  "user_override": false
}
```

---

## Relationships

```
┌─────────────────┐     creates     ┌─────────────────┐
│    Session      │ ────────────────▶│    Snapshot     │
└─────────────────┘                  └─────────────────┘
         │
         │ extracts
         ▼
┌─────────────────┐     promotes    ┌─────────────────┐
│    Instinct     │ ────────────────▶│  Permanent Rule │
│ (per-project)   │                  │     (.md)       │
└─────────────────┘                  └─────────────────┘
         │
         │ cross-project (2+, 5+)
         ▼
┌─────────────────┐
│ Global Instinct │
│ (~/.claude/)    │
└─────────────────┘

┌─────────────────┐     learns      ┌─────────────────┐
│     Agent       │ ────────────────▶│  Agent Memory   │
└─────────────────┘                  └─────────────────┘
         │                                    │
         │ cross-trains                       │
         ▼                                    ▼
┌─────────────────┐                  ┌─────────────────┐
│  Error Ledger   │ ─────────────────▶│  Other Agents   │
└─────────────────┘                  └─────────────────┘
```

---

## Validation Rules

### Instinct Uniqueness

```python
def is_unique_instinct(pattern: str, existing: List[Instinct]) -> bool:
    """Check if pattern is unique (not duplicate)."""
    normalized = pattern.lower().strip()
    for existing in existing:
        if existing.pattern.lower().strip() == normalized:
            return False
        # Also check similarity
        if similarity_score(normalized, existing.pattern) > 0.8:
            return False
    return True
```

### Confidence Calculation

```python
def calculate_confidence(occurrences: int) -> float:
    """Calculate confidence from occurrences."""
    return min(occurrences / 10, 1.0)
```

### Auto-Inject Threshold

```python
def should_auto_inject(instinct: Instinct) -> bool:
    """Determine if instinct should be auto-injected."""
    return instinct.occurrences >= 5
```

### Global Promotion

```python
def should_promote_global(instinct: Instinct) -> bool:
    """Determine if instinct should be promoted to global."""
    return len(instinct.projects) >= 2 and instinct.occurrences >= 5
```

---

## Storage Locations

| Entity | Location | Format |
|--------|----------|--------|
| Instinct (project) | `.dev-stacks/instincts/*.json` | JSON |
| Instinct (global) | `~/.claude/instincts/*.json` | JSON |
| Agent Memory | `~/.claude/agent-memory/{agent}.json` | JSON |
| Project DNA | `.dev-stacks/dna.json` | JSON |
| Registry | `.dev-stacks/registry.json` | JSON |
| Snapshot | `.dev-stacks/snapshot.md` | Markdown |
| Skill | `skills/{category}/{name}/SKILL.md` | Markdown + YAML |
| Security Event | `~/.claude/security-events.log` | JSONL |
| Error Ledger | `~/.claude/agent-memory/error-ledger.jsonl` | JSONL |

---

*Data model complete. All entities defined with schemas, relationships, and validation rules.*
