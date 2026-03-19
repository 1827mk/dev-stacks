---
name: team
description: Create agent team for complex tasks (complexity >= 0.6). Independent coordination with shared task list.
---

# Dev-Stacks Team

Create coordinated agent team for complex tasks.

## When to Use
- Complexity >= 0.6
- Multiple components affected
- Security/performance critical
- Requires parallel review

## Team Structure

### Lead Agent
- Coordinates work
- Makes architectural decisions
- Resolves conflicts
- Skills: brainstorming, writing-plans

### Reviewer Agents (parallel)

**Security Reviewer**
- Focus: Auth, data handling, injection risks
- Skills: code-review

**Performance Reviewer**
- Focus: Query optimization, caching, load
- Skills: code-review

**Testing Reviewer**
- Focus: Test coverage, edge cases
- Skills: TDD, chrome-devtools

## Coordination

- Shared task list (all teammates see)
- Peer-to-peer messaging (SendMessage tool)
- Independent work (lead doesn't micromanage)
- Task claiming (first to claim owns it)

## Process

1. Read state.json
2. Create team with TeamCreate
3. Spawn teammates with Agent tool
4. Lead breaks down task into subtasks
5. Reviewers claim and work on subtasks
6. Teammates message each other
7. Lead integrates results
8. Return summary to main context

## Output

```
TEAM: [lead + reviewers]
TASKS: [n] subtasks created
RESULTS:
- Security: [issues found/fixed]
- Performance: [optimizations]
- Testing: [tests added]
Done. [summary]
```
