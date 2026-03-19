# Dev-Stacks

> **Prompt Engineering Gateway for Claude Code** — Hooks, Skills, Subagents, Agent Teams. Thai/English support.

A Claude Code plugin that acts as a prompt engineering gateway, automatically analyzing user prompts and recommending workflows with appropriate tools and agents.

## Features

### 🎯 Automatic Intent Detection
Hook analyzes every prompt (Thai, English, or mixed):
- `แก้ bug login ไม่ได้` → FIX_BUG | backend | complexity: 0.35
- `Add email validation` → ADD_FEATURE | frontend | complexity: 0.25
- `Why is API slow?` → EXPLAIN | backend | complexity: 0.15

### ⚡ Workflow Selection
Four workflows based on complexity:

| Workflow | Complexity | Action | Use Case |
|----------|------------|--------|----------|
| **Quick** | < 0.2 | Direct implementation | Typos, simple fixes |
| **Standard** | 0.2-0.39 | thinker → builder | New features |
| **Careful** | 0.4-0.59 | thinker → builder → reviewer | Security, complex |
| **Full** | >= 0.6 | Agent team | Payment, auth, multi-component |

### 🔧 Skills (5)

| Skill | Purpose |
|-------|---------|
| `/dev-stacks:run` | Main orchestrator (auto-selects workflow) |
| `/dev-stacks:team` | Agent team for complex tasks |
| `/dev-stacks:research` | Research only, no implementation |
| `/dev-stacks:implement` | Implementation only, skip planning |
| `/dev-stacks:review` | Review only, verify existing code |

### 👥 Agents (3)

| Agent | Model | Role |
|-------|-------|------|
| **Thinker** | opus | Analyze, plan, research |
| **Builder** | opus | Implement, modify, fix |
| **Reviewer** | sonnet | Verify, test, ensure quality |

### 🔍 MCP Integration
Uses available MCP servers:
- `serena` — Code intelligence
- `context7` — Library documentation
- `memory` — Pattern storage
- `web_reader` — Web content

## Installation

### Option 1: Clone to Claude Plugins Directory

```bash
cd ~/.claude/plugins/
git clone https://github.com/1827mk/dev-stacks.git
```

### Option 2: Local Development

```bash
# Clone anywhere
git clone https://github.com/1827mk/dev-stacks.git

# Link to Claude plugins
ln -s $(pwd)/dev-stacks ~/.claude/plugins/dev-stacks
```

## Usage

### Automatic (Hook)

Just describe what you need:
```
แก้ bug login ไม่ได้

Hook output:
[DEV-STACKS] FIX_BUG | backend | complexity: 0.35
Workflow: standard | Invoke: /dev-stacks:run
Tools: systematic-debugging, serena
```

### Manual (Skills)

Invoke skills directly:
```
/dev-stacks:run        # Execute workflow
/dev-stacks:team       # Create agent team
/dev-stacks:research   # Research only
/dev-stacks:implement  # Implement only
/dev-stacks:review     # Review only
```

## Examples

### Quick Task (complexity < 0.2)
```
แก้ typo ใน README

Hook: MODIFY | general | complexity: 0.15 | Workflow: quick
AI implements directly (no skill invocation needed)
```

### Standard Task (complexity 0.2-0.39)
```
เพิ่ม email validation ใน login form

Hook: ADD_FEATURE | frontend | complexity: 0.35 | Workflow: standard
Invoke: /dev-stacks:run
→ Thinker plans → Builder implements
```

### Complex Task (complexity >= 0.6)
```
เพิ่ม payment system รองรับ 3 providers

Hook: ADD_FEATURE | backend | complexity: 0.65 | Workflow: full
Invoke: /dev-stacks:team
→ Lead + Security/Performance/Testing reviewers work in parallel
```

## Project Structure

```
dev-stacks/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest (v2.0.0)
├── hooks/
│   ├── hooks.json           # Hook configuration
│   └── prompt-enhancer.sh   # Main hook script
├── skills/
│   ├── run/SKILL.md         # Main orchestrator
│   ├── team/SKILL.md        # Agent team
│   ├── research/SKILL.md    # Research only
│   ├── implement/SKILL.md   # Implementation only
│   └── review/SKILL.md      # Review only
├── agents/
│   ├── thinker.md           # Analysis agent
│   ├── builder.md           # Implementation agent
│   └── reviewer.md          # Verification agent
├── .dev-stacks/
│   ├── registry.json        # Tools database
│   └── state.json           # Task state (runtime)
├── CLAUDE.md                # Project documentation
└── spec/                    # Architecture specification
```

## Data Storage

```
.dev-stacks/
├── registry.json    # Tools database
├── state.json       # Current task state
└── logs/            # Session logs
```

## Hook

| Hook | Purpose |
|------|---------|
| **UserPromptSubmit** | Analyze prompt, classify intent, calculate complexity, write state |

## Language Support

- Thai (ไทย) ✅
- English ✅
- Mixed (Thai + English) ✅

## Requirements

- Claude Code CLI
- `jq` (for hook script)

## Tips

1. **Trust the hook** — It analyzes every prompt automatically
2. **Use `/dev-stacks:run`** — Main orchestrator for most tasks
3. **Use `/dev-stacks:team`** — For complex, multi-component tasks
4. **Check state.json** — See current task analysis

## Changelog

### v2.0.0
- Complete rewrite with full feature utilization
- Single hook with prompt enhancement
- 5 focused skills (run/team/research/implement/review)
- 3 compact agents (thinker/builder/reviewer)
- Token optimization (52% reduction through context isolation)

### v1.x
- Initial release with orchestrator layer
- Multiple hooks and guards
- Complex skill structure

## License

MIT

## Author

[1827mk](https://github.com/1827mk)
