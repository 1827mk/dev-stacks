---
name: team-selector
description: Select appropriate agents based on task complexity and workflow. Use after complexity scoring.
---

# Team Selector

Selects appropriate agents based on task complexity and workflow.

## Purpose

Determine which agents should participate in the task.

## Agent Roles

| Agent | Role | Invoked When |
|-------|------|--------------|
| Thinker | Plan, analyze, design | Complexity >= 0.2 |
| Builder | Implement, modify, fix | Always |
| Tester | Verify, validate, test | Complexity >= 0.4 |

## Selection Logic

```
function selectTeam(complexity, workflow):
    team = ["builder"]  # Builder is always included

    if complexity >= 0.2:
        team.append("thinker")

    if complexity >= 0.4:
        team.append("tester")

    if workflow == "FULL":
        # Add confirmation requirement

    return team
```

## Workflow → Team Mapping

| Workflow | Complexity | Team |
|----------|------------|------|
| QUICK | 0.0 - 0.19 | [Builder] |
| STANDARD | 0.2 - 0.39 | [Thinker, Builder] |
| CAREFUL | 0.4 - 0.59 | [Thinker, Builder, Tester] |
| FULL | 0.6 - 1.0 | [Thinker, Builder, Tester] + User Confirmation |

## Output Format

```json
{
  "workflow": "STANDARD",
  "complexity": 0.35,
  "team": ["thinker", "builder"],
  "execution_order": [
    {"agent": "thinker", "phase": "PLAN", "description": "Analyze and plan"},
    {"agent": "builder", "phase": "BUILD", "description": "Implement changes"}
  ],
  "requires_confirmation": false
}
```

## Execution Flow

```
QUICK Workflow:
  └── Builder → Done

STANDARD Workflow:
  ├── Thinker (Plan)
  └── Builder (Implement)

CAREFUL Workflow:
  ├── Thinker (Plan)
  ├── Builder (Implement)
  └── Tester (Verify)

FULL Workflow:
  ├── [User Confirmation Required]
  ├── Thinker (Plan)
  ├── Builder (Implement)
  ├── Tester (Verify)
  └── [User Review]
```

## Examples

### Example 1: Quick Task
```
Task: Fix typo in README
Complexity: 0.15
Workflow: QUICK

Team: [Builder]
Execution:
  └── Builder: Fix typo → Done
```

### Example 2: Standard Task
```
Task: Add email validation to login form
Complexity: 0.35
Workflow: STANDARD

Team: [Thinker, Builder]
Execution:
  ├── Thinker: Analyze form, plan validation approach
  └── Builder: Implement email validation
```

### Example 3: Full Task
```
Task: Implement payment processing
Complexity: 0.72
Workflow: FULL

Team: [Thinker, Builder, Tester]
Execution:
  ├── [CONFIRM] User approves plan
  ├── Thinker: Design payment architecture
  ├── Builder: Implement payment flow
  ├── Tester: Verify payment works
  └── [REVIEW] User reviews changes
```

## Research Capability

All agents have implicit research capability:
- Can use context7 for library docs
- Can use web_reader for tutorials
- Can use WebSearch for solutions
- Can use fetch for specific URLs

## Usage

Automatically invoked by UserPromptSubmit hook after complexity scoring.
