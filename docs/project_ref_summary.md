# Project Reference Summary

สรุป Features ของ Claude Code Plugins/Ecosystems ที่ใช้อ้างอิงสำหรับ dev-stacks

---

## 1. Claude Forge

> "oh-my-zsh for Claude Code" — 11 agents, 40 commands, 15 skills, 15 hooks, 9 rules

### ข้อมูลทั่วไป
- **Repository:** https://github.com/sangrokjung/claude-forge
- **Version:** 2.2.0
- **License:** MIT

### Components

| Category | Count | Highlights |
|:--------:|:-----:|:-----------|
| **Agents** | 11 | planner, architect, code-reviewer, security-reviewer, tdd-guide, database-reviewer + 5 more |
| **Commands** | 40 | `/commit-push-pr`, `/handoff-verify`, `/explore`, `/tdd`, `/plan`, `/orchestrate`, `/security-review` |
| **Skills** | 15 | build-system, security-pipeline, eval-harness, team-orchestrator, session-wrap |
| **Hooks** | 15 | Secret filtering, remote command guard, DB protection, security auto-trigger, rate limiting |
| **Rules** | 9 | coding-style, security, git-workflow, golden-principles, agents, interaction, verification |
| **MCP Servers** | 6 | context7, memory, exa, github, fetch, jina-reader |

### Key Features

#### 1. Development Workflows (End-to-End Pipelines)
```
/plan → /tdd → /code-review → /handoff-verify → /commit-push-pr → /sync
```

#### 2. Agent Router System
- Forced delegation system ที่ส่งงานไปยัง specialized agents
- 33 routing rules สำหรับ auto-delegation

#### 3. 6-Layer Security Hooks
| Hook | Protects Against |
|:-----|:-----------------|
| `output-secret-filter.sh` | Leaked API keys, tokens |
| `remote-command-guard.sh` | Unsafe remote commands |
| `db-guard.sh` | Destructive SQL |
| `security-auto-trigger.sh` | Vulnerabilities in code |
| `rate-limiter.sh` | MCP abuse |
| `mcp-usage-tracker.sh` | MCP usage monitoring |

#### 4. Agent Memory (Self-Evolution)
- Core agents บันทึก learnings ใน `~/.claude/agent-memory/` หลังแต่ละ task

#### 5. Team Orchestration
- Hub-and-spoke coordination
- Parallel multi-agent execution

---

## 2. Everything Claude Code (ECC)

> "The performance optimization system for AI agent harnesses" — 28 agents, 116 skills, 59 commands

### ข้อมูลทั่วไป
- **Repository:** https://github.com/affaan-m/everything-claude-code
- **Stars:** 50K+ | **Forks:** 6K+ | **Anthropic Hackathon Winner**
- **License:** MIT

### Components

| Category | Count | Highlights |
|:--------:|:-----:|:-----------|
| **Agents** | 28 | planner, architect, tdd-guide, code-reviewer, security-reviewer, go-reviewer, python-reviewer, typescript-reviewer, java-reviewer, rust-reviewer |
| **Skills** | 116 | tdd-workflow, security-review, frontend-patterns, backend-patterns, golang-patterns, django-patterns, springboot-patterns, laravel-patterns |
| **Commands** | 59 | /tdd, /plan, /e2e, /code-review, /build-fix, /learn, /skill-create, /instinct-status |
| **Hooks** | 20+ | memory-persistence, strategic-compact, session-start/end |
| **Rules** | 34 | common + language-specific (TypeScript, Python, Go, Swift, PHP, Java, Rust, C++, Perl) |

### Key Features

#### 1. Cross-Platform Support
- Claude Code, Cursor IDE, Codex CLI, OpenCode
- Windows, macOS, Linux

#### 2. Multi-Language Rules Architecture
```
rules/
  common/          # Universal principles
  typescript/      # TS/JS specific
  python/          # Python specific
  golang/          # Go specific
  swift/           # Swift specific
  php/             # PHP specific
```

#### 3. Continuous Learning v2 (Instinct-Based)
```bash
/instinct-status        # Show learned instincts
/instinct-import <file> # Import instincts
/instinct-export        # Export for sharing
/evolve                 # Cluster into skills
```

#### 4. AgentShield Security Scanner
```bash
npx ecc-agentshield scan          # Quick scan
npx ecc-agentshield scan --opus   # Deep analysis with 3 Opus agents
npx ecc-agentshield init          # Generate secure config
```

#### 5. Skill Creator
- `/skill-create` — Local analysis from git history
- GitHub App — 10k+ commits, auto-PRs, team sharing

#### 6. Token Optimization
```json
{
  "model": "sonnet",
  "env": {
    "MAX_THINKING_TOKENS": "10000",
    "CLAUDE_AUTOCOMPACT_PCT_OVERRIDE": "50"
  }
}
```

---

## 3. vibecosystem

> "Your AI software team. Built on Claude Code." — 119 agents, 202 skills, 48 hooks

### ข้อมูลทั่วไป
- **Repository:** https://github.com/vibeeval/vibecosystem
- **License:** MIT

### Components

| Category | Count | Highlights |
|:--------:|:-----:|:-----------|
| **Agents** | 119 | Core Dev (12), Review & QA (8), Domain Experts (35), Architecture (8), Testing (6), DevOps (12), Analysis (10), Orchestration (16), Documentation (5), Learning (7) |
| **Skills** | 202 | TDD workflows, Kubernetes patterns, security, framework-specific |
| **Hooks** | 48 | TypeScript sensors — observe, filter, inject context |
| **Rules** | 17 | Behavioral guidelines |

### Key Features

#### 1. Agent Swarm (5-Phase Execution)
```
Phase 1 (Discovery):    scout + architect + project-manager
Phase 2 (Development):  backend-dev + frontend-dev + devops + specialists
Phase 3 (Review):       code-reviewer + security-reviewer + qa-engineer
Phase 4 (QA Loop):      verifier + tdd-guide (max 3 retry → escalate)
Phase 5 (Final):        self-learner + technical-writer
```

#### 2. Self-Learning Pipeline
```
Error happens → passive-learner captures pattern (+ project tag)
→ consolidator groups & counts (per-project + global)
→ confidence >= 5 → auto-inject into context
→ 2+ projects, 5+ total → cross-project promotion
→ 10x repeat → permanent .md rule file
```

#### 3. Cross-Project Learning
- Patterns จาก project หนึ่ง benefit ทุก projects อัตโนมัติ
- CLI สำหรับดู patterns:
```bash
node ~/.claude/hooks/dist/instinct-cli.mjs portfolio
node ~/.claude/hooks/dist/instinct-cli.mjs global
node ~/.claude/hooks/dist/instinct-cli.mjs project <name>
```

#### 4. Canavar Cross-Training
- เมื่อ agent ทำผิด → ทั้งทีมเรียนรู้
```
Agent error → error-ledger.jsonl → skill-matrix.json
→ All agents get the lesson at session start
```

#### 5. Adaptive Hook Loading
- 48 hooks แต่ไม่ได้ run พร้อมกัน
- Intent determines which hooks fire

#### 6. Dev-QA Loop
```
Developer implements → code-reviewer + verifier check
→ PASS → next task
→ FAIL → feedback, retry (max 3)
→ 3x FAIL → escalate
```

---

## Comparison Matrix

| Feature | Claude Forge | ECC | vibecosystem |
|---------|:------------:|:---:|:------------:|
| **Agents** | 11 | 28 | 119 |
| **Skills** | 15 | 116 | 202 |
| **Commands** | 40 | 59 | N/A |
| **Hooks** | 15 (shell) | 20+ (Node.js) | 48 (TypeScript) |
| **Rules** | 9 | 34 | 17 |
| **Self-Learning** | Agent memory | Instincts v2 | Full pipeline + cross-project |
| **Cross-Platform** | CC only | CC, Cursor, Codex, OpenCode | CC only |
| **Multi-Language** | Limited | 10+ languages | Limited |
| **Security** | 6-layer hooks | AgentShield scanner | Built-in |
| **Orchestration** | Hub-and-spoke | Multi-agent | Agent swarm (5-phase) |

---

## Key Takeaways for dev-stacks

### จาก Claude Forge
1. **End-to-end workflows** — pipeline ที่เชื่อม plan → tdd → review → verify → commit
2. **Agent Router** — forced delegation system
3. **Security hooks** — 6-layer defense
4. **Symlink architecture** — ติดตั้งครั้งเดียว อัปเดตง่าย

### จาก Everything Claude Code
1. **Multi-language rules** — แยก common + language-specific
2. **Cross-platform** — รองรับหลาย harness (CC, Cursor, Codex, OpenCode)
3. **Continuous Learning v2** — instinct-based with confidence scoring
4. **AgentShield** — security scanner
5. **Skill Creator** — สร้าง skill จาก git history

### จาก vibecosystem
1. **Agent Swarm** — 5-phase parallel execution
2. **Self-Learning Pipeline** — errors → rules อัตโนมัติ
3. **Cross-Project Learning** — patterns แชร์ข้าม projects
4. **Canavar Cross-Training** — ทีมเรียนรู้จากความผิดพลาดของแต่ละคน
5. **Adaptive Hook Loading** — load เฉพาะ hooks ที่จำเป็น
6. **Dev-QA Loop** — auto-retry with escalation

---

## Recommended Features for dev-stacks v3.x

### Priority 1: Core
- [ ] Agent Router with forced delegation
- [ ] Multi-phase workflow orchestration
- [ ] Self-learning pipeline (instincts)
- [ ] Security hooks (secrets, SQL, remote commands)

### Priority 2: Enhancement
- [ ] Cross-project pattern sharing
- [ ] Adaptive hook loading
- [ ] Dev-QA retry loop
- [ ] Multi-language rules architecture

### Priority 3: Advanced
- [ ] Agent swarm coordination
- [ ] Cross-training from errors
- [ ] Skill factory from git history
- [ ] Security scanner integration

---

## dev-stacks Feature Comparison

### Current dev-stacks (v3.0.0)

| Category | Count | Components |
|:--------:|:-----:|:-----------|
| **Agents** | 3 | thinker, builder, reviewer |
| **Skills** | 9 | analyze, design, implement, test-write, security, orchestrator, dna-builder, checkpoint, registry-builder |
| **Commands** | 5 | /agents, /plan, /tasks, /status, /registry |
| **Hooks** | 6 | SessionStart, SubagentStart, UserPromptSubmit, PreCompact, Stop, SubagentStop |
| **MCP Servers** | 5 | serena, memory, context7, filesystem, fetch |

### Feature Comparison Matrix

| Feature | dev-stacks | Claude Forge | ECC | vibecosystem |
|---------|:----------:|:------------:|:---:|:------------:|
| **Agents** | 3 | 11 | 28 | 119 |
| **Skills** | 9 | 15 | 116 | 202 |
| **Commands** | 5 | 40 | 59 | N/A |
| **Hooks** | 6 | 15 | 20+ | 48 |
| **Rules** | 0 | 9 | 34 | 17 |
| **MCP Servers** | 5 | 6 | 14 | Built-in |

### Capability Comparison

| Capability | dev-stacks | Claude Forge | ECC | vibecosystem |
|------------|:----------:|:------------:|:---:|:------------:|
| **Intent Routing** | ✅ complexity-based | ❌ | ❌ | ❌ |
| **Adaptive Workflows** | ✅ 4 levels | ❌ | ❌ | ✅ 5-phase |
| **Agent Delegation** | ✅ thinker→builder→reviewer | ✅ router system | ✅ | ✅ swarm |
| **Context Persistence** | ✅ snapshot.md | ❌ | ✅ memory | ✅ |
| **Project DNA** | ✅ dna.json | ❌ | ❌ | ❌ |
| **Self-Learning** | ❌ | ✅ agent memory | ✅ instincts v2 | ✅ full pipeline |
| **Cross-Project Learning** | ❌ | ❌ | ❌ | ✅ |
| **Security Hooks** | ❌ | ✅ 6-layer | ✅ AgentShield | ✅ |
| **Secret Detection** | ❌ | ✅ | ✅ | ✅ |
| **Multi-Language Rules** | ❌ | ❌ | ✅ 10+ | ❌ |
| **Cross-Platform** | ❌ CC only | ❌ CC only | ✅ 4 harnesses | ❌ CC only |
| **Completion Gate** | ✅ Stop hook | ❌ | ❌ | ✅ Dev-QA loop |
| **Subagent Gate** | ✅ output header | ❌ | ❌ | ❌ |
| **Registry System** | ✅ MCP + DNA | ❌ | ❌ | ❌ |

### dev-stacks Unique Features

| Feature | Description |
|---------|-------------|
| **Intent Routing** | Automatic complexity scoring → workflow selection (quick/standard/careful/full) |
| **Project DNA** | `dna.json` stores project fingerprint (stack, patterns, conventions) |
| **Registry System** | Auto-discover and classify MCP servers |
| **Adaptive Workflows** | 4 levels based on complexity: quick (<0.2), standard (0.2-0.4), careful (0.4-0.6), full (≥0.6) |
| **Thai/English** | Bilingual support |

### Gap Analysis — Features Missing in dev-stacks

#### Priority 1: Critical (Should Have)

| Feature | Source | Impact |
|---------|--------|--------|
| **Security Hooks** | Claude Forge, ECC | Secret detection, SQL guard, remote command filter |
| **Self-Learning** | All 3 | Auto-extract patterns from sessions |
| **Rules System** | All 3 | Coding style, security guidelines, testing requirements |

#### Priority 2: Important (Nice to Have)

| Feature | Source | Impact |
|---------|--------|--------|
| **More Specialized Agents** | ECC, vibecosystem | Language-specific reviewers, security auditor |
| **Multi-Language Rules** | ECC | TypeScript, Python, Go, etc. |
| **Cross-Project Learning** | vibecosystem | Share patterns across projects |
| **Skill Factory** | ECC | Generate skills from git history |

#### Priority 3: Enhancement

| Feature | Source | Impact |
|---------|--------|--------|
| **Agent Swarm** | vibecosystem | 5-phase parallel execution |
| **Cross-Platform** | ECC | Cursor, Codex, OpenCode support |
| **AgentShield Scanner** | ECC | Security vulnerability scanner |

### Recommended Roadmap for dev-stacks v3.x

#### v3.1 — Security Foundation
- [ ] Add `output-secret-filter` hook (detect API keys, tokens)
- [ ] Add `db-guard` hook (block destructive SQL)
- [ ] Add `remote-command-guard` hook (block curl|bash patterns)
- [ ] Create `rules/` directory with common coding standards

#### v3.2 — Learning System
- [ ] Implement instinct-based learning (like ECC)
- [ ] Create `/learn` command for pattern extraction
- [ ] Add `/instinct-status`, `/instinct-export`, `/instinct-import`

#### v3.3 — Agent Expansion
- [ ] Add `security-reviewer` agent
- [ ] Add language-specific reviewers (typescript, python, go)
- [ ] Create specialized skill library

#### v3.4 — Advanced Features
- [ ] Cross-project pattern sharing
- [ ] Skill factory from git history
- [ ] Agent swarm orchestration

---

*Generated: 2026-03-22*
*Updated: 2026-03-22 — Added dev-stacks comparison*
