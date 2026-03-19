---
name: dev-stacks:init
description: Initialize or update Dev-Stacks for this project. First run builds DNA, subsequent runs refresh and update.
allowed-tools:
  - mcp__filesystem__read_text_file
  - mcp__filesystem__write_file
  - mcp__filesystem__get_file_info
  - mcp__filesystem__directory_tree
  - mcp__filesystem__create_directory
  - mcp__filesystem__search_files
  - mcp__memory__search_nodes
  - mcp__memory__create_entities
  - mcp__memory__add_observations
  - Bash
---

# /dev-stacks:init

Initialize or update Dev-Stacks for the current project.

## Usage

```
/dev-stacks:init [--force] [--quick]
```

## Arguments

| Argument | Description |
|----------|-------------|
| `--force` | Force full rebuild (reset + init) |
| `--quick` | Quick update (skip deep scan) |

---

## Behavior

### First Run (No DNA exists)

Full initialization:
1. Create `.dev-stacks/` directory structure
2. Scan project structure
3. Detect project type, languages, frameworks
4. Identify architecture and key modules
5. Detect risk areas (auth, payment, etc.)
6. Build complete DNA
7. Create initial checkpoint
8. Run tool discovery
9. Store baseline in MCP Memory

### Subsequent Runs (DNA exists)

Smart update (preserve learned data):
1. Read existing DNA
2. **Preserve**: `learned` section (patterns, preferences)
3. **Preserve**: `patterns` section
4. **Update**: `identity` (if changed)
5. **Refresh**: `architecture` (detect new modules)
6. **Recalculate**: `metrics`
7. **Merge**: `risk_areas` (add new, keep existing)
8. **Update**: `git` info
9. Incremental tool discovery

### With `--force`

Complete rebuild:
- Backup existing DNA
- Full rescan from scratch
- **Still preserve** learned data
- Reset all other sections

### With `--quick`

Fast update:
- Skip deep architecture scan
- Only update git info and metrics
- Refresh tool discovery
- Keep everything else

---

## Output Format

### First Run

```
🚀 DEV-STACKS INITIALIZATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📦 Setting up Dev-Stacks for this project...

Step 1/5: Creating directory structure... ✅
Step 2/5: Scanning project structure... ✅
Step 3/5: Building Project DNA... ✅
Step 4/5: Running tool discovery... ✅
Step 5/5: Storing baseline... ✅

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🧬 PROJECT DNA BUILT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 Identity:
   • Name: dev-stacks
   • Type: PLUGIN
   • Languages: Shell, Markdown, JSON
   • Frameworks: Claude Code Plugin

🏗️ Architecture:
   • Skills: 17 detected
   • Agents: 3 (thinker, builder, tester)
   • Commands: 7
   • Hooks: 6

⚠️ Risk Areas:
   • hooks/ - Can modify system behavior
   • config/ - Configuration files

📊 Metrics:
   • Files: 45
   • Skills: 17
   • Complexity: Low

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Dev-Stacks initialized successfully!

Next steps:
  • /dev-stacks:status - View full status
  • /dev-stacks:learn - Manage patterns
  • Just describe what you need!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Subsequent Run (Update)

```
🔄 DEV-STACKS UPDATE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📦 Updating Dev-Stacks for this project...

Reading existing DNA... ✅

Changes detected:
   • New files: 3
   • Modified files: 5
   • New dependencies: none
   • Branch: main (unchanged)

Preserving:
   ✅ 5 learned patterns
   ✅ User preferences
   ✅ 3 successful patterns

Updating:
   ✅ Architecture (new module detected)
   ✅ Metrics (files: 45 → 48)
   ✅ Git info
   ✅ Tool registry

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ DNA updated successfully!

Changes:
   • New module: skills/analytics/
   • Metrics updated
   • 5 patterns preserved

💾 DNA saved to .dev-stacks/dna.json
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### With --force

```
🔄 DEV-STACKS REBUILD (--force)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️ Full rebuild requested

Backing up existing DNA... ✅
   → .dev-stacks/dna.json.backup

Scanning project from scratch... ✅

Preserving learned data... ✅
   • 5 patterns preserved
   • Preferences preserved

Building fresh DNA... ✅

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ DNA rebuilt successfully!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### With --quick

```
⚡ DEV-STACKS QUICK UPDATE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Quick refresh (skipping deep scan)...

✅ Git info updated
✅ Metrics updated
✅ Tool discovery refreshed

💾 DNA saved.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Detection Logic

### Project Type Detection

| Signal | Type |
|--------|------|
| `.claude-plugin/plugin.json` | PLUGIN |
| `package.json` + `index.html` | FRONTEND |
| `package.json` + `server.ts/app.ts` | BACKEND |
| `package.json` + frontend + backend | FULLSTACK |
| `lib/` + exports | LIBRARY |
| `bin/` + shebang | CLI |
| `packages/` + multiple `package.json` | MONOREPO |
| `requirements.txt` / `pyproject.toml` | PYTHON |
| `go.mod` | GO |
| `Cargo.toml` | RUST |

### Plugin Type Specific

For Claude Code plugins, detect:
- Skills (scan `skills/**/SKILL.md`)
- Agents (scan `agents/*.md`)
- Commands (scan `commands/*.md`)
- Hooks (scan `hooks/*.sh` + `hooks/hooks.json`)

---

## What Gets Preserved on Update

| Section | Behavior |
|---------|----------|
| `identity` | Updated if changed |
| `architecture` | Refreshed (detect changes) |
| `patterns` | **Preserved** |
| `risk_areas` | Merged (add new, keep existing) |
| `learned` | **Always preserved** |
| `metrics` | Recalculated |
| `git` | Updated |

---

## Files Created/Updated

| File | First Run | Update |
|------|-----------|--------|
| `.dev-stacks/dna.json` | Create | Update |
| `.dev-stacks/state.json` | Create | Preserve |
| `.dev-stacks/checkpoint.json` | Create | Preserve |
| `.dev-stacks/registry.json` | Create | Refresh |
| `.dev-stacks/logs/` | Create | Preserve |

---

## Error Handling

### Permission Denied

```
❌ INIT ERROR
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Cannot create .dev-stacks/ directory

Error: Permission denied

Options:
  1. Check directory permissions
  2. Run with appropriate permissions
  3. Specify alternative location
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Corrupted DNA

```
⚠️ CORRUPTED DNA DETECTED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Existing DNA file is corrupted.

Options:
  1. Backup and rebuild (--force)
  2. Attempt repair
  3. Cancel

Reply with 1, 2, or 3.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Integration

This command is automatically suggested when:
- DNA file doesn't exist
- DNA is empty (`name: ""`)
- DNA is stale (> 7 days old)
- Major project changes detected

---

## Examples

```bash
# First time setup
/dev-stacks:init

# Quick refresh
/dev-stacks:init --quick

# Full rebuild (keeps learned data)
/dev-stacks:init --force
```
