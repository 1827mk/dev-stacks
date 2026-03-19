# Design Specification: Dev-Stacks Full Team System

**Feature**: Team System with State Machine Orchestration
**Created**: 2026-03-19
**Status**: Approved
**Author**: Design session with user

---

## Overview

Full team orchestration system สำหรับ Dev-Stacks plugin ที่ใช้ State Machine + Lightweight Orchestrator เพื่อจัดการการทำงานของ agents (Thinker, Builder, Tester) อัตโนมัติ

**Core Decisions:**
- Trigger: Confirm first (user ต้อง approve plan ก่อน dispatch)
- Execution: Staged (Thinker → Builder → Tester)
- Communication: Hybrid (MCP Memory + Task System)
- Error Recovery: Ask user immediately
- Orchestration: Lightweight skill + State tracking
- Agent Autonomy: Full access to all MCP servers and skills

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                        USER INPUT                                   │
│                   "เพิ่ม email validation"                          │
└─────────────────────────────┬───────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────────┐
│                  UserPromptSubmit Hook                              │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Output to context:                                          │   │
│  │  🔍 Intent: ADD_FEATURE | Complexity: 0.35 | Standard       │   │
│  │  📋 ORCHESTRATION: Use Skill tool → dev-stacks:orchestrator │   │
│  └─────────────────────────────────────────────────────────────┘   │
└─────────────────────────────┬───────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────────┐
│                  orchestrator SKILL                                 │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  1. Read routing info from context                          │   │
│  │  2. Load/Create state.json                                  │   │
│  │  3. STATE: ANALYZING → dispatch Thinker                     │   │
│  │  4. STATE: PLANNING → create plan                           │   │
│  │  5. STATE: CONFIRM → show plan, wait for user               │   │
│  │  6. STATE: BUILDING → dispatch Builder                      │   │
│  │  7. STATE: TESTING → dispatch Tester (if needed)            │   │
│  │  8. STATE: DONE → report results                            │   │
│  └─────────────────────────────────────────────────────────────┘   │
└─────────────────────────────┬───────────────────────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
        ┌──────────┐   ┌──────────┐   ┌──────────┐
        │ Thinker  │   │ Builder  │   │ Tester   │
        │  Agent   │   │  Agent   │   │  Agent   │
        │          │   │          │   │          │
        │ Full MCP │   │ Full MCP │   │ Full MCP │
        │ Autonomy │   │ Autonomy │   │ Autonomy │
        └──────────┘   └──────────┘   └──────────┘
              │               │               │
              └───────────────┴───────────────┘
                              │
              ┌───────────────┴───────────────┐
              ▼                               ▼
    ┌─────────────────────┐         ┌─────────────────────┐
    │     MCP Memory      │         │    Task System      │
    │   (Knowledge Store) │         │  (Progress Track)   │
    └─────────────────────┘         └─────────────────────┘
```

---

## State Machine Definition

### State Diagram

```
┌─────────┐     user input      ┌───────────┐
│  IDLE   │ ──────────────────► │ ANALYZING │
└────▲────┘                     └─────┬─────┘
     │                                │
     │                          analyze complete
     │                                │
     │                                ▼
     │                          ┌───────────┐
     │                          │  PLANNNING │
     │                          │  (Thinker) │
     │                          └─────┬─────┘
     │                                │
     │                          plan complete
     │                                │
     │                                ▼
     │                          ┌───────────┐
     │                          │  CONFIRM  │
     │                          │(wait user)│
     │                          └─────┬─────┘
     │                                │
     │             ┌─────approve──────┼──reject──► [CANCEL]
     │             │                  │
     │             ▼                  │
     │       ┌───────────┐            │
     │       │  BUILDING │            │
     │       │ (Builder) │            │
     │       └─────┬─────┘            │
     │             │                  │
     │       build complete           │
     │       (or error)               │
     │             │                  │
     │             ├─complexity < 0.4─┼─► [DONE]
     │             │                  │
     │             ▼                  │
     │       ┌───────────┐            │
     │       │  TESTING  │            │
     │       │ (Tester)  │            │
     │       └─────┬─────┘            │
     │             │                  │
     │       tests complete           │
     │             │                  │
     └─────────────┴──────────────────┘
```

### State Transitions

| From State | Event | To State | Action |
|------------|-------|----------|--------|
| IDLE | user_input | ANALYZING | Parse intent, calculate complexity |
| ANALYZING | analysis_done | PLANNING | Dispatch Thinker agent |
| PLANNING | plan_done | CONFIRM | Show plan, wait for user |
| CONFIRM | user_approve | BUILDING | Dispatch Builder agent |
| CONFIRM | user_reject | CANCEL | Clean up, report |
| BUILDING | build_done + complexity < 0.4 | DONE | Report results |
| BUILDING | build_done + complexity >= 0.4 | TESTING | Dispatch Tester agent |
| TESTING | tests_done | DONE | Report results |
| ANY | error | ERROR | Ask user what to do |

### Error State Handling

```
ERROR State Options:
├── RETRY → return to previous state, retry operation
├── REPLAN → return to PLANNING, Thinker re-plans
├── CANCEL → clean up, go to IDLE
└── CONTINUE → ignore error, proceed anyway (user accepts risk)
```

---

## state.json Schema

```json
{
  "version": "1.0.0",
  "session_id": "sess-abc123",
  "current_state": "CONFIRM",
  "task": {
    "id": "task-001",
    "user_input": "เพิ่ม email validation",
    "intent": "ADD_FEATURE",
    "complexity": 0.35,
    "workflow": "STANDARD"
  },
  "plan": {
    "thinker_output": "...",
    "files_to_modify": ["src/components/LoginForm.tsx"],
    "approach": "Use Zod for validation",
    "risks": ["May need to update tests"],
    "research_findings": [
      {
        "topic": "Zod + React Hook Form",
        "source": "context7",
        "key_learnings": ["zodResolver integrates Zod with RHF"]
      }
    ]
  },
  "progress": {
    "thinker_done": true,
    "builder_done": false,
    "tester_done": false
  },
  "error": null,
  "timestamps": {
    "created": "2026-03-19T10:30:00Z",
    "last_updated": "2026-03-19T10:35:00Z"
  }
}
```

---

## Agent Communication (Hybrid Model)

### MCP Memory Schema

```json
{
  "entities": [
    {
      "name": "task-001-analysis",
      "entityType": "dev-stacks-analysis",
      "observations": [
        "intent: ADD_FEATURE",
        "target: src/components/LoginForm.tsx",
        "complexity: 0.35",
        "files_identified: [LoginForm.tsx, auth.ts]",
        "dependencies: [zod, react-hook-form]"
      ]
    },
    {
      "name": "task-001-plan",
      "entityType": "dev-stacks-plan",
      "observations": [
        "approach: Use Zod schema with zodResolver",
        "step_1: Create validation schema",
        "step_2: Integrate with React Hook Form",
        "step_3: Add error message display"
      ]
    },
    {
      "name": "task-001-findings",
      "entityType": "dev-stacks-research",
      "observations": [
        "source: context7 Zod docs",
        "learned: zodResolver integrates Zod with RHF",
        "example: z.object({ email: z.string().email() })"
      ]
    }
  ],
  "relations": [
    { "from": "task-001-analysis", "to": "task-001-plan", "relationType": "informs" },
    { "from": "task-001-plan", "to": "task-001-findings", "relationType": "based_on" }
  ]
}
```

### Task System Integration

```
Orchestrator → TaskCreate → TaskUpdate flow:

1. TaskCreate: "Analyze task" → owner: null, status: pending
2. TaskUpdate: owner="thinker", status="in_progress"
3. Thinker completes → TaskUpdate: status="completed"
4. TaskCreate: "Implement task" → blockedBy: [analyze_task]
5. TaskUpdate: owner="builder", status="in_progress"
6. Builder completes → TaskUpdate: status="completed"
7. (Continue for Tester if needed)
```

---

## Agent Autonomy & MCP Integration

### Autonomy Principle

Agents have FULL ACCESS to all MCP servers and skills. They SELECT the best tools themselves based on what they need.

### Available MCP Servers

| MCP Server | Use When | Example Use Case |
|------------|----------|------------------|
| **context7** | Library documentation | "Zod API ใช้ยังไง?" |
| **web_reader** | Web content | "อ่าน tutorial จาก blog" |
| **WebSearch** | General search | "วิธีแก้ error X" |
| **fetch** | Specific URL | "อ่าน GitHub README" |
| **serena** | Code intelligence | "หา function ที่เรียก X" |
| **memory** | Pattern storage | "เคยแก้ปัญหานี้ไหม?" |
| **filesystem** | File operations | "อ่าน/เขียนไฟล์" |
| **sequentialthinking** | Deep analysis | "วิเคราะห์ปัญหาซับซ้อน" |
| **doc-forge** | Document processing | "อ่าน PDF/DOCX" |
| **chrome-devtools** | Browser debugging | "ทดสอบ UI" |

### Agent Decision Framework

```
When agent needs something:

1. What do I need?
   ├── Library docs → context7
   ├── Web content → web_reader / fetch
   ├── Search → WebSearch
   ├── Code patterns → serena + memory
   ├── Complex problem → sequentialthinking
   ├── Documents → doc-forge
   ├── Browser testing → chrome-devtools
   └── Skill match → Skill tool

2. Try it
3. If not enough, try another
4. Combine multiple if needed
5. Report what you used
```

### No Permission Needed

- ✅ Use any MCP tool when appropriate
- ✅ Invoke any skill when description matches
- ✅ Combine multiple tools
- ❌ Don't ask "should I use X?" - just use it if helpful

---

## Implementation File Changes

### Files to Create/Modify

| File | Action | Purpose |
|------|--------|---------|
| `skills/core/orchestrator/SKILL.md` | **CREATE** | Orchestrator skill |
| `hooks/user-prompt-submit.sh` | **MODIFY** | Add orchestration invoke |
| `config/defaults.json` | **MODIFY** | Add orchestrator settings |
| `agents/thinker.md` | **MODIFY** | Add MCP autonomy section |
| `agents/builder.md` | **MODIFY** | Add MCP autonomy section |
| `agents/tester.md` | **MODIFY** | Add MCP autonomy section |
| `.dev-stacks/state.json` | **AUTO-CREATED** | Runtime state file |

### Directory Structure After Implementation

```
dev-stacks/
├── .dev-stacks/
│   ├── state.json                  ← AUTO-CREATED (runtime)
│   ├── checkpoint.json
│   ├── dna.json
│   └── logs/
├── config/
│   └── defaults.json               ← MODIFIED
├── hooks/
│   └── user-prompt-submit.sh       ← MODIFIED
├── skills/
│   └── core/
│       ├── orchestrator/           ← NEW
│       │   └── SKILL.md            ← NEW
│       ├── intent-router/
│       ├── complexity-scorer/
│       └── team-selector/
└── agents/
    ├── thinker.md                  ← MODIFIED
    ├── builder.md                  ← MODIFIED
    └── tester.md                   ← MODIFIED
```

---

## Success Criteria

### Functional

| Criteria | Target |
|----------|--------|
| Intent detection accuracy | > 90% |
| Agent dispatch success rate | > 95% |
| State transition correctness | 100% |
| User confirmation capture | 100% (for all non-Quick tasks) |
| Error handling | 100% (all errors ask user) |

### Performance

| Criteria | Target |
|----------|--------|
| Hook execution time | < 100ms |
| State file operations | < 50ms |
| Agent dispatch time | < 5s |
| End-to-end task time | Per workflow spec |

### User Experience

| Criteria | Target |
|----------|--------|
| Tasks completed without intervention | > 80% |
| User commands usage | < 5% |
| Error recovery satisfaction | > 90% |
| Agent tool selection appropriateness | > 85% |

---

## Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| LLM ignores orchestrator instruction | Medium | High | Clear instructions + format |
| State file corruption | Low | Medium | Auto-recovery from checkpoint |
| Agent chooses wrong tool | Medium | Low | Agent guidelines + examples |
| MCP server unavailable | Low | Medium | Fallback to built-in tools |
| Infinite state loop | Low | High | Max iterations limit |

---

## Appendix: Example Flow

### Example: Add Email Validation

```
User: "เพิ่ม email validation ในฟอร์ม login"

1. Hook outputs:
   🔍 [DEV-STACKS] Intent: ADD_FEATURE | Complexity: 0.35 | Standard
   📋 ORCHESTRATION: Use Skill tool → dev-stacks:orchestrator

2. Orchestrator invokes, creates state.json:
   state: IDLE → ANALYZING

3. Orchestrator dispatches Thinker:
   - Thinker uses context7 for Zod docs
   - Thinker uses serena to find LoginForm
   - Thinker writes plan to memory

4. state: ANALYZING → PLANNING → CONFIRM

5. Orchestrator shows plan, asks user:
   "Plan: Add Zod validation to LoginForm. Proceed? [Y/n]"

6. User: "Y"

7. state: CONFIRM → BUILDING

8. Orchestrator dispatches Builder:
   - Builder reads plan from memory
   - Builder implements changes
   - Builder reports completion

9. state: BUILDING → DONE (complexity < 0.4)

10. Orchestrator reports:
    "✅ Email validation added to LoginForm.tsx"
```

---

## Next Steps

After this design is approved:

1. **Invoke writing-plans skill** to create implementation plan
2. **Implement files** in order:
   - Create orchestrator skill
   - Modify hook
   - Modify config
   - Update agents
3. **Test** with sample tasks
4. **Deploy** to plugin

---

*Design approved: 2026-03-19*
