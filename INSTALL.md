# Installation Guide

## Marketplace Installation (Recommended)

```bash
# Step 1: Add marketplace
claude /plugin marketplace add https://github.com/1827mk/dev-stacks

# Step 2: Install plugin
claude /plugin install dev-stacks
```

## Manual Installation

```bash
# Clone repository
git clone https://github.com/1827mk/dev-stacks.git

# Install globally
cp -r dev-stacks ~/.claude/plugins/dev-stacks

# Or install per-project
cp -r dev-stacks .claude/plugins/dev-stacks
```

## Development Mode

```bash
# Clone and test locally
git clone https://github.com/1827mk/dev-stacks.git
cd dev-stacks

# Test with Claude Code
claude --plugin-dir .
```

Use `/reload-plugins` to reload changes during development.

## Requirements

| Requirement | Version | Purpose |
|-------------|---------|---------|
| Claude Code CLI | >=1.0.33 | Plugin support |
| MCP Memory Server | any | Pattern storage (optional) |
| MCP Filesystem Server | any | Checkpoint/DNA storage (optional) |

## Post-Installation

```bash
# Reload plugins
/reload-plugins

# Verify installation
/dev-stacks:status

# View help
/dev-stacks:help
```

## Updating

```bash
# Update from marketplace
claude /plugin update dev-stacks

# Or manual update
cd ~/.claude/plugins/dev-stacks
git pull origin main
/reload-plugins
```

## Uninstallation

```bash
# Remove plugin
rm -rf ~/.claude/plugins/dev-stacks
```

## Troubleshooting

### Plugin Not Loading

```bash
# Check plugin directory
ls ~/.claude/plugins/dev-stacks

# Verify plugin.json
cat ~/.claude/plugins/dev-stacks/.claude-plugin/plugin.json

# Reload plugins
/reload-plugins
```

### Run Diagnostics

```bash
/dev-stacks:doctor
```

---

**Next**: [README](./README.md)
