# Implementation Plan: dev-stacks v4.0 Rework

**Branch**: `004-dev-stacks-v4-rework` | **Date**: 2026-03-22 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/004-dev-stacks-v4-rework/spec.md`

## Summary

dev-stacks v4.0 เป็นการ rework ครั้งใหญ่ที่รวม best features จาก Claude Forge, ECC, และ vibecosystem เข้ากับ existing unique features ของ dev-stacks (intent routing, project DNA, registry system)

**Primary Requirements:**
- Security hooks 6-layer (secret filter, SQL guard, remote command guard, rate limiter, security trigger, usage tracker)
- Instinct-based learning พร้อม JSON storage
- 5-phase swarm orchestration (Discovery → Development → Review → QA → Final)
- Multi-language rules (common/ + language-specific)
- Skill factory จาก git history
- Cross-project learning
- Agent memory พร้อม 30-day retention
- Dev-QA retry loop (max 3 retries)
- Adaptive hook loading (<200ms latency)
- ~20 specialized agents

## Technical Context

**Language/Version**: Bash 3.2+, Python 3.8+, Markdown, JSON
**Primary Dependencies**: jq (JSON processing), python3 (hooks), Claude Code CLI v2.1.0+
**Storage**: JSON files (`~/.claude/instincts/`, `.dev-stacks/dna.json`, `.dev-stacks/registry.json`)
**Testing**: Manual testing via Claude Code CLI, hook validation scripts
**Target Platform**: Claude Code CLI (macOS, Linux)
**Project Type**: Claude Code plugin (agents, skills, commands, hooks, rules)
**Performance Goals**: Hook execution <200ms p95, context recovery <10s, 85% routing accuracy
**Constraints**: No cloud sync (local-only), max 25 agents, max 200 skills, 30-day memory retention
**Scale/Scope**: ~20 agents, ~50 skills, ~40 commands, ~15 hooks, ~20 rules

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

**Status**: ✅ PASS (Constitution is template - no specific constraints defined)

No violations detected. Constitution file contains only placeholder content.

## Project Structure

### Documentation (this feature)

```text
specs/004-dev-stacks-v4-rework/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
└── tasks.md             # Phase 2 output
```

### Source Code (repository root)

```text
dev-stacks/
├── agents/                    # ~20 specialized agents
│   ├── core/                  # thinker, builder, reviewer
│   ├── security/              # security-reviewer, vulnerability-scanner
│   ├── language/              # typescript-reviewer, python-reviewer, go-reviewer, java-reviewer
│   ├── testing/               # tdd-guide, e2e-runner, qa-engineer
│   ├── devops/                # devops, database-reviewer
│   ├── learning/              # self-learner, pattern-extractor
│   ├── orchestration/         # swarm-coordinator, sentinel
│   └── documentation/         # doc-updater, technical-writer
│
├── skills/                    # ~50 skills
│   ├── security/              # security-review, vulnerability-scan
│   ├── learning/              # instinct-extract, pattern-cluster
│   ├── orchestration/         # swarm-orchestrate, dev-qa-loop
│   └── factory/               # skill-create, skill-update
│
├── commands/                  # ~40 commands
│   ├── security/              # /security-review, /security-override
│   ├── learning/              # /instinct-status, /instinct-export, /instinct-import, /evolve
│   ├── orchestration/         # /agents, /swarm, /retry
│   └── factory/               # /skill-create, /skill-update
│
├── hooks/                     # ~15 hooks
│   ├── hooks.json             # Hook registry
│   ├── scripts/               # Bash scripts
│   │   ├── session-start.sh
│   │   ├── subagent-start.sh
│   │   ├── prompt-router.sh
│   │   ├── pre-compact.sh
│   │   ├── output-secret-filter.sh    # NEW: Security
│   │   ├── remote-command-guard.sh    # NEW: Security
│   │   ├── db-guard.sh                # NEW: Security
│   │   ├── security-auto-trigger.sh   # NEW: Security
│   │   ├── rate-limiter.sh            # NEW: Security
│   │   ├── mcp-usage-tracker.sh       # NEW: Security
│   │   └── adaptive-loader.sh         # NEW: Adaptive
│   └── python/                # Python modules
│       ├── instinct_engine.py         # NEW: Learning
│       ├── complexity_scorer.py       # NEW: Orchestration
│       └── memory_manager.py          # NEW: Learning
│
├── rules/                     # ~20 rules
│   ├── common/                # Universal principles
│   │   ├── coding-style.md
│   │   ├── security.md
│   │   ├── git-workflow.md
│   │   └── golden-principles.md
│   └── languages/             # Language-specific
│       ├── typescript/
│       ├── python/
│       ├── golang/
│       └── java/
│
├── .dev-stacks/               # Project state
│   ├── dna.json               # Project fingerprint
│   ├── registry.json          # MCP/plugin registry
│   ├── snapshot.md            # Session state
│   └── instincts/             # Per-project instincts
│
└── ~/.claude/                 # Global state
    ├── instincts/             # Cross-project instincts (JSON)
    ├── agent-memory/          # Agent learnings
    └── security-events.log    # Audit log
```

**Structure Decision**: Single plugin structure with organized subdirectories. Agents organized by domain (core, security, language, testing, devops, learning, orchestration, documentation). Hooks split into scripts (Bash) and python (Python modules). Rules organized as common + language-specific.

## Complexity Tracking

> No violations to justify - constitution is template

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| N/A | N/A | N/A |

---

## Phase 0: Research Summary

See [research.md](./research.md) for detailed findings.

### Key Decisions

| Area | Decision | Rationale |
|------|----------|-----------|
| Instinct Storage | JSON files in `~/.claude/instincts/` | Fast read/write, jq-compatible, easy debugging |
| Complexity Scoring | Hybrid (keyword + AST) | Best accuracy/speed balance |
| Security Override | Per-session command `/security-override` | Safety-first with session isolation |
| Hook Latency | <200ms budget with graceful skip | Responsive UX, skip on timeout |
| Memory Retention | 30 days auto-cleanup | Prevents bloat, keeps relevant |

---

## Phase 1: Data Model

See [data-model.md](./data-model.md) for detailed entity definitions.

### Core Entities

1. **Instinct** - Learned pattern with confidence, project tags, evidence
2. **Agent Memory** - Per-agent persistent storage of learnings
3. **Project DNA** - Fingerprint of project stack, patterns, conventions
4. **Registry** - Catalog of MCP servers and plugins
5. **Snapshot** - Saved session state
6. **Skill** - Reusable workflow definition
7. **Security Event** - Audit log entry

---

## Next Steps

1. Run `/speckit.tasks` to generate detailed task breakdown
2. Implement Phase 1: Security Foundation (Week 1-2)
3. Implement Phase 2: Learning System (Week 3-4)
4. Implement Phase 3: Advanced Features (Week 5-6)
5. Implement Phase 4: Polish & Testing (Week 7-8)
