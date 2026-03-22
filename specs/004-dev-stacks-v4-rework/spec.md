# Feature Specification: dev-stacks v4.0 Rework

**Feature Branch**: `004-dev-stacks-v4-rework`
**Created**: 2026-03-22
**Status**: Draft
**Input**: dev-stacks v4.0 — Complete rework combining best features from Claude Forge, ECC, and vibecosystem. Target: ~20 agents, security hooks (6-layer), instinct-based learning, multi-language rules, 5-phase swarm orchestration, cross-project learning, skill factory, agent memory, Dev-QA retry loop, adaptive hook loading. Keep existing unique features: intent routing, project DNA, registry system. Thai/English bilingual support maintained.

## Clarifications

### Session 2026-03-22

- Q: What storage format for instincts? → A: JSON files (fast read/write, easy debugging, jq-compatible)
- Q: What algorithm for complexity scoring? → A: Hybrid (keyword matching + AST analysis) — best accuracy/speed balance for workflow selection
- Q: How should security hooks handle overrides? → A: Per-session command (`/security-override`) — safety-first with session isolation, requires explicit enable
- Q: What is the target latency for hook execution? → A: <200ms total — strict latency budget ensures responsive UX, hooks must complete within budget or skip gracefully
- Q: What retention policy for agent memory? → A: 30 days with auto-cleanup — prevents storage bloat, keeps recent learnings relevant

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Security Layer (Priority: P1)

**Thai**: นักพัฒนาเขียนโค้ดที่มี API key หรือ token ระบบต้องตรวจจับและบล็อกการรั่วไหลโดยอัตโนมัติ

**English**: Developer writes code with API keys or tokens. System detects and blocks leakage automatically.

**Why this priority**: Security is foundational. Leaked secrets cause significant damage before other features matter.

**Independent Test**: Write a file with hardcoded API key, verify output is filtered with [REDACTED].

**Acceptance Scenarios**:

1. **Given** output contains `sk-abc123` pattern, **When** hook processes output, **Then** pattern replaced with `[REDACTED]`
2. **Given** developer runs `DROP TABLE users;`, **When** command submitted, **Then** blocked with confirmation prompt
3. **Given** developer runs `curl ... | bash`, **When** command submitted, **Then** blocked with warning

---

### User Story 2 - Learning System (Priority: P1)

**Thai**: นักพัฒนาทำงานเสร็จ ระบบดึงรูปแบบเป็น "instinct" ไว้ใช้ใน session ถัดไป

**English**: Developer completes task. System extracts pattern as "instinct" for reuse in future sessions.

**Why this priority**: Learning enables continuous improvement. Without it, patterns must be re-taught each session.

**Independent Test**: Complete a task, verify instinct created, restart session, verify instinct loaded.

**Acceptance Scenarios**:

1. **Given** developer fixes bug with specific pattern, **When** task completes, **Then** instinct created with confidence score
2. **Given** instinct reaches confidence 5, **When** new session starts, **Then** instinct auto-injected
3. **Given** developer runs `/instinct-status`, **When** command executes, **Then** all instincts displayed with scores

---

### User Story 3 - Agent Orchestration (Priority: P1)

**Thai**: นักพัฒนาขอทำงานซับซ้อน ระบบประสาน agents หลายตัวตาม 5-phase workflow

**English**: Developer requests complex work. System coordinates multiple agents via 5-phase workflow.

**Why this priority**: Complex tasks require coordination. Without orchestration, agents work sequentially or conflict.

**Independent Test**: Submit complex task, verify 5 phases execute, verify output consolidated.

**Acceptance Scenarios**:

1. **Given** developer runs `/agents "add authentication"`, **When** task analyzed, **Then** complexity scored (0-1)
2. **Given** complexity >= 0.6, **When** workflow starts, **Then** 5 phases execute: Discovery → Development → Review → QA → Final
3. **Given** phase fails, **When** retry limit not reached, **Then** phase retried with feedback

---

### User Story 4 - Rules System (Priority: P2)

**Thai**: นักพัฒนาเปิดโปรเจกต์ใหม่ ระบบโหลดกฎภาษาที่เหมาะสมอัตโนมัติ

**English**: Developer opens new project. System loads language-appropriate rules automatically.

**Why this priority**: Rules ensure consistency. Different languages have different best practices.

**Independent Test**: Create Python project, verify Python rules load. Create TypeScript project, verify TS rules load.

**Acceptance Scenarios**:

1. **Given** project contains `package.json`, **When** session starts, **Then** TypeScript rules loaded
2. **Given** project contains `requirements.txt`, **When** session starts, **Then** Python rules loaded
3. **Given** project contains both, **When** session starts, **Then** both rule sets loaded

---

### User Story 5 - Skill Factory (Priority: P2)

**Thai**: นักพัฒนารัน `/skill-create` ระบบวิเคราะห์ git history และสร้าง skill

**English**: Developer runs `/skill-create`. System analyzes git history and creates skill from repeated patterns.

**Why this priority**: Automation saves developer time and captures institutional knowledge.

**Independent Test**: Make 5 similar commits, run skill-create, verify skill.md generated.

**Acceptance Scenarios**:

1. **Given** git history has 5+ similar commits, **When** `/skill-create` runs, **Then** skill.md generated
2. **Given** skill generated, **When** skill invoked, **Then** it guides developer through workflow
3. **Given** pattern quality low, **When** analysis completes, **Then** feedback provided

---

### User Story 6 - Cross-Project Learning (Priority: P2)

**Thai**: นักพัฒนาทำงานหลายโปรเจกต์ รูปแบบที่เรียนรู้แชร์ข้ามโปรเจกต์อัตโนมัติ

**English**: Developer works on multiple projects. Learned patterns shared across projects automatically.

**Why this priority**: Cross-project learning multiplies value. A pattern learned once benefits all future work.

**Independent Test**: Learn pattern in project A, verify pattern appears in project B.

**Acceptance Scenarios**:

1. **Given** pattern in 2+ projects with 5+ total occurrences, **When** threshold reached, **Then** promoted to global
2. **Given** global pattern exists, **When** new project starts, **Then** pattern loaded
3. **Given** developer runs `/instinct-export`, **When** export completes, **Then** JSON file created

---

### User Story 7 - Bilingual Support (Priority: P3)

**Thai**: นักพัฒนาใช้ภาษาไทยหรืออังกฤษ ระบบตอบภาษาเดียวกัน

**English**: Developer uses Thai or English. System responds in the same language.

**Why this priority**: Bilingual support improves UX for Thai developers.

**Independent Test**: Send Thai message, verify Thai response. Send English message, verify English response.

**Acceptance Scenarios**:

1. **Given** user types in Thai, **When** system responds, **Then** response is in Thai
2. **Given** user types in English, **When** system responds, **Then** response is in English
3. **Given** mixed input, **When** system detects dominant language, **Then** response matches

---

### Edge Cases

- Secret pattern not recognized → System defaults to generic pattern, flags for manual review
- Instinct storage corrupted → Validation on load, corrupt entries skipped with warning, backup attempted
- All agents in phase fail → Escalate after 3x failure with options: reassign, decompose, defer
- Git history empty → Skill factory provides feedback on insufficient history, suggests building history
- Language detection ambiguous → System prompts user to select, remembers choice for project
- Hook conflicts → Priority system determines which runs, user notified of conflicts
- Context window exhausted → System suggests compaction at breakpoints, state preserved
- MCP server unavailable → System degrades gracefully, suggests alternatives
- Adaptive hook loading fails → Falls back to standard hook set, error logged
- Project DNA outdated → System detects changes, suggests `/registry`
- Cross-project query fails → Retry with backoff, fallback to local-only patterns
- Agent memory exceeds limits → Oldest memories pruned by relevance, important ones summarized
- Developer wants to override security → Requires explicit confirmation, logged for audit

## Requirements *(mandatory)*

### Functional Requirements

#### Security Layer

- **FR-001**: System MUST detect and filter secrets in outputs (API keys, tokens, passwords)
- **FR-002**: System MUST block destructive SQL commands (DROP, TRUNCATE, DELETE without WHERE)
- **FR-003**: System MUST block remote command execution patterns (curl|bash, wget|sh)
- **FR-004**: System MUST trigger automatic security review when code changes introduce vulnerabilities
- **FR-005**: System MUST rate-limit MCP server calls to prevent abuse
- **FR-006**: System MUST log all security events for audit purposes
- **FR-033**: System MUST provide `/security-override` command for per-session security hook bypass (requires explicit confirmation, logged for audit)

#### Learning System

- **FR-007**: System MUST extract patterns as "instincts" with confidence scores (0-1), stored as JSON files in `~/.claude/instincts/`
- **FR-008**: System MUST promote instincts to auto-injection when confidence >= 5 occurrences
- **FR-009**: System MUST support cross-project learning (2+ projects, 5+ total occurrences)
- **FR-010**: System MUST implement cross-training where all agents learn from any agent's error
- **FR-011**: System MUST provide /instinct-status, /instinct-export, /instinct-import, /evolve commands
- **FR-012**: System MUST promote high-frequency patterns (10x repeat) to permanent rules

#### Agent Orchestration

- **FR-013**: System MUST route tasks via keyword matching (33 routing rules)
- **FR-014**: System MUST score task complexity (0-1) using hybrid algorithm (keyword matching + AST analysis) and select appropriate workflow
- **FR-015**: System MUST support 5-phase swarm: Discovery → Development → Review → QA → Final
- **FR-016**: System MUST implement Dev-QA retry loop with max 3 retries before escalation
- **FR-017**: System MUST maintain ~20 specialized agents:
  - Core (3): thinker, builder, reviewer
  - Security (2): security-reviewer, vulnerability-scanner
  - Language (4): typescript-reviewer, python-reviewer, go-reviewer, java-reviewer
  - Testing (3): tdd-guide, e2e-runner, qa-engineer
  - DevOps (2): devops, database-reviewer
  - Learning (2): self-learner, pattern-extractor
  - Orchestration (2): swarm-coordinator, sentinel
  - Documentation (2): doc-updater, technical-writer

#### Rules System

- **FR-018**: System MUST organize rules into common/ and language-specific directories
- **FR-019**: System MUST auto-detect project languages and load appropriate rule sets
- **FR-020**: System MUST support TypeScript, Python, Go, and extensible language rules
- **FR-021**: System MUST apply rules automatically without explicit user request

#### Skill Factory

- **FR-022**: System MUST analyze git history to identify repeated patterns
- **FR-023**: System MUST generate SKILL.md files with proper YAML frontmatter
- **FR-024**: System MUST support skill generation with simultaneous instinct creation
- **FR-025**: System MUST allow incremental skill updates as patterns evolve

#### Context Persistence

- **FR-026**: System MUST save session snapshots before context compaction
- **FR-027**: System MUST restore previous session state on new session start
- **FR-028**: System MUST maintain isolated context per project
- **FR-029**: System MUST persist agent memory across sessions

#### Adaptive Behavior

- **FR-030**: System MUST load hooks adaptively based on detected intent with <200ms total latency budget
- **FR-031**: System MUST support Thai and English input/output
- **FR-032**: System MUST maintain existing features: intent routing, project DNA, registry system
- **FR-034**: System MUST prune agent memory after 30 days with auto-cleanup, keeping most relevant entries

### Key Entities

- **Instinct**: Learned pattern with confidence score (0-1), project tags, evidence, examples. Promoted to rule at high confidence.
- **Agent Memory**: Per-agent persistent storage of learnings from completed tasks.
- **Project DNA**: Fingerprint of project stack, patterns, conventions stored in dna.json.
- **Registry**: Catalog of MCP servers, plugins, and their classifications.
- **Snapshot**: Saved session state including active task, files modified, and context.
- **Skill**: Reusable workflow definition with triggers, steps, and expected outcomes.
- **Routing Rule**: Keyword-to-agent mapping for automatic task delegation.
- **Security Event**: Log entry of security-relevant actions (blocked commands, filtered secrets).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 90% fewer security incidents (leaked secrets, dangerous commands) vs baseline without hooks
- **SC-002**: Repeated patterns learned and applied within 5 occurrences across sessions
- **SC-003**: 85% task routing accuracy — tasks reach correct specialist without manual intervention
- **SC-004**: Complex features (score >= 0.6) complete with <10% requiring human intervention
- **SC-005**: Context recovery after session restart completes in <10 seconds with 95% accuracy
- **SC-006**: 100% of known dangerous patterns blocked (SQL injection, XSS, secrets in output)
- **SC-007**: Developers working in Thai receive understandable responses 100% of the time
- **SC-008**: 70% of repeated patterns produce usable skills via skill factory
- **SC-009**: Dev-QA retry loop resolves 80% of failed verifications within 3 attempts
- **SC-010**: Agent cross-training reduces repeated errors by 50% across sessions
- **SC-011**: Hook execution latency <200ms for 95% of operations (skip gracefully if budget exceeded)
- **SC-012**: Agent memory storage stays under 10MB with 30-day retention policy

## Assumptions

- Users have Claude Code CLI v2.1.0+ installed
- Users have `jq` and `python3` available in PATH
- Git repository exists for skill factory functionality
- MCP servers (serena, memory, context7, filesystem, fetch) are available
- Users accept that learning requires multiple sessions to become effective
- Bilingual support focuses on Thai/English; other languages not in scope for v4.0

## Out of Scope

- Cross-platform support (Cursor, Codex, OpenCode) — Claude Code only
- More than 25 agents — keeping focused set
- Cloud sync/remote storage — all data stays local
- IDE integrations beyond Claude Code
- Real-time collaboration features
- 200+ skills — focused set only

## Dependencies

- MCP servers: serena, memory, context7, filesystem, fetch
- Tools: jq, python3 in PATH
- Git repository
- Claude Code CLI v2.1.0+

## Timeline & Phasing

### Phase 1: Security Foundation (Week 1-2)
- Security hooks implementation (6-layer)
- Rules directory setup (common/ + language/)
- Basic agent expansion (security-reviewer, vulnerability-scanner)

### Phase 2: Learning System (Week 3-4)
- Instinct extraction and storage
- Agent memory implementation
- Learning commands (/instinct-status, /instinct-export, /instinct-import, /evolve)

### Phase 3: Advanced Features (Week 5-6)
- Skill factory from git history
- Cross-project learning
- 5-phase swarm orchestration

### Phase 4: Polish & Testing (Week 7-8)
- Integration testing
- Performance optimization
- Documentation
- Release preparation
