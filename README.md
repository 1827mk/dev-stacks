# dev-stacks v4

**Living engineering team for Claude Code.**

6 specialized agents that scout, plan, build, verify, secure, and learn — automatically. Every session builds on the last.

---

## Install

```bash
/plugin marketplace add 1827mk/dev-stacks
/plugin install dev-stacks@dev-stacks-marketplace
/reload-plugins
```

**Requirements:** `python3` in PATH

---

## First time setup

```
/dev-stacks:registry
```

Scans your codebase → builds DNA → ready.

---

## Daily usage

### Just describe what you want

```
/dev-stacks เพิ่ม rate limiting ให้ API
/dev-stacks แก้ bug ที่ payment fail สำหรับ user ต่างประเทศ
/dev-stacks อธิบายว่า auth flow ทำงานยังไง
```

### Full workflow (plan first, then execute)

```
/dev-stacks:think เพิ่ม JWT refresh token
/dev-stacks:do
```

### Run quality + security check

```
/dev-stacks:check
```

### Capture what was learned this session

```
/dev-stacks:learn
```

### View memory

```
/dev-stacks:memory
```

---

## The 6 Agents

| Agent | Role | Phase |
|-------|------|-------|
| **scout** | Reads + maps codebase — never writes | 1 |
| **architect** | Designs plan with sequential thinking + context7 | 1 |
| **builder** | Implements — read-first, scope-guarded | 2 |
| **verifier** | Runs tests — reflection loop up to 3 cycles | 3 |
| **sentinel** | Security review — OWASP, never writes code | 3 |
| **chronicler** | Writes learnings to memory — always asks first | 4 |

---

## 5-Phase Workflow

```
Phase 1: DISCOVER    scout → architect
Phase 2: BUILD       builder
Phase 3: VERIFY      verifier + sentinel (parallel in full mode)
Phase 4: FRESH CHECK handoff-verify (clean context, no bias)
Phase 5: LEARN       chronicler (with user confirmation)
```

Workflow selected automatically by complexity:
- **quick** (< 0.2): Claude handles directly
- **standard** (0.2–0.4): phases 1–2
- **careful** (0.4–0.6): phases 1–3
- **full** (≥ 0.6): all 5 phases

---

## Self-Learning Memory

Every session builds on the last:

```
Error happens
  → pattern-capture hook logs it
  → chronicler counts occurrences
  → ≥ 5x → asks user: inject as instinct?
  → ≥ 10x in 2+ projects → asks user: global rule?
  → session-start injects approved patterns automatically
```

**User always confirms before any pattern is promoted.**

Memory is stored in:
- **MCP Memory** — cross-project knowledge graph
- **Serena Memory** — per-project decisions and DNA

---

## Security Guards (always active)

| Guard | Triggers on |
|-------|-------------|
| db-guard | DROP/TRUNCATE/DELETE without WHERE |
| remote-guard | curl\|bash, wget\|bash |
| secret-filter | API keys, JWT, passwords in output |

---

## Core Principles

1. **Ask before acting** — never decide alone on ambiguous or irreversible actions
2. **Read before write** — builder always reads the file before editing
3. **Confirm before learning** — chronicler never promotes patterns without user yes
4. **Ask before searching** — always request permission before web search
5. **Escalate don't guess** — 3 failed cycles → show options, let user decide

---

## File structure after init

```
.dev-stacks/
├── dna.json           ← project fingerprint
├── state.json         ← current task state
├── snapshot.md        ← active task (survives compaction)
├── plan.md            ← architect plan
├── error-ledger.jsonl ← captured patterns for learning
├── change-log.jsonl   ← file change history
└── rules/             ← promoted global rules
```

---

## MCP Servers used

| Server | Purpose |
|--------|---------|
| serena | Code intelligence, symbol search, per-project memory |
| memory | Cross-project knowledge graph |
| context7 | Current library API docs |
| sequentialthinking | Structured reasoning for architect |
| filesystem | File operations |
