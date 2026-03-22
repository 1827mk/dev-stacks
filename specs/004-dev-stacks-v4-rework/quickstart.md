# Quickstart: dev-stacks v4.0

**Feature**: dev-stacks v4.0 Rework
**Date**: 2026-03-22

## Prerequisites

- Claude Code CLI v2.1.0+
- `jq` in PATH (for JSON processing)
- `python3` in PATH (for hooks)
- Git repository (for skill factory)

## Installation

```bash
# Clone repository
git clone <repo-url> dev-stacks
cd dev-stacks

# Install plugin (creates symlink to ~/.claude/plugins/)
./install.sh
```

## First Run

### 1. Initialize Project

```bash
# Start Claude Code in your project
cd /path/to/your/project
claude

# Initialize dev-stacks for this project
/registry
```

This creates:
- `.dev-stacks/dna.json` - Project fingerprint
- `.dev-stacks/registry.json` - MCP/plugin catalog
- `.dev-stacks/instincts/` - Per-project instincts

### 2. Verify Installation

```
/status
```

Output:
```
dev-stacks v4.0
Project: my-project
Languages: TypeScript, Python
Agents: 20 | Skills: 50 | Commands: 40 | Hooks: 15
Instincts: 0 (local), 5 (global)
```

---

## Core Workflows

### Security Layer (P1)

**Auto-Protection**: Security hooks run automatically on every operation.

```
# This will be blocked automatically:
$ DROP TABLE users;

⚠️ Blocked: Destructive SQL command detected
Command: DROP TABLE users;
Action: Blocked (requires /security-override)
```

**Manual Security Review**:

```
/security-review src/auth/
```

**Override Security** (per-session, logged):

```
/security-override 30  # Override for 30 minutes
```

---

### Learning System (P1)

**Pattern Extraction** (automatic):

```
# Just work normally - patterns are extracted automatically
/agents "implement user authentication"
```

**View Instincts**:

```
/instinct-status
```

Output:
```
Local Instincts (project: my-project):
  1. Use async/await (confidence: 0.7, occurrences: 7)
  2. Validate inputs (confidence: 0.5, occurrences: 5)

Global Instincts:
  1. Always write tests first (confidence: 0.9, occurrences: 15)
  2. Use dependency injection (confidence: 0.6, occurrences: 6)
```

**Export/Import**:

```
/instinct-export
# Creates ~/.claude/instincts-export-2026-03-22.json

/instinct-import instincts-export.json
```

**Evolve to Skills**:

```
/evolve
# Clusters instincts into reusable skills
```

---

### Agent Orchestration (P1)

**Quick Task** (< 0.2 complexity):

```
/agents "fix typo in README"
# Single agent, direct execution
```

**Standard Task** (0.2-0.4 complexity):

```
/agents "add login button"
# thinker → builder
```

**Careful Task** (0.4-0.6 complexity):

```
/agents "refactor authentication module"
# thinker → builder → reviewer
```

**Complex Task** (>= 0.6 complexity):

```
/agents "implement OAuth2 with refresh tokens"
# 5-phase swarm:
# Phase 1: Discovery (scout, architect)
# Phase 2: Development (backend, frontend, devops)
# Phase 3: Review (code, security, qa)
# Phase 4: QA Loop (verifier, tdd-guide)
# Phase 5: Final (self-learner, technical-writer)
```

---

### Rules System (P2)

**Auto-Loading** (automatic based on project):

```
# Project with package.json → TypeScript rules loaded
# Project with requirements.txt → Python rules loaded
# Project with both → Both loaded
```

**View Active Rules**:

```
/status rules
```

---

### Skill Factory (P2)

**Create Skill from Git History**:

```
/skill-create
```

Output:
```
Analyzing last 100 commits...
Found 5 patterns with 5+ occurrences:
  1. Fix authentication bugs (7 occurrences)
  2. Add API endpoints (6 occurrences)
  3. Update dependencies (5 occurrences)

Generated skills:
  - skills/factory/fix-auth-bug/SKILL.md
  - skills/factory/add-api-endpoint/SKILL.md
  - skills/factory/update-dependencies/SKILL.md
```

**Use Generated Skill**:

```
/fix-auth-bug "login fails with special characters"
```

---

### Cross-Project Learning (P2)

Patterns learned in one project automatically benefit others:

```
# Project A: Learn pattern
/agents "implement rate limiting"
# Pattern extracted → stored in project A instincts

# After 2+ projects, 5+ occurrences → promoted to global

# Project B: Pattern available automatically
/agents "add rate limiting"
# Global instinct loaded → applies learned pattern
```

---

### Bilingual Support (P3)

**Thai Input**:

```
ช่วยสร้าง API สำหรับ login หน่อย
```

**Thai Output**:

```
รับทราบครับ ผมจะสร้าง API สำหรับการ login

ขั้นตอนที่ 1: สร้าง endpoint /api/auth/login
ขั้นตอนที่ 2: เพิ่ม validation สำหรับ request body
...
```

---

## Common Commands

| Command | Description |
|---------|-------------|
| `/agents <task>` | Orchestrate task with appropriate workflow |
| `/status` | Show current session state |
| `/registry` | Rebuild project DNA and registry |
| `/security-review <path>` | Manual security review |
| `/security-override <min>` | Temporarily override security (logged) |
| `/instinct-status` | Show all learned instincts |
| `/instinct-export` | Export instincts to JSON |
| `/instinct-import <file>` | Import instincts from JSON |
| `/evolve` | Cluster instincts into skills |
| `/skill-create` | Generate skill from git history |

---

## File Structure

```
your-project/
├── .dev-stacks/
│   ├── dna.json           # Project fingerprint
│   ├── registry.json      # MCP/plugin catalog
│   ├── snapshot.md        # Session state
│   └── instincts/         # Per-project instincts
│       └── *.json

~/.claude/
├── instincts/             # Global (cross-project) instincts
│   └── *.json
├── agent-memory/          # Agent learnings
│   ├── thinker.json
│   ├── builder.json
│   └── ...
└── security-events.log    # Security audit log
```

---

## Troubleshooting

### Hooks Not Running

```bash
# Check jq is installed
which jq || echo "Install jq: brew install jq"

# Check python3 is available
which python3 || echo "Install python3"

# Check plugin is linked
ls -la ~/.claude/plugins/ | grep dev-stacks
```

### Instincts Not Loading

```bash
# Check instincts directory
ls -la ~/.claude/instincts/

# Check JSON validity
jq . ~/.claude/instincts/*.json
```

### Security Override Not Working

```bash
# Check override file
cat /tmp/dev-stacks-security-override-*

# Check security log
tail -f ~/.claude/security-events.log
```

---

## Next Steps

1. Run `/registry` to initialize your project
2. Try `/agents "implement a simple feature"` to test orchestration
3. Work on several tasks to build up instincts
4. Run `/instinct-status` to see learned patterns
5. Run `/skill-create` to generate reusable skills

---

*Quickstart complete. For detailed implementation, see [plan.md](./plan.md)*
