# Installation Guide

## Quick Start

### Option 1: Marketplace (Recommended)

```bash
claude /plugin marketplace add https://github.com/1827mk/dev-stacks
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

## Requirements

| Requirement | Purpose |
|-------------|---------|
| Claude Code CLI | Plugin support |
| `jq` | Hook script (intent classification) |

### Installing jq

```bash
# macOS
brew install jq

# Linux
sudo apt install jq  # Debian/Ubuntu
sudo dnf install jq  # Fedora

# Windows (with Chocolatey)
choco install jq
```

## Verify Installation

After installation, just type any prompt:

```
แก้ bug login ไม่ได้

You should see:
[DEV-STACKS] FIX_BUG | backend | complexity: 0.35
Workflow: standard | Invoke: /dev-stacks:run
```

## Available Skills

| Skill | Description |
|-------|-------------|
| `/dev-stacks:run` | Main orchestrator (auto-selects workflow) |
| `/dev-stacks:team` | Agent team for complex tasks |
| `/dev-stacks:research` | Research only |
| `/dev-stacks:implement` | Implementation only |
| `/dev-stacks:review` | Review only |

## Updating

```bash
# Marketplace
claude /plugin update dev-stacks

# Or manual
cd ~/.claude/plugins/dev-stacks
git pull origin main
```

## Uninstallation

```bash
# Marketplace
claude /plugin uninstall dev-stacks

# Or manual
rm -rf ~/.claude/plugins/dev-stacks
```

## Troubleshooting

### Hook Not Working

```bash
# Check jq is installed
which jq

# Check hook is executable
ls -la ~/.claude/plugins/dev-stacks/hooks/prompt-enhancer.sh

# Check registry exists
cat ~/.claude/plugins/dev-stacks/.dev-stacks/registry.json
```

### Skills Not Found

```bash
# Verify skill files exist
ls ~/.claude/plugins/dev-stacks/skills/*/SKILL.md

# Verify agent files exist
ls ~/.claude/plugins/dev-stacks/agents/*.md
```

---

**Next**: [README](./README.md) | [Spec](./spec/003-prompt-enhancer/spec.md)
