# Tasks: dev-stacks v4.0 Rework

**Input**: Design documents from `/specs/004-dev-stacks-v4-rework/`
**Prerequisites**: plan.md ✓, spec.md ✓, research.md ✓, data-model.md ✓, quickstart.md ✓

**Tests**: Not explicitly requested - implementation tasks only.

**Organization**: Tasks grouped by user story (US1-US7) for independent implementation.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story (US1-US7)
- File paths relative to repository root

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project structure and directory setup

- [ ] T001 Create plugin directory structure per plan.md in agents/, skills/, commands/, hooks/, rules/
- [ ] T002 [P] Create agents subdirectories: core/, security/, language/, testing/, devops/, learning/, orchestration/, documentation/
- [ ] T003 [P] Create skills subdirectories: security/, learning/, orchestration/, factory/
- [ ] T004 [P] Create commands subdirectories: security/, learning/, orchestration/, factory/
- [ ] T005 [P] Create rules subdirectories: common/, languages/typescript/, languages/python/, languages/golang/, languages/java/
- [ ] T006 [P] Create hooks subdirectories: scripts/, python/
- [ ] T007 Update hooks/hooks.json with new hook event types

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST complete before ANY user story

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [ ] T008 Create global instincts directory at `~/.claude/instincts/`
- [ ] T009 [P] Create agent-memory directory at `~/.claude/agent-memory/`
- [ ] T010 [P] Create security-events.log at `~/.claude/security-events.log`
- [ ] T011 [P] Create project state directory structure `.dev-stacks/` with dna.json, registry.json, snapshot.md templates
- [ ] T012 Update plugin.json manifest with new agents, skills, commands count
- [ ] T013 Create install.sh script for symlink installation

**Checkpoint**: Foundation ready - user story implementation can begin

---

## Phase 3: User Story 1 - Security Layer (Priority: P1) 🎯 MVP

**Goal**: 6-layer security hooks (secret filter, SQL guard, remote command guard, rate limiter, security trigger, usage tracker)

**Independent Test**: Write file with hardcoded API key, verify output filtered with [REDACTED]

### Hooks for User Story 1

- [ ] T014 [P] [US1] Create output-secret-filter.sh in hooks/scripts/ with regex patterns for API keys, tokens
- [ ] T015 [P] [US1] Create remote-command-guard.sh in hooks/scripts/ blocking curl|bash, wget|sh
- [ ] T016 [P] [US1] Create db-guard.sh in hooks/scripts/ blocking DROP, TRUNCATE, DELETE without WHERE
- [ ] T017 [P] [US1] Create security-auto-trigger.sh in hooks/scripts/ triggering review on code changes
- [ ] T018 [P] [US1] Create rate-limiter.sh in hooks/scripts/ with token bucket algorithm
- [ ] T019 [P] [US1] Create mcp-usage-tracker.sh in hooks/scripts/ logging MCP usage
- [ ] T020 [US1] Update hooks/hooks.json adding 6 security hooks to PreToolUse and PostToolUse events

### Commands for User Story 1

- [ ] T021 [P] [US1] Create security-review.md command in commands/security/
- [ ] T022 [P] [US1] Create security-override.md command in commands/security/ with per-session override logic

### Agents for User Story 1

- [ ] T023 [P] [US1] Create security-reviewer.md agent in agents/security/
- [ ] T024 [P] [US1] Create vulnerability-scanner.md agent in agents/security/

### Skills for User Story 1

- [ ] T025 [P] [US1] Create security-review skill in skills/security/SKILL.md
- [ ] T026 [P] [US1] Create vulnerability-scan skill in skills/security/SKILL.md

### Rules for User Story 1

- [ ] T027 [P] [US1] Create common/security.md rule with OWASP top 10 guidelines
- [ ] T028 [US1] Update session-start.sh to log security events

**Checkpoint**: Security Layer functional - can test independently with secret patterns

---

## Phase 4: User Story 2 - Learning System (Priority: P1)

**Goal**: Instinct-based learning with JSON storage, confidence scoring, auto-injection

**Independent Test**: Complete task, verify instinct created, restart session, verify instinct loaded

### Python Modules for User Story 2

- [ ] T029 [P] [US2] Create instinct_engine.py in hooks/python/ with extract, store, load, promote functions
- [ ] T030 [P] [US2] Create memory_manager.py in hooks/python/ with 30-day cleanup logic

### Hooks for User Story 2

- [ ] T031 [US2] Update pre-compact.sh to extract instincts before compaction
- [ ] T032 [US2] Update session-start.sh to load auto-inject instincts (confidence >= 5)

### Commands for User Story 2

- [ ] T033 [P] [US2] Create instinct-status.md command in commands/learning/
- [ ] T034 [P] [US2] Create instinct-export.md command in commands/learning/
- [ ] T035 [P] [US2] Create instinct-import.md command in commands/learning/
- [ ] T036 [P] [US2] Create evolve.md command in commands/learning/ for clustering instincts

### Agents for User Story 2

- [ ] T037 [P] [US2] Create self-learner.md agent in agents/learning/
- [ ] T038 [P] [US2] Create pattern-extractor.md agent in agents/learning/

### Skills for User Story 2

- [ ] T039 [P] [US2] Create instinct-extract skill in skills/learning/SKILL.md
- [ ] T040 [P] [US2] Create pattern-cluster skill in skills/learning/SKILL.md

**Checkpoint**: Learning System functional - instincts persist across sessions

---

## Phase 5: User Story 3 - Agent Orchestration (Priority: P1)

**Goal**: 5-phase swarm (Discovery → Development → Review → QA → Final) with Dev-QA retry loop

**Independent Test**: Submit complex task, verify 5 phases execute, verify output consolidated

### Python Modules for User Story 3

- [ ] T041 [P] [US3] Create complexity_scorer.py in hooks/python/ with hybrid algorithm

### Hooks for User Story 3

- [ ] T042 [US3] Update prompt-router.sh to use complexity scorer and select workflow

### Commands for User Story 3

- [ ] T043 [P] [US3] Create agents.md command in commands/orchestration/ (main entry point)
- [ ] T044 [P] [US3] Create swarm.md command in commands/orchestration/ for explicit 5-phase
- [ ] T045 [P] [US3] Create retry.md command in commands/orchestration/ for Dev-QA loop

### Core Agents for User Story 3

- [ ] T046 [P] [US3] Update thinker.md agent in agents/core/ with complexity awareness
- [ ] T047 [P] [US3] Update builder.md agent in agents/core/ with phase context
- [ ] T048 [P] [US3] Update reviewer.md agent in agents/core/ with QA feedback loop

### Orchestration Agents for User Story 3

- [ ] T049 [P] [US3] Create swarm-coordinator.md agent in agents/orchestration/
- [ ] T050 [P] [US3] Create sentinel.md agent in agents/orchestration/

### Testing Agents for User Story 3

- [ ] T051 [P] [US3] Create tdd-guide.md agent in agents/testing/
- [ ] T052 [P] [US3] Create e2e-runner.md agent in agents/testing/
- [ ] T053 [P] [US3] Create qa-engineer.md agent in agents/testing/

### Skills for User Story 3

- [ ] T054 [P] [US3] Create swarm-orchestrate skill in skills/orchestration/SKILL.md
- [ ] T055 [P] [US3] Create dev-qa-loop skill in skills/orchestration/SKILL.md

**Checkpoint**: Orchestration functional - 5-phase swarm works with retry loop

---

## Phase 6: User Story 4 - Rules System (Priority: P2)

**Goal**: Multi-language rules (common/ + language-specific) with auto-detection

**Independent Test**: Create Python project, verify Python rules load. Create TS project, verify TS rules load.

### Common Rules for User Story 4

- [ ] T056 [P] [US4] Create common/coding-style.md rule
- [ ] T057 [P] [US4] Create common/git-workflow.md rule
- [ ] T058 [P] [US4] Create common/golden-principles.md rule (DRY, SOLID, KISS)

### Language Rules for User Story 4

- [ ] T059 [P] [US4] Create languages/typescript/conventions.md rule
- [ ] T060 [P] [US4] Create languages/typescript/patterns.md rule
- [ ] T061 [P] [US4] Create languages/python/conventions.md rule (PEP 8)
- [ ] T062 [P] [US4] Create languages/python/patterns.md rule
- [ ] T063 [P] [US4] Create languages/golang/conventions.md rule
- [ ] T064 [P] [US4] Create languages/golang/patterns.md rule
- [ ] T065 [P] [US4] Create languages/java/conventions.md rule
- [ ] T066 [P] [US4] Create languages/java/patterns.md rule

### Auto-Detection for User Story 4

- [ ] T067 [US4] Update session-start.sh to detect project languages and load rules

**Checkpoint**: Rules System functional - language-appropriate rules auto-load

---

## Phase 7: User Story 5 - Skill Factory (Priority: P2)

**Goal**: Generate skills from git history analysis with pattern clustering

**Independent Test**: Make 5 similar commits, run skill-create, verify skill.md generated

### Commands for User Story 5

- [ ] T068 [P] [US5] Create skill-create.md command in commands/factory/
- [ ] T069 [P] [US5] Create skill-update.md command in commands/factory/

### Skills for User Story 5

- [ ] T070 [P] [US5] Create skill-create skill in skills/factory/SKILL.md
- [ ] T071 [P] [US5] Create skill-update skill in skills/factory/SKILL.md

### Hook Integration for User Story 5

- [ ] T072 [US5] Update pre-compact.sh to trigger skill creation when patterns reach 10x threshold

**Checkpoint**: Skill Factory functional - skills generated from git history

---

## Phase 8: User Story 6 - Cross-Project Learning (Priority: P2)

**Goal**: Share learned patterns across projects (2+ projects, 5+ occurrences → global)

**Independent Test**: Learn pattern in project A, verify pattern appears in project B

### Hooks for User Story 6

- [ ] T073 [US6] Update instinct_engine.py to promote to global when threshold reached
- [ ] T074 [US6] Update session-start.sh to load global instincts

### Commands for User Story 6

- [ ] T075 [US6] Update instinct-export.md to support cross-project sharing

**Checkpoint**: Cross-Project Learning functional - patterns shared automatically

---

## Phase 9: User Story 7 - Bilingual Support (Priority: P3)

**Goal**: Thai/English language detection and response matching

**Independent Test**: Send Thai message, verify Thai response. Send English, verify English.

### Python Module for User Story 7

- [ ] T076 [P] [US7] Create language_detect.py in hooks/python/ with Thai character detection

### Hook Integration for User Story 7

- [ ] T077 [US7] Update session-start.sh to detect user language preference
- [ ] T078 [US7] Update prompt-router.sh to preserve language in routing context

**Checkpoint**: Bilingual Support functional - responses match user language

---

## Phase 10: Remaining Agents (Language, DevOps, Documentation)

**Purpose**: Complete remaining specialized agents

- [ ] T079 [P] Create typescript-reviewer.md agent in agents/language/
- [ ] T080 [P] Create python-reviewer.md agent in agents/language/
- [ ] T081 [P] Create go-reviewer.md agent in agents/language/
- [ ] T082 [P] Create java-reviewer.md agent in agents/language/
- [ ] T083 [P] Create devops.md agent in agents/devops/
- [ ] T084 [P] Create database-reviewer.md agent in agents/devops/
- [ ] T085 [P] Create doc-updater.md agent in agents/documentation/
- [ ] T086 [P] Create technical-writer.md agent in agents/documentation/

---

## Phase 11: Polish & Cross-Cutting Concerns

**Purpose**: Final improvements and validation

- [ ] T087 [P] Create adaptive-loader.sh in hooks/scripts/ with intent-based hook selection
- [ ] T088 [P] Update hooks.json with adaptive-loader integration
- [ ] T089 Update CLAUDE.md with v4.0 features documentation
- [ ] T090 [P] Create validation script to test all acceptance scenarios
- [ ] T091 [P] Run quickstart.md validation scenarios
- [ ] T092 Performance optimization for <200ms hook latency
- [ ] T093 Final integration test of all 7 user stories

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - start immediately
- **Foundational (Phase 2)**: Depends on Setup - BLOCKS all user stories
- **User Stories (Phase 3-9)**: All depend on Foundational phase
  - US1-US3 (P1) can run in parallel after Foundation
  - US4-US6 (P2) can run in parallel after P1 stories
  - US7 (P3) can run anytime after Foundation
- **Remaining Agents (Phase 10)**: Can run in parallel with any phase
- **Polish (Phase 11)**: Depends on all desired user stories complete

### User Story Dependencies

- **US1 (Security)**: Independent - no dependencies on other stories
- **US2 (Learning)**: Independent - no dependencies on other stories
- **US3 (Orchestration)**: Independent - no dependencies on other stories
- **US4 (Rules)**: Independent - no dependencies on other stories
- **US5 (Skill Factory)**: Benefits from US2 (instincts) but independently testable
- **US6 (Cross-Project)**: Depends on US2 (instinct system)
- **US7 (Bilingual)**: Independent - no dependencies

### Parallel Opportunities

**Within Phase 1 (Setup):**
- T002-T006 can run in parallel (different directories)

**Within Phase 2 (Foundation):**
- T008-T011 can run in parallel (different files)

**Within User Story 1:**
- T014-T019 (hooks) can run in parallel
- T021-T022 (commands) can run in parallel
- T023-T028 (agents/skills/rules) can run in parallel

**Across User Stories:**
- After Foundation: US1, US2, US3 can start in parallel
- US4, US5, US7 can start anytime
- US6 waits for US2

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1 (Security)
4. **STOP and VALIDATE**: Test security hooks independently
5. Deploy - Security Layer is usable MVP

### Incremental Delivery (Recommended)

1. Setup + Foundation → Infrastructure ready
2. US1 (Security) → Test → Deploy (Week 1-2)
3. US2 (Learning) → Test → Deploy (Week 3)
4. US3 (Orchestration) → Test → Deploy (Week 4)
5. US4-US6 (P2 features) → Test → Deploy (Week 5-6)
6. US7 (Bilingual) → Test → Deploy (Week 7)
7. Polish → Final validation (Week 8)

### Parallel Team Strategy

With 3 developers after Foundation:

- **Developer A**: US1 (Security) + US4 (Rules)
- **Developer B**: US2 (Learning) + US6 (Cross-Project)
- **Developer C**: US3 (Orchestration) + US5 (Skill Factory)
- **Shared**: US7 (Bilingual), Phase 10 (Agents), Phase 11 (Polish)

---

## Summary

| Category | Count |
|----------|-------|
| **Total Tasks** | 93 |
| **Setup Phase** | 7 |
| **Foundation Phase** | 6 |
| **US1 (Security)** | 15 |
| **US2 (Learning)** | 12 |
| **US3 (Orchestration)** | 15 |
| **US4 (Rules)** | 12 |
| **US5 (Skill Factory)** | 5 |
| **US6 (Cross-Project)** | 3 |
| **US7 (Bilingual)** | 3 |
| **Remaining Agents** | 8 |
| **Polish** | 7 |
| **Parallel Tasks** | 61 (65%) |

---

*Tasks generated from spec.md, plan.md, data-model.md, research.md*
