# dev-stacks

> Zero-friction AI development assistant for Claude Code. Intent routing, adaptive workflows, agent teams, pattern learning, and safety guards.

A Claude Code plugin that provides intelligent development assistance with Thai/English language support, adaptive workflows, and a team of specialized agents.

## Features

- **Intent Router**: Understands natural language (Thai/English/mixed)
- **Adaptive Workflow**: Scales effort with task complexity
- **Agent Team**: Thinker, Builder, Tester working together
- **Pattern Memory**: Learns from successful work
- **Safety Guards**: Prevents system damage
- **Research Capability**: Searches for knowledge when needed

## Installation

```bash
# Add marketplace
claude /plugin marketplace add https://github.com/1827mk/dev-stacks

# Install plugin
claude /plugin install dev-stacks
```

## Commands

| Command | Description |
|---------|-------------|
| `/dev-stacks:status` | View system status |
| `/dev-stacks:undo` | Revert last changes |
| `/dev-stacks:learn` | Manage patterns |
| `/dev-stacks:doctor` | Diagnose and recover |
| `/dev-stacks:help` | Usage guide |

## Agents

| Agent | Purpose |
|-------|---------|
| `thinker` | Plan, analyze, research |
| `builder` | Implement, modify, fix |
| `tester` | Verify, validate, test |

## Workflows

| Workflow | Complexity | Team | Use Case |
|----------|------------|------|----------|
| **Quick** | 0.0-0.19 | Builder | Typos, simple fixes |
| **Standard** | 0.2-0.39 | Thinker + Builder | New features |
| **Careful** | 0.4-0.59 | Full Team | Security changes |
| **Full** | 0.6-1.0 | Full Team + Confirm | Payment, auth |

## Hooks

- **scope-guard**: Blocks writes to protected files (.env, keys, credentials)
- **secret-scanner**: Detects hardcoded secrets in code
- **bash-guard**: Blocks dangerous shell commands (rm -rf, DROP)
- **audit-logger**: JSONL audit logging
- **checkpoint-save**: Session state persistence

## Manual Installation

```bash
# Clone and install
git clone https://github.com/1827mk/dev-stacks.git
cp -r dev-stacks ~/.claude/plugins/dev-stacks

# Run with plugin
claude --plugin-dir ~/.claude/plugins/dev-stacks
```

## Requirements

- Claude Code CLI 1.0.33+
- MCP Memory server (optional, for patterns)
- MCP Filesystem server (optional, for checkpoints)

## License

MIT
