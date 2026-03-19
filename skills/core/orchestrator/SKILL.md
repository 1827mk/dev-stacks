---
name: orchestrator
description: Orchestrate dev-stacks team workflow. Auto-invoked when hook shows complexity>=0.4. Manages state transitions and agent dispatch.
---

# Dev-Stacks Orchestrator

Manage team workflow for complex tasks. Your job: route tasks, manage state, dispatch agents.

## State Machine

```
IDLE → ANALYZING → PLANNING → CONFIRM → BUILDING → TESTING → DONE
                                                   ↘ (complexity<0.4) → DONE
ANY → ERROR (ask user: retry/replan/cancel/continue)
```

## Process

### 1. Read Context
From hook output: Intent, Complexity, Workflow, Task type

### 2. State Management
```bash
Read: .dev-stacks/state.json
Read: .dev-stacks/registry.json  # tool recommendations
```

Create if not exists:
```json
{
  "session_id": "sess-<timestamp>",
  "current_state": "IDLE",
  "task": null,
  "plan": null,
  "progress": {"thinker_done":false,"builder_done":false,"tester_done":false}
}
```

### 3. Dispatch by Workflow

| Workflow | Complexity | Agents | Process |
|----------|------------|--------|---------|
| Quick | <0.2 | Builder only | Skip Thinker, Skip Tester |
| Standard | 0.2-0.39 | Thinker → Builder | Plan then implement |
| Careful | 0.4-0.59 | Thinker → CONFIRM → Builder → Tester | User approval required |
| Full | >=0.6 | Thinker → CONFIRM → Builder → Tester | Full pipeline |

### 4. Agent Dispatch

**Thinker:**
```
Agent tool:
  subagent_type: "dev-stacks:thinker"
  prompt: |
    Task: [user's task]
    Available: All MCP servers, All skills
    Output: Analysis + Plan (files, approach, risks)
```

**Builder:**
```
Agent tool:
  subagent_type: "dev-stacks:builder"
  prompt: |
    Task: [user's task]
    Plan: [from Thinker]
    Available: All MCP servers, All skills
    Implement and report changes
```

**Tester:**
```
Agent tool:
  subagent_type: "dev-stacks:tester"
  prompt: |
    Task: [user's task]
    Changes: [from Builder]
    Verify: Run tests, check edge cases, confirm requirements met
```

### 5. User Confirmation (Careful/Full workflows)

After Thinker completes:
```
PLAN READY
Task: [description]
Files: [list]
Approach: [summary]
Proceed? (yes/modify/cancel)
```

### 6. Error Handling

On error, ask user:
```
ERROR: [details]
Options: retry | replan | cancel | continue
```

### 7. State Updates

After each step, update `.dev-stacks/state.json`:
- current_state
- plan (after Thinker)
- progress flags
- timestamps

### 8. Completion

```
DONE
Task: [original]
Changes:
- [file]: [what changed]
```

## Tool Recommendation

Match task to available tools from registry:
- Frontend → frontend-design skill, chrome-devtools MCP
- Backend → serena MCP, context7 for API docs
- Debugging → systematic-debugging skill
- Testing → TDD skill

Add recommendations to agent prompt when dispatching.

## Save to Memory

On success, save patterns via MCP memory:
```
mcp__memory__create_entities:
  entities:
    - name: "task-[id]-pattern"
      entityType: "dev-stacks-pattern"
      observations: [approach, tools used, outcome]
```
