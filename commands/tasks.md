---
description: Break a plan into an executable task list — present for user to select and run
argument-hint: [optional: path to plan file, default: .dev-stacks/plan.md]
allowed-tools: Read, Write, Bash
model: sonnet
---

# dev-stacks: tasks

Plan source: $ARGUMENTS (default: `.dev-stacks/plan.md`)

## Steps

1. Read plan from argument path or `.dev-stacks/plan.md`
   - If no plan found: ask user to run `/dev-stacks:plan` first

2. Break plan into atomic tasks — each task must be:
   - A single file or tightly related group of files
   - Independently executable (no hidden dependencies unless stated)
   - Completable in one builder session

3. Present task list to user:

```
Tasks for: [plan name]
──────────────────────────────
[ ] 1. [task title]
       Files: [file list]
       Agent: [thinker+builder / builder only / reviewer only]
       Est. complexity: [quick/standard/careful/full]

[ ] 2. [task title]
       ...
──────────────────────────────
Which task to run? (number, or 'all' for sequential)
```

4. Wait for user to select a task number (or 'all')

5. For selected task:
   - Run `/dev-stacks:agents [task description]`
   - After completion: mark task as done in the list
   - Ask: "Continue to next task?"

6. Save updated task list to `.dev-stacks/tasks.md` after each completion
