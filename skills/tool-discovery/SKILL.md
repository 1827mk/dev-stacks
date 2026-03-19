---
name: tool-discovery
description: Scan MCP servers, plugins, skills. Auto-invoked on session start. Use /dev-stacks:tool-discovery to refresh.
---

# Tool Discovery

Catalog available tools in `.dev-stacks/registry.json`.

## Registry Structure

```json
{
  "version": "1.0.0",
  "last_scan": "2026-03-19T10:30:00Z",
  "mcp_servers": ["context7", "web_reader", "memory", "serena"],
  "plugins": ["superpowers", "dev-stacks", "hookify"],
  "skills": {
    "planning": ["brainstorming", "writing-plans"],
    "implementation": ["frontend-design", "claude-api"],
    "verification": ["code-review", "simplify"]
  },
  "tool_keywords": {
    "frontend-design": ["UI", "component", "page", "react"],
    "systematic-debugging": ["bug", "error", "fix"]
  }
}
```

## When It Runs

| Trigger | Action |
|---------|--------|
| SessionStart | Auto-scan (async) |
| `/dev-stacks:tool-discovery` | Manual refresh |

## Output

```
Tool Discovery
Registry: .dev-stacks/registry.json
Found:
  MCP Servers: [n]
  Plugins: [n]
  Skills: [n]
```

## Usage by Others

| Component | Usage |
|-----------|-------|
| Orchestrator | Match task keywords → recommend tools |
| Thinker | Check available skills for planning |

## Implementation
Scans: `.mcp.json` → MCP servers, `~/.claude/plugins/` → plugins, `skills/` → skills

## Troubleshooting
```bash
bash skills/tool-discovery/scan-tools.sh
```
