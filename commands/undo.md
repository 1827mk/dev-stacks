---
name: dev-stacks:undo
description: Undo changes - revert to previous state with multiple levels.
allowed-tools:
  - mcp__filesystem__read_text_file
  - mcp__filesystem__write_file
  - Bash
---

# /dev-stacks:undo

Undo changes made during the session.

## Usage

```
/dev-stacks:undo [level]
```

## Levels

| Level | Description | Scope |
|-------|-------------|-------|
| `action` | Undo last action (default) | Single operation |
| `phase` | Undo last phase | Think/Build/Test phase |
| `checkpoint` | Restore to last checkpoint | Full session state |
| `commit` | Git reset to base commit | All changes since start |

## Output Format

### Preview Before Undo

```
⏪ UNDO PREVIEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Level: [level]
Action: [what will be undone]
Time: [when it happened]

Changes to revert:
   - [File 1] (modified)
   - [File 2] (created)

Preview of original content:
   [Show diff or summary]

Proceed with undo? [Y/n]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### After Undo

```
⏪ UNDO COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Reverted: [action description]
Files restored: [count]

Current state:
   - Files touched this session: [count]
   - Undo stack depth: [remaining]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Examples

### Example 1: Undo Last Action
```
/dev-stacks:undo

⏪ UNDO PREVIEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Level: action
Action: Edit src/auth/login.ts
Time: 2 minutes ago

Changes to revert:
   - src/auth/login.ts (modified)

Preview:
   - Removed: Email validation
   - Restored: Original validation

Proceed with undo? [Y/n]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Example 2: Undo Phase
```
/dev-stacks:undo phase

⏪ UNDO PREVIEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Level: phase
Action: BUILD phase (login validation)
Time: 5 minutes ago

Changes to revert:
   - src/auth/login.ts (modified)
   - src/auth/login.test.ts (created)
   - src/validations/auth.ts (created)

This will undo the entire BUILD phase.
Proceed? [Y/n]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Example 3: Restore Checkpoint
```
/dev-stacks:undo checkpoint

⏪ UNDO PREVIEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Level: checkpoint
Action: Restore to checkpoint at 10:30
Time: 15 minutes ago

Changes to revert:
   - 5 files modified
   - 2 files created

Checkpoint state:
   - Phase: IDLE
   - Task: None

This will restore the entire session state.
Proceed? [Y/n]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Example 4: Git Reset
```
/dev-stacks:undo commit

⏪ UNDO PREVIEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Level: commit
Action: Git reset to base commit
Base commit: abc123def

Changes to revert:
   - All uncommitted changes
   - All files touched this session

⚠️ WARNING: This is destructive.
All work since session start will be lost.

Proceed? [Y/n]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Error Cases

### Nothing to Undo
```
⏪ UNDO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Nothing to undo.

Undo stack is empty.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### User Cancelled
```
⏪ UNDO CANCELLED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Undo cancelled by user.
No changes made.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Redo

After undo, you can redo:
```
/dev-stacks:redo

⏪ REDO COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Restored: [action description]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Notes

- Always shows preview before undoing
- Undo stack limited to 20 entries
- Git-based for file changes
- Checkpoint-based for session state
