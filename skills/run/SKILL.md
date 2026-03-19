---
name: run
description: Execute workflow based on complexity. Auto-selects quick/standard/careful/full workflow and spawns appropriate subagents.
---

# Dev-Stacks Run

Main workflow orchestrator. Reads task state and executes appropriate workflow.

## Process

1. Read `.dev-stacks/state.json`
2. Get complexity score and workflow type
3. Execute workflow:
   - `quick` (< 0.2): Direct implementation
   - `standard` (0.2-0.39): thinker → builder
   - `careful` (0.4-0.59): thinker → builder → reviewer
   - `full` (>= 0.6): Redirect to `/dev-stacks:team`
4. Return summary to main context

## Quick Workflow
Implement directly without subagents for simple tasks.

## Standard Workflow
```
1. Spawn thinker subagent
   - skills: context7, web_reader, memory
   - Returns: plan, files, approach

2. Spawn builder subagent
   - skills: serena, frontend-design
   - Input: thinker's plan
   - Returns: changes list
```

## Careful Workflow
```
1. Spawn thinker subagent (analyze + risks)
2. Spawn builder subagent (implement)
3. Spawn reviewer subagent (verify)
   - skills: code-review, TDD
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
