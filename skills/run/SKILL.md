---
name: run
description: This skill should be used when the user asks to "run workflow", "execute task", "start dev-stacks", or when complexity-based workflow selection is needed. Auto-selects quick/standard/careful/full workflow based on task complexity.
---

# Dev-Stacks Run

Main workflow orchestrator. Reads task state and executes appropriate workflow.

## Process

1. Read `.dev-stacks/state.json` for complexity and workflow type
2. Execute workflow based on complexity:
   - `quick` (< 0.2): Direct implementation
   - `standard` (0.2-0.39): thinker → builder
   - `careful` (0.4-0.59): thinker → builder → reviewer
   - `full` (>= 0.6): Redirect to `/dev-stacks:team`
3. Return summary to main context

## Quick Workflow

Implement directly without subagents for simple tasks.

## Standard Workflow

```
1. Spawn thinker subagent
   - Returns: plan, files, approach

2. Spawn builder subagent
   - Input: thinker's plan
   - Returns: changes list
```

## Careful Workflow

```
1. Spawn thinker subagent (analyze + risks)
2. Spawn builder subagent (implement)
3. Spawn reviewer subagent (verify)
   - Returns: test results, issues
```

## Output

Return concise summary:
```
WORKFLOW: [type]
THINKER: [plan summary]
BUILDER: [changes summary]
REVIEWER: [results] (if applicable)
Done. [files modified]
```
