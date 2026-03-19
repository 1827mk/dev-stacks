# Implementation Tasks: Dev-Stacks

**Feature**: 002-dev-stacks
**Created**: 2026-03-18
**Architecture**: Pure Markdown-First + Research Capability

---

## Phase 1: Foundation (P0)

### 1.1 Plugin Skeleton
- [x] Create `dev-stacks/.claude-plugin/plugin.json`
- [x] Create `dev-stacks/config/defaults.json`
- [x] Create `dev-stacks/config/protected-paths.json`
- [x] Create `dev-stacks/config/dangerous-commands.json`

### 1.2 Hooks
- [x] Create `dev-stacks/hooks/SessionStart.md` - Load DNA, patterns, checkpoint
- [x] Create `dev-stacks/hooks/UserPromptSubmit.md` - Route to intent-router skill
- [x] Create `dev-stacks/hooks/PreToolUse.md` - Call guard skills
- [x] Create `dev-stacks/hooks/PostToolUse.md` - Audit logging
- [x] Create `dev-stacks/hooks/Stop.md` - Save checkpoint

### 1.3 Core Skills
- [x] Create `dev-stacks/skills/core/intent-router/SKILL.md`
- [x] Create `dev-stacks/skills/core/complexity-scorer/SKILL.md`
- [x] Create `dev-stacks/skills/core/team-selector/SKILL.md`

### 1.4 Agents
- [x] Create `dev-stacks/agents/thinker.md` - Planning agent (with research capability)
- [x] Create `dev-stacks/agents/builder.md` - Implementation agent (with research capability)
- [x] Create `dev-stacks/agents/tester.md` - Verification agent (with research capability)

### 1.5 Commands
- [x] Create `dev-stacks/commands/status.md` - `/dev-stacks:status`
- [x] Create `dev-stacks/commands/help.md` - `/dev-stacks:help`

### 1.6 Guard Skills
- [x] Create `dev-stacks/skills/guards/scope-guard/SKILL.md`
- [x] Create `dev-stacks/skills/guards/secret-scanner/SKILL.md`
- [x] Create `dev-stacks/skills/guards/bash-guard/SKILL.md`

---

## Phase 2: Intelligence (P1)

### 2.1 Workflow Skills
- [x] Create `dev-stacks/skills/workflows/quick/SKILL.md`
- [x] Create `dev-stacks/skills/workflows/standard/SKILL.md`
- [x] Create `dev-stacks/skills/workflows/careful/SKILL.md`
- [x] Create `dev-stacks/skills/workflows/full/SKILL.md`

### 2.2 Pattern Memory
- [x] Create `dev-stacks/skills/memory/pattern-manager/SKILL.md`
- [x] Implement pattern save logic (MCP Memory)
- [x] Implement pattern search logic (MCP Memory)
- [x] Implement pattern confidence tracking

### 2.3 Checkpoint System
- [x] Create `dev-stacks/skills/checkpoint/checkpoint-manager/SKILL.md`
- [x] Implement checkpoint save (MCP Filesystem)
- [x] Implement checkpoint load (MCP Filesystem)
- [x] Implement undo logic (Git)

### 2.4 Commands
- [x] Create `dev-stacks/commands/undo.md` - `/dev-stacks:undo`
- [x] Create `dev-stacks/commands/learn.md` - `/dev-stacks:learn`

---

## Phase 3: Polish (P2)

### 3.1 DNA System
- [x] Create `dev-stacks/skills/dna/dna-builder/SKILL.md`
- [x] Implement DNA scan logic
- [x] Implement DNA refresh logic

### 3.2 Commands
- [x] Create `dev-stacks/commands/doctor.md` - `/dev-stacks:doctor`

### 3.3 Audit System
- [x] Create `dev-stacks/skills/audit/audit-logger/SKILL.md`
- [x] Implement audit logging (MCP Filesystem)

### 3.4 Documentation
- [x] Create `dev-stacks/README.md`
- [x] Update quickstart with examples

---

## Completion Status

**All phases complete!** 🎉

Total: 32 files, ~5,000+ lines of documentation

```
Phase 1.1 (Skeleton)
    │
    ├──► Phase 1.2 (Hooks)
    │
    ├──► Phase 1.3 (Core Skills)
    │         │
    │         └──► Phase 1.4 (Agents)
    │                   │
    │                   └──► Phase 1.5 (Commands)
    │
    └──► Phase 1.6 (Guard Skills)
              │
              └──► Phase 2.x (Intelligence)
                        │
                        └──► Phase 3.x (Polish)
```

---

## Current Task

**Starting with**: Phase 1.1 - Plugin Skeleton

---

## Notes

- All files are Markdown (no TypeScript build)
- Agents have implicit research capability (MCP tools)
- Pattern storage via MCP Memory (Knowledge Graph)
- Checkpoint/DNA storage via MCP Filesystem (JSON)
