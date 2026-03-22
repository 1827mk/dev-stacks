# Research: dev-stacks v4.0 Rework

**Feature**: dev-stacks v4.0 Rework
**Date**: 2026-03-22

## Overview

Research นี้สรุปการตัดสินใจด้านเทคนิคคลสถาสำหรับ dev-stacks v4.0 โดยอ้างอิงจาก 3 reference projects: Claude Forge, ECC, และ vibecosystem

---

## 1. Security Hooks Architecture

### Decision: 6-Layer Defense (Bash-based)

**Source**: Claude Forge

| Hook | Purpose | Trigger |
|------|---------|---------|
| `output-secret-filter.sh` | Filter API keys, tokens | PostToolUse (output) |
| `remote-command-guard.sh` | Block curl|bash, wget|sh | PreToolUse (Bash) |
| `db-guard.sh` | Block DROP, TRUNCATE | PreToolUse (Bash) |
| `security-auto-trigger.sh` | Trigger security review | PostToolUse (code changes) |
| `rate-limiter.sh` | Prevent MCP abuse | PreToolUse (MCP calls) |
| `mcp-usage-tracker.sh` | Monitor MCP usage | PostToolUse (MCP) |

**Rationale:**
- Bash hooks are fast and have no dependencies
- Regex patterns work well for secret detection
- Layered defense provides defense-in-depth
- Each layer can be enabled/disabled independently
- Fail-safe defaults (block by default, allow with override)

**Alternatives Considered:**
- Single security hook: Rejected - too coarse-grained
- External security scanner: Rejected - adds latency, external dependency
- Node.js hooks: Rejected - additional dependency, slower startup

---

## 2. Instinct-Based Learning System

### Decision: JSON Storage with Confidence Scoring

**Source**: ECC (instincts v2), vibecosystem (self-learning pipeline)

**Storage Location:**
- Per-project: `.dev-stacks/instincts/*.json`
- Global (cross-project): `~/.claude/instincts/*.json`

**Storage Format:**

```json
{
  "id": "uuid-v4",
  "pattern": "Use async/await instead of .then() chains",
  "confidence": 0.85,
  "projects": ["dev-stacks", "my-app"],
  "occurrences": 7,
  "evidence": [
    "Fixed callback hell in api.ts",
    "Refactored promises in service.ts"
  ],
  "examples": [
    "// Good\nawait fetch(url);\n\n// Bad\nfetch(url).then(...).then(...)"
  ],
  "created": "2026-03-22T10:00:00Z",
  "last_used": "2026-03-22T12:00:00Z",
  "auto_inject": false
}
```

**Promotion Rules:**

| Threshold | Action |
|-----------|--------|
| confidence >= 5 occurrences | Auto-inject into context at session start |
| 2+ projects, 5+ total occurrences | Promote to global instincts |
| 10x repeat | Convert to permanent .md rule file |

**Rationale:**
- JSON is fast to read/write
- jq-compatible for CLI operations
- Human-readable for debugging
- Easy to merge/share across projects

**Alternatives Considered:**
- SQLite: Rejected - overkill for simple key-value patterns
- YAML: Rejected - slower parsing, jq incompatibility
- Markdown: Rejected - harder to parse programmatically

---

## 3. Complexity Scoring Algorithm

### Decision: Hybrid (Keyword Matching + AST Analysis)

**Source**: dev-stacks existing + vibecosystem

**Algorithm:**

```python
#!/usr/bin/env python3
"""Complexity scorer for task routing."""

import re
import json
from pathlib import Path
from typing import List

def score_complexity(prompt: str, files: List[str] = None) -> float:
    """
    Score task complexity (0.0 - 1.0).

    0.0-0.2: quick (single agent)
    0.2-0.4: standard (thinker → builder)
    0.4-0.6: careful (thinker → builder → reviewer)
    0.6+: full swarm (5-phase)
    """
    score = 0.0

    # Keyword matching (60% weight)
    keywords = {
        # High complexity
        "architecture": 0.9,
        "rewrite": 0.85,
        "migration": 0.8,
        "authentication": 0.75,
        "security": 0.7,
        "refactor": 0.65,

        # Medium complexity
        "implement": 0.5,
        "add feature": 0.45,
        "create": 0.4,

        # Low complexity
        "fix": 0.3,
        "update": 0.25,
        "change": 0.2,
        "show": 0.1,
        "list": 0.1,
    }

    prompt_lower = prompt.lower()
    for kw, weight in keywords.items():
        if kw in prompt_lower:
            score = max(score, weight)

    # AST analysis (40% weight) - if files provided
    if files:
        ast_score = analyze_structural_complexity(files)
        score = score * 0.6 + ast_score * 0.4

    return min(score, 1.0)

def analyze_structural_complexity(files: List[str]) -> float:
    """Analyze files for structural complexity."""
    if not files:
        return 0.0

    score = 0.0

    # Check for multi-file changes
    if len(files) > 5:
        score += 0.2
    if len(files) > 10:
        score += 0.2

    # Check for architectural files
    arch_patterns = ['index.ts', 'main.py', 'app.js', 'server.py', 'router']
    for f in files:
        for pattern in arch_patterns:
            if pattern in f.lower():
                score += 0.1

    return min(score, 1.0)

if __name__ == "__main__":
    import sys
    prompt = sys.argv[1] if len(sys.argv) > 1 else ""
    files = sys.argv[2:] if len(sys.argv) > 2 else []
    result = score_complexity(prompt, files)
    print(json.dumps({"complexity": result}))
```

**Workflow Selection:**

| Score Range | Workflow | Agents |
|-------------|----------|--------|
| < 0.2 | quick | Single agent (auto-select) |
| 0.2 - 0.4 | standard | thinker → builder |
| 0.4 - 0.6 | careful | thinker → builder → reviewer |
| >= 0.6 | full swarm | 5-phase (Discovery → Development → Review → QA → Final) |

**Rationale:**
- Keyword matching is fast and covers 80% of cases
- AST analysis catches structural complexity
- Hybrid provides best accuracy/speed balance
- Score is normalized to 0-1 range

**Alternatives Considered:**
- Keyword-only: Rejected - misses structural complexity
- LLM-based scoring: Rejected - adds latency and cost
- Pure AST: Rejected - slow for simple tasks

---

## 4. Security Override Behavior

### Decision: Per-Session Command `/security-override`

**Source**: Claude Forge + vibecosystem patterns

**Implementation:**

```bash
# /security-override command
# Creates a session-scoped override file

OVERRIDE_FILE="/tmp/dev-stacks-security-override-$$"

# Usage: /security-override [duration_minutes]
duration=${1:-30}  # Default 30 minutes

# Create override marker
echo "{\"enabled\": true, \"expires\": $(date -v +${duration}M +%s), \"reason\": \"user-initiated\"}" > "$OVERRIDE_FILE"

echo "⚠️ Security override ACTIVE for ${duration} minutes"
echo "All security hooks will allow blocked operations"
echo "Audit log: ~/.claude/security-events.log"
```

**Safety Features:**
- Time-limited (default 30 min, max 2 hours)
- Requires explicit command invocation
- All overrides logged to audit file
- Session-scoped (cleared on session end)
- Confirmation prompt before activation

**Audit Logging:**

```json
{
  "timestamp": "2026-03-22T10:00:00Z",
  "event": "security_override_enabled",
  "duration_minutes": 30,
  "session_id": "abc-123",
  "user_confirmed": true
}
```

**Rationale:**
- Safety-first: disabled by default
- Per-session isolation prevents persistent override
- Audit trail for compliance
- Time limit prevents indefinite exposure

**Alternatives Considered:**
- Permanent config override: Rejected - too risky
- Global environment variable: Rejected - persists across sessions
- No override option: Rejected - blocks legitimate use cases

---

## 5. Hook Execution Latency

### Decision: <200ms Total Budget with Graceful Skip

**Source**: vibecosystem (adaptive hook loading)

**Latency Budgets:**

| Component | Budget | Behavior on Exceed |
|-----------|--------|-------------------|
| Total hooks | 200ms | Skip remaining hooks, continue execution |
| Per-hook timeout | 50ms | Skip hook, log warning |
| Intent detection | 20ms | Use cached result |
| Secret filter | 30ms | Process subset of output |
| Adaptive loader | 10ms | Use standard hooks |

**Implementation:**

```bash
#!/usr/bin/env bash
# adaptive-loader.sh - Load hooks based on intent with latency budget

set -euo pipefail

START_TIME=$(date +%s%3N)
BUDGET_MS=200

# Detect intent (cached)
INTENT_CACHE="/tmp/dev-stacks-intent-$$"
if [[ -f "$INTENT_CACHE" ]] && [[ $(($(date +%s) - $(stat -c %Y "$INTENT_CACHE"))) -lt 60 ]]; then
    INTENT=$(cat "$INTENT_CACHE")
else
    # Detect intent (20ms budget)
    INTENT=$(timeout 20 python3 "${PLUGIN_ROOT}/hooks/python/intent_detect.py" "$USER_PROMPT" 2>/dev/null || echo "general")
    echo "$INTENT" > "$INTENT_CACHE"
fi

# Select hooks based on intent
case "$INTENT" in
    "code-writing") HOOKS="secret-filter,security-trigger" ;;
    "sql-operations") HOOKS="db-guard,secret-filter" ;;
    "remote-commands") HOOKS="remote-command-guard" ;;
    "learning") HOOKS="instinct-engine,memory-manager" ;;
    *) HOOKS="secret-filter" ;;  # Default minimal set
esac

# Check remaining budget
ELAPSED=$(( $(date +%s%3N) - START_TIME ))
REMAINING=$(( BUDGET_MS - ELAPSED ))

if [[ $REMAINING -lt 50 ]]; then
    echo "⚠️ Hook budget exhausted (${ELAPSED}ms), skipping adaptive hooks" >&2
    exit 0
fi

# Execute hooks within remaining budget
for hook in $HOOKS; do
    HOOK_SCRIPT="${PLUGIN_ROOT}/hooks/scripts/${hook}.sh"
    if [[ -f "$HOOK_SCRIPT" ]]; then
        timeout $(( REMAINING / ${#HOOKS} )) bash "$HOOK_SCRIPT" "$@" 2>/dev/null || true
    fi
done

TOTAL_ELAPSED=$(( $(date +%s%3N) - START_TIME ))
echo "Hooks executed in ${TOTAL_ELAPSED}ms (budget: ${BUDGET_MS}ms)" >&2
```

**Rationale:**
- Strict latency ensures responsive UX
- Graceful degradation maintains functionality
- Caching reduces repeated detection overhead
- Budget split fairly among hooks

**Alternatives Considered:**
- No timeout: Rejected - can block user indefinitely
- Hard timeout with error: Rejected - disrupts legitimate operations
- 500ms budget: Rejected - noticeable delay

---

## 6. Agent Memory Retention

### Decision: 30-Day Retention with Auto-Cleanup

**Source**: Claude Forge (agent memory), vibecosystem (canavar cross-training)

**Storage Structure:**

```
~/.claude/agent-memory/
├── thinker.json
├── builder.json
├── reviewer.json
├── security-reviewer.json
├── ...
└── error-ledger.jsonl    # Cross-training source
```

**Memory Entry Format:**

```json
{
  "agent": "builder",
  "memories": [
    {
      "id": "mem-001",
      "timestamp": "2026-03-22T10:00:00Z",
      "task": "Implement authentication",
      "lesson": "Always validate tokens before using",
      "applies_to": ["authentication", "security", "tokens"],
      "confidence": 0.85,
      "evidence": ["Fixed token validation bug in #42"]
    }
  ],
  "last_cleanup": "2026-03-22T00:00:00Z"
}
```

**Cross-Training (Canavar):**

```jsonl
{"timestamp": "2026-03-22T10:00:00Z", "agent": "builder", "error": "Missing token validation", "lesson": "Always validate tokens before using", "applies_to": ["all-agents"]}
```

**Cleanup Logic:**

```python
#!/usr/bin/env python3
"""Agent memory cleanup - prune entries older than 30 days."""

import json
from pathlib import Path
from datetime import datetime, timedelta

MEMORY_DIR = Path.home() / ".claude" / "agent-memory"
RETENTION_DAYS = 30

def cleanup_memories():
    cutoff = datetime.now() - timedelta(days=RETENTION_DAYS)

    for memory_file in MEMORY_DIR.glob("*.json"):
        if memory_file.name == "error-ledger.jsonl":
            continue

        data = json.loads(memory_file.read_text())
        original_count = len(data.get("memories", []))

        # Filter memories
        data["memories"] = [
            m for m in data.get("memories", [])
            if datetime.fromisoformat(m["timestamp"]) > cutoff
        ]

        # Prune if still too many (keep highest confidence)
        if len(data["memories"]) > 100:
            data["memories"].sort(key=lambda x: x.get("confidence", 0), reverse=True)
            data["memories"] = data["memories"][:100]

        data["last_cleanup"] = datetime.now().isoformat()
        memory_file.write_text(json.dumps(data, indent=2))

        pruned = original_count - len(data["memories"])
        if pruned > 0:
            print(f"Pruned {pruned} memories from {memory_file.stem}")

if __name__ == "__main__":
    cleanup_memories()
```

**Rationale:**
- 30 days balances relevance vs. storage
- Auto-cleanup prevents manual maintenance
- Confidence-based pruning keeps most valuable learnings
- Cross-training shares lessons across all agents

**Alternatives Considered:**
- No cleanup: Rejected - storage grows unbounded
- 7-day retention: Rejected - loses valuable patterns too quickly
- 90-day retention: Rejected - stale patterns accumulate

---

## 7. 5-Phase Swarm Orchestration

### Decision: Discovery → Development → Review → QA → Final

**Source**: vibecosystem

**Phase Breakdown:**

| Phase | Agents | Duration | Output |
|-------|--------|----------|--------|
| 1. Discovery | scout, architect, project-manager | 5-10 min | Design document, task breakdown |
| 2. Development | backend-dev, frontend-dev, devops, specialists | 20-40 min | Implemented code |
| 3. Review | code-reviewer, security-reviewer, qa-engineer | 10-20 min | Review report, fixes |
| 4. QA Loop | verifier, tdd-guide | 5-15 min | Test results, verification |
| 5. Final | self-learner, technical-writer | 5-10 min | Documentation, learnings |

**Dev-QA Retry Loop:**

```
Developer implements → Reviewer checks → Verifier tests
→ PASS → next task
→ FAIL → feedback to developer → retry (max 3)
→ 3x FAIL → escalate to user
```

**Rationale:**
- Clear phase separation
- Built-in quality gates
- Retry mechanism handles common issues
- Escalation path for persistent failures

---

## 8. Multi-Language Rules Architecture

### Decision: common/ + languages/ Directories

**Source**: ECC

**Structure:**

```
rules/
├── common/                    # Universal principles
│   ├── coding-style.md        # Formatting, naming conventions
│   ├── security.md            # OWASP top 10, secret handling
│   ├── git-workflow.md        # Branch naming, commit messages
│   └── golden-principles.md   # DRY, SOLID, KISS
│
└── languages/                # Language-specific
    ├── typescript/
    │   ├── conventions.md     # TS-specific conventions
    │   └── patterns.md        # TS design patterns
    ├── python/
    │   ├── conventions.md     # Python conventions (PEP 8)
    │   └── patterns.md        # Python patterns
    ├── golang/
    │   ├── conventions.md     # Go conventions
    │   └── patterns.md        # Go patterns
    └── java/
        ├── conventions.md     # Java conventions
        └── patterns.md        # Java patterns
```

**Auto-Detection:**

| File | Language | Rules Loaded |
|------|----------|--------------|
| `package.json` | TypeScript | common + typescript |
| `requirements.txt`, `pyproject.toml` | Python | common + python |
| `go.mod` | Go | common + golang |
| `pom.xml`, `build.gradle` | Java | common + java |
| Multiple detected | Polyglot | common + all detected |

**Rationale:**
- Common rules apply to all projects
- Language-specific rules loaded based on project
- Extensible for new languages
- Markdown format is native to Claude Code

---

## 9. Skill Factory

### Decision: Git History Analysis + Pattern Clustering

**Source**: ECC (skill-create), vibecosystem (pattern extraction)

**Process:**

1. **Analyze git history** (last 100 commits)
   ```bash
   git log --oneline -100 --format="%s"
   ```

2. **Cluster similar commits** (DBSCAN or manual grouping)
   - Group by keyword similarity
   - Minimum 5 similar commits for pattern

3. **Extract common patterns**
   - Identify repeated workflows
   - Extract steps and outcomes

4. **Generate SKILL.md**
   ```markdown
   ---
   name: fix-auth-bug
   description: Fix authentication bugs using TDD
   triggers:
     - "fix auth"
     - "authentication bug"
     - "login issue"
   steps:
     - Write failing test for auth bug
     - Implement minimal fix
     - Run tests until green
     - Review for security issues
   expected_outcomes:
     - Tests pass
     - No security vulnerabilities
     - Code reviewed
   ---

   # Skill: fix-auth-bug

   This skill guides you through fixing authentication bugs using TDD.

   ## Steps

   1. **Write failing test**: Identify the auth bug and write a test that demonstrates it
   2. **Implement minimal fix**: Make the smallest change to fix the bug
   3. **Run tests until green**: Iterate until all tests pass
   4. **Review for security**: Check for related security issues
   ```

5. **Create instinct** (simultaneous)
   - Extract pattern as instinct
   - Link to skill in evidence

**Rationale:**
- Git history contains real patterns
- Clustering identifies repeated workflows
- Skills are reusable across projects
- Instinct linkage provides context

---

## 10. Bilingual Support (Thai/English)

### Decision: Language Detection + Response Matching

**Source**: dev-stacks existing

**Implementation:**

```python
#!/usr/bin/env python3
"""Language detection for bilingual support."""

import re
from typing import Tuple

# Thai Unicode range: U+0E00 - U+0E7F
THAI_PATTERN = re.compile(r'[\u0e00-\u0e7f]+')

def detect_language(text: str) -> Tuple[str, float]:
    """
    Detect language and confidence.
    Returns: (language, confidence)
    """
    thai_chars = len(THAI_PATTERN.findall(text))
    total_chars = len(text.strip())

    if total_chars == 0:
        return ("en", 0.5)

    thai_ratio = thai_chars / total_chars

    if thai_ratio > 0.3:
        return ("th", thai_ratio)
    else:
        return ("en", 1 - thai_ratio)

def get_response_language(user_input: str) -> str:
    """Get the language to use for response."""
    lang, confidence = detect_language(user_input)
    return lang
```

**Response Guidelines:**

| Input Language | Response Language | Example |
|----------------|-------------------|---------|
| Thai (>30%) | Thai | "ระบบกำลังประมวลผล..." |
| English | English | "Processing your request..." |
| Mixed | Dominant language | Based on character ratio |

**Rationale:**
- Thai character detection is reliable
- 30% threshold handles mixed input
- Simple and fast
- Matches user's language automatically

---

## Technology Selection Summary

| Component | Technology | Rationale |
|-----------|------------|-----------|
| **Security Hooks** | Bash + regex | Fast, native, no dependencies |
| **Instinct Storage** | JSON | Fast I/O, jq-compatible, debuggable |
| **Complexity Scoring** | Python hybrid | Best accuracy/speed balance |
| **Agent Memory** | JSON | Simple, human-readable, easy cleanup |
| **Rules Format** | Markdown | Native to Claude Code |
| **Skill Format** | Markdown + YAML | Standard, readable, extensible |
| **Hook Loading** | Python intent detection | Adaptive, fast, budget-aware |
| **Language Detection** | Python regex | Simple, reliable, fast |

---

*Research complete. All NEEDS CLARIFICATION items resolved.*
