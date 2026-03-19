---
name: tool-discovery
description: Scan and discover available MCP servers, plugins, and skills.
             Auto-invoked on session start. Use manually with /dev-stacks:tool-discovery
             to refresh the tool registry.
---

# Tool Discovery Skill

Automatically discovers and catalogs all available tools in the Dev-Stacks ecosystem.

## Purpose

This skill maintains a registry of:
- MCP servers (context7, web_reader, memory, etc.)
- Installed plugins (superpowers, hookify, etc.)
- Available skills (planning, implementation, verification)

## When It Runs

1. **Automatically**: On session start via SessionStart hook
2. **Manually**: When user invokes `/dev-stacks:tool-discovery`

## How to Use

### Automatic
Just start a session - the registry is updated automatically.

### Manual Refresh
```
/dev-stacks:tool-discovery
```

Or via Skill tool:
```
Skill tool:
  skill: "dev-stacks:tool-discovery"
```

## Output

```
🔍 Scanning available tools...
✅ Registry updated: .dev-stacks/registry.json

📊 Discovered:
  MCP Servers: 8
  Plugins: 5
  Skills: 12
```

## Registry Location

```
.dev-stacks/registry.json
```

## Registry Structure

```json
{
  "version": "1.0.0",
  "last_scan": "2026-03-19T10:30:00Z",
  "mcp_servers": ["context7", "web_reader", "memory", "serena", ...],
  "plugins": ["superpowers", "dev-stacks", "hookify", ...],
  "skills": {
    "planning": ["brainstorming", "writing-plans"],
    "implementation": ["frontend-design", "claude-api"],
    "verification": ["code-review", "simplify"],
    "git": ["dev-commit", "using-git-worktrees"],
    "other": ["loop", "update-config"]
  },
  "tool_keywords": {
    "frontend-design": ["UI", "component", "page", "react"],
    "systematic-debugging": ["bug", "error", "fix", "debug"],
    ...
  }
}
```

## Usage by Other Components

### Orchestrator
Reads registry to recommend tools for tasks:
```
Read: .dev-stacks/registry.json
→ Match task keywords to tool_keywords
→ Recommend appropriate tools to agents
```

### Thinker Agent
Checks registry to know what tools are available:
```
Task: "Create a login page"
→ Registry shows: frontend-design available
→ Recommends: frontend-design skill
```

## Implementation

The scan is performed by `scan-tools.sh` which:
1. Scans `.mcp.json` for MCP servers
2. Scans `~/.claude/plugins/` for plugins
3. Scans `skills/` directory for skills
4. Categorizes skills by type
5. Builds keyword mappings for tool recommendation

## Troubleshooting

### Registry not updating
```bash
# Run manually
bash skills/tool-discovery/scan-tools.sh
```

### Missing tools in registry
Check that:
- `.mcp.json` exists and is valid JSON
- Plugin directory is accessible
- Skills have `SKILL.md` files
