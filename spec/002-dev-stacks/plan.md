# Implementation Plan: Dev-Stacks

**Branch**: `002-dev-stacks` | **Date**: 2026-03-18 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/002-dev-stacks/spec.md`

---

## Summary

Dev-Stacks เป็น Claude Code plugin สำหรับ full-stack developer ที่ต้องการ AI ช่วยทำงานแบบ zero-friction:

1. **Intent Router** - เข้าใจภาษาธรรมชาติ (ไทย/อังกฤษ/ผสม)
2. **Adaptive Workflow** - งานเล็กทำน้อย งานใหญ่ทำมาก
3. **Agent Team** - Thinker, Builder, Tester ทำงานร่วมกัน
4. **Pattern Memory** - เรียนรู้จากงานที่สำเร็จ
5. **Safety Guards** - ป้องกันการทำลายระบบ

---

## Technical Context

**Architecture**: Pure Markdown-First (Claude Intelligence-Driven)
**Language/Version**: Markdown + YAML Frontmatter
**Primary Dependencies**: Claude Code Plugin System, MCP Memory, MCP Filesystem
**Storage**: MCP Memory (patterns), MCP Filesystem (JSON for checkpoints/DNA)
**Testing**: Manual testing + Example scenarios
**Target Platform**: Claude Code CLI (desktop/terminal)
**Project Type**: Claude Code Plugin
**Quality Goals**: Maximum output quality, Claude-driven decisions
**Constraints**: Local-first (no cloud), Zero external API calls, Pure Markdown (no TypeScript build)
**Scale/Scope**: Single developer, unlimited patterns per project

---

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

**Status**: ✅ PASS (No constitution defined - using default best practices)

**Principles Applied**:
- [x] Simplicity - Minimal commands, natural language interface
- [x] Safety - Guards enabled by default, all changes reversible
- [x] Performance - Local storage, no network calls
- [x] User Value - Zero-friction experience

---

## Project Structure

### Documentation (this feature)

```text
specs/002-dev-stacks/
├── spec.md              # Feature specification
├── plan.md              # This file
├── research.md          # Phase 0 research output
├── data-model.md        # Phase 1 data models
├── quickstart.md        # Phase 1 quickstart guide
├── contracts/
│   └── commands.md      # Command contracts
├── checklists/
│   └── requirements.md  # Spec validation checklist
└── tasks.md             # Phase 2 tasks (via /speckit.tasks)
```

### Source Code (repository root) - Pure Markdown Architecture

```text
dev-stacks/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
│
├── skills/                   # Markdown skills (Claude Intelligence)
│   ├── core/
│   │   ├── intent-router/
│   │   │   └── SKILL.md      # Intent detection (Claude-driven)
│   │   ├── complexity-scorer/
│   │   │   └── SKILL.md      # Complexity assessment
│   │   └── team-selector/
│   │       └── SKILL.md      # Agent selection
│   │
│   ├── workflows/
│   │   ├── quick/
│   │   │   └── SKILL.md      # Quick workflow
│   │   ├── standard/
│   │   │   └── SKILL.md      # Standard workflow
│   │   ├── careful/
│   │   │   └── SKILL.md      # Careful workflow
│   │   └── full/
│   │       └── SKILL.md      # Full workflow
│   │
│   └── guards/
│       ├── scope-guard/
│       │   └── SKILL.md      # Path protection
│       ├── secret-scanner/
│       │   └── SKILL.md      # Secret detection
│       └── bash-guard/
│           └── SKILL.md      # Command filtering
│
├── agents/                   # Markdown agents (Claude Intelligence)
│   ├── thinker.md            # Planning agent
│   ├── builder.md            # Implementation agent
│   └── tester.md             # Verification agent
│
├── hooks/                    # Markdown hooks (Event triggers)
│   ├── SessionStart.md       # Load DNA + patterns
│   ├── UserPromptSubmit.md   # Route to intent-router skill
│   ├── PreToolUse.md         # Call guard skills
│   ├── PostToolUse.md        # Audit logging
│   └── Stop.md               # Save checkpoint
│
├── commands/                 # Markdown commands (User commands)
│   ├── status.md             # /dev-stacks:status
│   ├── undo.md               # /dev-stacks:undo
│   ├── learn.md              # /dev-stacks:learn
│   ├── doctor.md             # /dev-stacks:doctor
│   └── help.md               # /dev-stacks:help
│
├── config/                   # JSON configuration
│   ├── defaults.json         # Default settings
│   ├── protected-paths.json  # Protected file patterns
│   └── dangerous-commands.json # Dangerous command patterns
│
└── .dev-stack/               # Runtime data (gitignored)
    ├── dna.json              # Project DNA (MCP Filesystem)
    ├── checkpoint.json       # Session checkpoint (MCP Filesystem)
    └── audit.jsonl           # Audit log (MCP Filesystem)
```

**Structure Decision**: Pure Markdown-First architecture. All intelligence (intent detection, complexity scoring, pattern matching, guard decisions) is driven by Claude through Markdown skills. No TypeScript utilities needed - Claude's intelligence provides superior quality output.

---

## Phase 0: Research Summary

See [research.md](./research.md) for full details.

### Key Decisions

| Topic | Decision | Rationale |
|-------|----------|-----------|
| Architecture | Pure Markdown-First | Maximum output quality, Claude intelligence |
| Intent Detection | Claude-driven (skill) | Context-aware, nuance understanding |
| Complexity Scoring | Claude-driven (skill) | Adaptive, explainable |
| Pattern Storage | MCP Memory (Knowledge Graph) | Semantic matching, built-in |
| Agent Communication | Sequential via conversation | Simple, natural flow |
| Checkpoint | JSON + Git (MCP Filesystem) | Reliable, human-readable |
| Multi-Language | Claude-native | No code needed, handles Thai/English/mixed |
| Research Capability | Implicit (agents decide) | Like real developers - research when needed |
| MCP Tool Access | All agents have research tools | context7, web_reader, WebSearch, fetch |

---

## Phase 1: Design Artifacts

| Artifact | Description | Status |
|----------|-------------|--------|
| [data-model.md](./data-model.md) | Entity definitions, relationships, storage | ✅ Complete |
| [contracts/commands.md](./contracts/commands.md) | Command schemas, I/O formats | ✅ Complete |
| [contracts/agents.md](./contracts/agents.md) | Agent capabilities, MCP tools access | ✅ Complete |
| [quickstart.md](./quickstart.md) | User onboarding guide | ✅ Complete |

---

## Implementation Phases

### Phase 1: Foundation (P0 - Week 1)

| Component | Description |
|-----------|-------------|
| Plugin skeleton | Directory structure, plugin.json |
| SessionStart hook | Load DNA, patterns (MCP Memory), checkpoint |
| UserPromptSubmit hook | Route to intent-router skill |
| Intent router skill | Claude-driven intent detection |
| Complexity scorer skill | Claude-driven complexity assessment |
| Builder agent | Core implementation agent (with research capability) |
| `/dev-stacks:status` | Basic status display |
| `/dev-stacks:help` | Help documentation |

**Research Integration**: Agents have implicit access to MCP research tools (context7, web_reader, WebSearch, fetch)

### Phase 2: Intelligence (P1 - Week 2)

| Component | Description |
|-----------|-------------|
| Thinker agent | Planning agent (Markdown) |
| Tester agent | Verification agent (Markdown) |
| Team selector skill | Agent selection logic |
| Pattern memory skill | MCP Memory integration |
| All workflow skills | quick, standard, careful, full |
| `/dev-stacks:undo` | Multi-level undo |
| `/dev-stacks:learn` | Pattern management |

### Phase 3: Polish (P2 - Week 3)

| Component | Description |
|-----------|-------------|
| All guard skills | scope, secret, bash |
| `/dev-stacks:doctor` | Diagnostics and recovery |
| DNA auto-refresh | Keep DNA up-to-date |
| Pattern confidence decay | Remove unused patterns |
| Full audit logging | Complete audit trail |
| Documentation | Full user guide |

---

## Complexity Tracking

> No violations - design follows simplicity principles

| Decision | Complexity | Justification |
|----------|------------|---------------|
| Pure Markdown | Low | No build step |
| MCP Memory for patterns | Low | Built-in, no server |
| 3 agents | Low | Minimum viable team |
| 5 commands | Low | Essential only |
| Claude-driven intelligence | Low | No code infrastructure |

---

## Dependencies

| Dependency | Purpose | Notes |
|------------|---------|-------|
| Claude Code | Plugin runtime | Required |
| MCP Memory | Pattern storage | Built-in |
| MCP Filesystem | JSON storage | Built-in |

---

## Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Intent detection varies | Low | Medium | Claude is consistent, show intent before proceeding |
| Guards miss edge cases | Low | Medium | Claude can explain and adapt |
| Pattern quality varies | Low | Medium | Confidence decay + user feedback |
| MCP servers unavailable | Low | High | Graceful degradation |

---

## Next Steps

1. ✅ Spec validated and complete
2. ✅ Research complete
3. ✅ Data model defined
4. ✅ Contracts documented
5. ✅ Quickstart written
6. ⏳ **Run `/speckit.tasks`** to generate implementation tasks
