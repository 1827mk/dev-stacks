# Dev-Stacks

> **Zero-friction AI development assistant** — Intent routing, adaptive workflows, agent teams, pattern learning, and safety guards. Thai/English support.

A Claude Code plugin that provides intelligent development assistance with Thai/English language support, adaptive workflows, and a team of specialized agents.

## Features

### 🧠 Intent Routing
Automatically detects what you want to do from natural language (Thai, English, or mixed):
- `แก้ typo ใน README` → FIX_BUG
- `Add email validation` → ADD_FEATURE
- `Why is API slow?` → INVESTIGATE

### ⚡ Adaptive Workflows
Four workflow levels based on task complexity:

| Workflow | Complexity | Agents | Use Case |
|----------|------------|--------|----------|
| **Quick** | 0.0-0.19 | Builder | Typos, simple fixes |
| **Standard** | 0.2-0.39 | Thinker + Builder | New features, moderate changes |
| **Careful** | 0.4-0.59 | Thinker + Builder + Tester | Complex features, security |
| **Full** | 0.6-1.0 | Full team + Confirmation | Payment, auth, database |

### 👥 Agent Team
Three specialized agents work together:
- **🧠 Thinker** (opus) — Plans, analyzes, researches
- **🛠️ Builder** (opus) — Implements, modifies, fixes
- **✅ Tester** (sonnet) — Verifies, validates, tests

### 📚 Pattern Learning
Learns from successful tasks and suggests patterns for similar future work.

### 🛡️ Safety Guards
- **Scope Guard** — Protects sensitive files (.env, .git, credentials)
- **Bash Guard** — Blocks dangerous commands (rm -rf /, DROP DATABASE)
- **Secret Scanner** — Detects hardcoded secrets

### 🔍 Research Capability
All agents can research when knowledge is insufficient:
- `context7` — Library documentation
- `web_reader` — Web content, tutorials
- `WebSearch` — General search, solutions

## Installation

### Option 1: Marketplace (Recommended)

```bash
# Add marketplace
claude /plugin marketplace add https://github.com/1827mk/dev-stacks

# Install plugin
claude /plugin install dev-stacks
```

### Option 2: Clone to Claude Plugins Directory

```bash
cd ~/.claude/plugins/
git clone https://github.com/1827mk/dev-stacks.git
```

### Option 3: Local Development

```bash
# Clone anywhere
git clone https://github.com/1827mk/dev-stacks.git

# Link to Claude plugins
ln -s $(pwd)/dev-stacks ~/.claude/plugins/dev-stacks
```

### Option 4: Per-Project

Copy the `.claude-plugin/` directory to your project root.

## Commands

| Command | Description |
|---------|-------------|
| `/dev-stacks:status` | View system status |
| `/dev-stacks:undo` | Undo changes (multiple levels) |
| `/dev-stacks:learn` | Manage pattern memory |
| `/dev-stacks:doctor` | Diagnose and recover |
| `/dev-stacks:report` | Generate reports |
| `/dev-stacks:help` | Display help |

## Usage

Just describe what you need in natural language:

```
แก้ typo ใน README ตรงคำว่า 'intallation'
→ Builder fixes immediately (Quick)

เพิ่ม email validation ในฟอร์ม login
→ Thinker plans → Builder implements (Standard)

ทำไม API /users ช้า?
→ Thinker investigates → Reports findings (Investigate)
```

## Project Structure

```
dev-stacks/
├── .claude-plugin/
│   ├── plugin.json          # Plugin manifest
│   └── marketplace.json     # Marketplace metadata
├── commands/                 # Slash commands
│   ├── doctor.md
│   ├── help.md
│   ├── learn.md
│   ├── report.md
│   ├── status.md
│   └── undo.md
├── agents/                   # Agent definitions
│   ├── builder.md
│   ├── thinker.md
│   └── tester.md
├── skills/                   # Agent skills
│   ├── core/                 # intent-router, complexity-scorer, team-selector
│   ├── workflows/            # quick, standard, careful, full
│   ├── guards/               # bash-guard, scope-guard, secret-scanner
│   ├── memory/               # pattern-manager
│   ├── dna/                  # dna-builder
│   ├── audit/                # audit-logger
│   ├── checkpoint/           # checkpoint-manager
│   └── report/               # report-engine
├── hooks/
│   ├── hooks.json           # Hook configuration
│   ├── session-start.sh     # SessionStart hook
│   ├── user-prompt-submit.sh # UserPromptSubmit hook
│   ├── scope-guard.sh       # PreToolUse file guard
│   ├── bash-guard.sh        # PreToolUse command guard
│   ├── post-tool-use.sh     # PostToolUse audit
│   ├── stop.sh              # Stop hook
│   └── pre-compact.sh       # PreCompact backup
└── config/
    ├── defaults.json        # Default settings
    ├── protected-paths.json # Protected file patterns
    └── dangerous-commands.json # Dangerous command patterns
```

## Data Storage

Dev-Stacks creates a `.dev-stacks/` directory in your project:

```
.dev-stacks/
├── dna.json           # Project DNA (architecture, patterns)
├── checkpoint.json    # Session checkpoint (for recovery)
├── logs/
│   ├── session-*.log  # Session logs
│   └── audit.jsonl    # Audit trail
└── backups/           # PreCompact backups
```

## Hooks

| Hook | Purpose |
|------|---------|
| **SessionStart** | Initialize environment, load DNA and patterns |
| **UserPromptSubmit** | Route intent, score complexity, select team |
| **PreToolUse** | Scope guard, bash guard, secret scanner |
| **PostToolUse** | Audit logging, pattern save offers |
| **Stop** | Completion check, session summary |
| **PreCompact** | Backup session state |

## Configuration

### defaults.json
Workflow thresholds, agent settings, guard configuration.

### protected-paths.json
File patterns protected from modification:
- CRITICAL: `.env*`, `*.pem`, `*.key`, `.git/`, `credentials*`
- HIGH: `package.json`, `migrations/`
- MEDIUM: `tsconfig.json`, `*.config.*`

### dangerous-commands.json
Bash commands blocked for safety:
- CRITICAL: `rm -rf /`, `mkfs`, `DROP DATABASE`
- HIGH: `TRUNCATE`, `DELETE FROM`
- MEDIUM: `chmod -R 777`, `sudo`

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `mcp__filesystem__*` | File operations |
| `mcp__memory__*` | Pattern storage |
| `mcp__context7__*` | Library docs |
| `mcp__web_reader__*` | Web content |
| `mcp__serena__*` | Code intelligence (optional) |

## Language Support

- Thai (ไทย) ✅
- English ✅
- Mixed (Thai + English) ✅

Dev-Stacks understands all three naturally.

## Requirements

- Claude Code CLI 1.0.33+
- MCP Memory server (optional, for patterns)
- MCP Filesystem server (optional, for checkpoints)

## Tips

1. **Be specific** — Mention file names, function names when possible
2. **Trust the agents** — They research when needed
3. **Use commands** — `/dev-stacks:status`, `/dev-stacks:undo` for control
4. **Learn patterns** — Save successful tasks as patterns
5. **Check logs** — `.dev-stacks/logs/` for debugging

## License

MIT

## Author

[1827mk](https://github.com/1827mk)
