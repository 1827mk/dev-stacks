# Spec: Dev-Stacks Full Feature Plugin

> Version: 2.0.0
> Date: 2026-03-19
> Status: DRAFT
> Uses: Hooks + Skills + Subagents + Agent Teams + MCP

---

## 1. Overview

### 1.1 Purpose

Plugin สำหรับ Claude Code ที่ใช้ **ทุก feature** อย่างเต็มประสิทธิภาพ:
- **Hooks**: Entry point, state management, prompt enhancement
- **Skills**: Workflow triggers, on-demand knowledge
- **Subagents**: Isolated execution, context isolation
- **Agent Teams**: Complex task coordination
- **MCP**: External tools (serena, context7, memory, etc.)
- **CLAUDE.md**: Project conventions (persistent)

### 1.2 Design Principles

1. **Layered Architecture**: Hook → Skill → Subagent/Team
2. **Context Isolation**: Heavy work in subagents, summaries return
3. **Lazy Loading**: Skills load on demand
4. **Token Efficient**: Main context stays minimal
5. **Full Automation**: Spawn subagents/teams automatically

### 1.3 Feature Utilization

| Feature | Usage | Purpose |
|---------|-------|---------|
| Hooks | 100% | Entry point, state management |
| Skills | 100% | Workflow triggers, reference |
| Subagents | 100% | Isolated workers |
| Agent Teams | 100% | Complex coordination |
| MCP | 100% | External tools |
| CLAUDE.md | 100% | Project conventions |

---

## 2. Architecture

### 2.1 Layered Flow

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                         DEV-STACKS FULL ARCHITECTURE                            │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌───────────────────────────────────────────────────────────────────────────┐ │
│  │                     LAYER 1: HOOK (Entry Point)                           │ │
│  │                                                                           │ │
│  │   UserPromptSubmit ─────► prompt-enhancer.sh                              │ │
│  │                               │                                           │ │
│  │                               ├─► Parse input                            │ │
│  │                               ├─► Classify intent                        │ │
│  │                               ├─► Calculate complexity                   │ │
│  │                               ├─► Write state.json                       │ │
│  │                               └─► Output recommendation                  │ │
│  │                                                                           │ │
│  │   Output (2-3 lines):                                                     │ │
│  │   [DEV-STACKS] ADD_FEATURE | frontend | complexity: 0.35                │ │
│  │   Workflow: standard | Invoke: /dev-stacks:run                           │ │
│  │                                                                           │ │
│  │   Token: ~50                                                              │ │
│  │   Runs: Every prompt                                                      │ │
│  │                                                                           │ │
│  └───────────────────────────────────────────────────────────────────────────┘ │
│                                      │                                          │
│                                      ▼                                          │
│  ┌───────────────────────────────────────────────────────────────────────────┐ │
│  │                     LAYER 2: SKILL (Workflow Trigger)                     │ │
│  │                                                                           │ │
│  │   /dev-stacks:run ─────► Main workflow orchestrator                       │ │
│  │   /dev-stacks:research ─► Research-only workflow                          │ │
│  │   /dev-stacks:implement ─► Implementation-only workflow                   │ │
│  │   /dev-stacks:review ───► Review-only workflow                            │ │
│  │   /dev-stacks:team ─────► Agent team for complex tasks                    │ │
│  │                                                                           │ │
│  │   Skills read state.json → Determine workflow → Spawn agents             │ │
│  │                                                                           │ │
│  │   Token: ~500 (loaded on invoke only)                                     │ │
│  │   Runs: On demand (user or AI invokes)                                    │ │
│  │                                                                           │ │
│  └───────────────────────────────────────────────────────────────────────────┘ │
│                                      │                                          │
│                        ┌─────────────┴─────────────┐                           │
│                        │                           │                           │
│                        ▼                           ▼                           │
│  ┌────────────────────────────────┐  ┌────────────────────────────────┐        │
│  │   LAYER 3A: SUBAGENTS          │  │   LAYER 3B: AGENT TEAM         │        │
│  │   (complexity < 0.6)           │  │   (complexity >= 0.6)          │        │
│  │                                │  │                                │        │
│  │   ┌─────────────────────────┐  │  │   ┌─────────────────────────┐  │        │
│  │   │ THINKER                 │  │  │   │ LEAD AGENT              │  │        │
│  │   │ - Analyze               │  │  │   │ - Coordinate            │  │        │
│  │   │ - Research              │  │  │   │ - Make decisions        │  │        │
│  │   │ - Plan                  │  │  │   └───────────┬─────────────┘  │        │
│  │   │ Returns: Plan summary   │  │  │               │                │        │
│  │   └─────────────────────────┘  │  │               │                │        │
│  │              │                 │  │       ┌───────┴───────┐        │        │
│  │              ▼                 │  │       │               │        │        │
│  │   ┌─────────────────────────┐  │  │       ▼               ▼        │        │
│  │   │ BUILDER                 │  │  │   ┌─────────┐  ┌─────────┐     │        │
│  │   │ - Implement             │  │  │   │REVIEWER │  │REVIEWER │     │        │
│  │   │ - Follow plan           │  │  │   │Security │  │Testing  │     │        │
│  │   │ Returns: Changes list   │  │  │   └─────────┘  └─────────┘     │        │
│  │   └─────────────────────────┘  │  │       │               │        │        │
│  │              │                 │  │       └───────┬───────┘        │        │
│  │              ▼                 │  │               │                │        │
│  │   ┌─────────────────────────┐  │  │               ▼                │        │
│  │   │ REVIEWER                │  │  │   ┌─────────────────────────┐  │        │
│  │   │ - Verify                │  │  │   │ Shared Task List        │  │        │
│  │   │ - Test                  │  │  │   │ Peer-to-peer messaging  │  │        │
│  │   │ Returns: Test results   │  │  │   │ Independent coord        │  │        │
│  │   └─────────────────────────┘  │  │   └─────────────────────────┘  │        │
│  │                                │  │                                │        │
│  │   Token: ~300 each (isolated)  │  │   Token: ~800 each (independent)│       │
│  │   Runs: Sequential/Parallel    │  │   Runs: Parallel, coordinated   │       │
│  │                                │  │                                │        │
│  └────────────────────────────────┘  └────────────────────────────────┘        │
│                                      │                                          │
│                                      ▼                                          │
│  ┌───────────────────────────────────────────────────────────────────────────┐ │
│  │                     LAYER 4: MCP (Tools & Services)                       │ │
│  │                                                                           │ │
│  │   ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐           │ │
│  │   │ serena  │ │context7 │ │ memory  │ │webreader│ │chrome   │           │ │
│  │   │         │ │         │ │         │ │         │ │devtools │           │ │
│  │   │ code    │ │ docs    │ │ patterns│ │ web     │ │ browser │           │ │
│  │   └─────────┘ └─────────┘ └─────────┘ └─────────┘ └─────────┘           │ │
│  │                                                                           │ │
│  │   Used by: All subagents and skills automatically                        │ │
│  │   Token: ~1000 (loaded at session start)                                  │ │
│  │                                                                           │ │
│  └───────────────────────────────────────────────────────────────────────────┘ │
│                                                                                 │
│  ┌───────────────────────────────────────────────────────────────────────────┐ │
│  │                     LAYER 5: CLAUDE.md (Project Context)                  │ │
│  │                                                                           │ │
│  │   - Project conventions                                                   │ │
│  │   - Build commands                                                        │ │
│  │   - Coding standards                                                      │ │
│  │   - "Always do X" rules                                                   │ │
│  │                                                                           │ │
│  │   Token: ~200 (loaded every session)                                      │ │
│  │   Runs: Always                                                            │ │
│  │                                                                           │ │
│  └───────────────────────────────────────────────────────────────────────────┘ │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### 2.2 Token Distribution

```
┌─────────────────────────────────────────────────────────────────────┐
│                    TOKEN DISTRIBUTION                               │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Context            │ Load Time    │ Token Cost │ Strategy         │
│  ───────────────────┼──────────────┼────────────┼─────────────────│
│  CLAUDE.md          │ Session start│ ~200       │ Keep minimal    │
│  MCP tools          │ Session start│ ~1000      │ Already loaded  │
│  Skill descriptions │ Session start│ ~200       │ Descriptions    │
│  Hook output        │ Every prompt │ ~50        │ Minimal         │
│  ───────────────────┼──────────────┼────────────┼─────────────────│
│  MAIN CONTEXT TOTAL │              │ ~1450      │                 │
│                                                                     │
│  ───────────────────┼──────────────┼────────────┼─────────────────│
│  Skill (on invoke)  │ On demand    │ ~500       │ Lazy load       │
│  Subagent context   │ On spawn     │ ~300       │ Isolated        │
│  Agent team context │ On create    │ ~800       │ Independent     │
│  ───────────────────┼──────────────┼────────────┼─────────────────│
│  ISOLATED TOTAL     │              │ ~1600      │ Not in main     │
│                                                                     │
│  ─────────────────────────────────────────────────────────────────  │
│  WITHOUT ISOLATION: ~1450 + 1600 = 3050 tokens                     │
│  WITH ISOLATION:    ~1450 tokens in main context                   │
│  SAVINGS:           52% reduction                                  │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 3. Workflow Invocation Flow

### 3.1 How Invocation Works

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                      WORKFLOW INVOCATION FLOW                                   │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  STEP 1: USER PROMPT                                                            │
│  ─────────────────────────────────────────────────────────────────────────────  │
│  User: "เพิ่ม JWT auth ใน API"                                                   │
│                                                                                 │
│  STEP 2: HOOK EXECUTION (Automatic)                                            │
│  ─────────────────────────────────────────────────────────────────────────────  │
│  UserPromptSubmit hook runs:                                                    │
│  ├─ prompt-enhancer.sh executes                                                 │
│  ├─ Classifies intent: ADD_FEATURE                                             │
│  ├─ Detects domain: backend                                                     │
│  ├─ Calculates complexity: 0.55                                                 │
│  ├─ Determines workflow: careful                                                │
│  └─ Writes state.json                                                           │
│                                                                                 │
│  Hook Output (2 lines to AI context):                                           │
│  [DEV-STACKS] ADD_FEATURE | backend | complexity: 0.55                         │
│  Workflow: careful | Invoke: /dev-stacks:run                                   │
│                                                                                 │
│  STEP 3: SKILL INVOCATION (Manual or AI-decided)                               │
│  ─────────────────────────────────────────────────────────────────────────────  │
│  User (or AI) types: /dev-stacks:run                                           │
│                                                                                 │
│  OR                                                                             │
│                                                                                 │
│  AI sees hook output and decides to invoke:                                     │
│  "Based on complexity 0.55, I'll use /dev-stacks:run"                          │
│                                                                                 │
│  STEP 4: SKILL EXECUTES                                                         │
│  ─────────────────────────────────────────────────────────────────────────────  │
│  /dev-stacks:run skill:                                                         │
│  ├─ Reads .dev-stacks/state.json                                               │
│  ├─ Gets complexity: 0.55                                                       │
│  ├─ Determines workflow: careful (0.4-0.59)                                    │
│  └─ Prepares to spawn subagents                                                 │
│                                                                                 │
│  STEP 5: SUBAGENT SPAWNING                                                      │
│  ─────────────────────────────────────────────────────────────────────────────  │
│  Spawn thinker subagent:                                                        │
│    subagent_type: "dev-stacks:thinker"                                          │
│    skills: [context7, web_reader, memory]                                       │
│    prompt: "Analyze JWT auth requirements for API. Plan implementation."        │
│                                                                                 │
│  [Thinker works in ISOLATED context, returns summary]                           │
│                                                                                 │
│  Spawn builder subagent:                                                        │
│    subagent_type: "dev-stacks:builder"                                          │
│    skills: [serena]                                                             │
│    prompt: "Implement JWT auth following thinker's plan"                        │
│                                                                                 │
│  [Builder works in ISOLATED context, returns summary]                           │
│                                                                                 │
│  Spawn reviewer subagent:                                                       │
│    subagent_type: "dev-stacks:reviewer"                                         │
│    skills: [code-review]                                                        │
│    prompt: "Verify JWT implementation for security issues"                      │
│                                                                                 │
│  [Reviewer works in ISOLATED context, returns summary]                          │
│                                                                                 │
│  STEP 6: SUMMARY TO MAIN CONTEXT                                                │
│  ─────────────────────────────────────────────────────────────────────────────  │
│  Main context receives:                                                         │
│  "WORKFLOW COMPLETE                                                             │
│   THINKER: JWT utility + middleware + refresh tokens                            │
│   BUILDER: Created src/auth/jwt.ts, middleware/auth.ts                         │
│   REVIEWER: 3 tests passed, 1 security suggestion                              │
│   Done. JWT auth implemented."                                                  │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### 3.2 Invocation Decision Matrix

| Complexity | Workflow | Hook Output | Skill to Invoke | Subagents |
|------------|----------|-------------|-----------------|-----------|
| < 0.2 | quick | `Workflow: quick` | None needed | None |
| 0.2-0.39 | standard | `Workflow: standard` | `/dev-stacks:run` | thinker → builder |
| 0.4-0.59 | careful | `Workflow: careful` | `/dev-stacks:run` | thinker → builder → reviewer |
| >= 0.6 | full | `Workflow: full` | `/dev-stacks:team` | Agent team |

### 3.3 Skill Invocation Methods

**Method 1: User Explicit Invoke**
```
User types: /dev-stacks:run
→ Skill executes immediately
```

**Method 2: AI Auto-invoke (Recommended)**
```
AI sees hook output:
"[DEV-STACKS] ADD_FEATURE | backend | complexity: 0.55
 Workflow: careful | Invoke: /dev-stacks:run"

AI decides: "I'll invoke /dev-stacks:run for this task"
→ AI uses Skill tool with skill="dev-stacks:run"
```

**Method 3: AI Follows Recommendation**
```
AI sees: "Invoke: /dev-stacks:run"
AI types: /dev-stacks:run
→ Skill executes
```

---

## 4. Agent Coordination Mechanism

### 4.1 Subagent Coordination (Sequential)

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                    SUBAGENT COORDINATION (Sequential)                           │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  STANDARD WORKFLOW (complexity 0.2-0.39):                                      │
│                                                                                 │
│  ┌─────────┐      ┌─────────┐                                                  │
│  │THINKER  │ ───► │BUILDER  │                                                  │
│  └─────────┘      └─────────┘                                                  │
│       │                │                                                        │
│       │                │                                                        │
│       ▼                ▼                                                        │
│  Returns:          Returns:                                                     │
│  - Plan           - Files changed                                              │
│  - Files          - Summary                                                    │
│  - Approach                                                                      │
│                                                                                 │
│  CAREFUL WORKFLOW (complexity 0.4-0.59):                                       │
│                                                                                 │
│  ┌─────────┐      ┌─────────┐      ┌─────────┐                                │
│  │THINKER  │ ───► │BUILDER  │ ───► │REVIEWER │                                │
│  └─────────┘      └─────────┘      └─────────┘                                │
│       │                │                │                                       │
│       ▼                ▼                ▼                                       │
│  Returns:          Returns:          Returns:                                   │
│  - Plan           - Changes          - Test results                            │
│  - Risks          - Files            - Issues                                  │
│  - Files                            - Recommendations                          │
│                                                                                 │
│  COORDINATION:                                                                  │
│  - Main skill orchestrates spawning                                            │
│  - Each subagent runs in isolated context                                       │
│  - Output from one feeds into next                                              │
│  - Main context only receives final summary                                    │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### 4.2 Agent Team Coordination (Parallel)

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                    AGENT TEAM COORDINATION (Parallel)                           │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  FULL WORKFLOW (complexity >= 0.6):                                            │
│                                                                                 │
│  ┌──────────────────────────────────────────────────────────────────────┐      │
│  │                         LEAD AGENT                                   │      │
│  │  - Reads state.json                                                  │      │
│  │  - Creates team with TeamCreate                                      │      │
│  │  - Breaks down task into subtasks                                    │      │
│  │  - Creates tasks with TaskCreate                                     │      │
│  │  - Monitors progress                                                 │      │
│  └──────────────────────────────┬───────────────────────────────────────┘      │
│                                 │                                               │
│                ┌────────────────┼────────────────┐                             │
│                │                │                │                             │
│                ▼                ▼                ▼                             │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐               │
│  │ SECURITY        │  │ PERFORMANCE     │  │ TESTING         │               │
│  │ REVIEWER        │  │ REVIEWER        │  │ REVIEWER        │               │
│  │                 │  │                 │  │                 │               │
│  │ Skills:         │  │ Skills:         │  │ Skills:         │               │
│  │ - code-review   │  │ - code-review   │  │ - TDD           │               │
│  │                 │  │                 │  │ - chrome-devtools│              │
│  │ Focus:          │  │ Focus:          │  │                 │               │
│  │ - Auth          │  │ - Queries       │  │ Focus:          │               │
│  │ - Data handling │  │ - Caching       │  │ - Test coverage │               │
│  │ - Injection     │  │ - Load          │  │ - Edge cases    │               │
│  └────────┬────────┘  └────────┬────────┘  └────────┬────────┘               │
│           │                    │                    │                          │
│           └────────────────────┴────────────────────┘                          │
│                                │                                                │
│                                ▼                                                │
│  ┌──────────────────────────────────────────────────────────────────────┐      │
│  │                    SHARED TASK LIST                                  │      │
│  │  - All teammates see same tasks                                     │      │
│  │  - Tasks claimable by any reviewer                                  │      │
│  │  - Progress tracked with TaskUpdate                                 │      │
│  └──────────────────────────────────────────────────────────────────────┘      │
│                                                                                 │
│  COORDINATION TOOLS:                                                           │
│  ┌────────────────────────────────────────────────────────────────────────┐    │
│  │ Tool              │ Purpose                                           │    │
│  │ ──────────────────┼──────────────────────────────────────────────────│    │
│  │ SendMessage       │ Peer-to-peer messaging between teammates         │    │
│  │ TaskCreate        │ Create new subtasks                              │    │
│  │ TaskUpdate        │ Claim tasks, update status                       │    │
│  │ TaskList          │ View all tasks and progress                      │    │
│  │ TaskGet           │ Get task details                                 │    │
│  └────────────────────────────────────────────────────────────────────────┘    │
│                                                                                 │
│  MESSAGING FLOW:                                                               │
│  ┌────────────────────────────────────────────────────────────────────────┐    │
│  │ Security Reviewer → Lead: "Found SQL injection risk in auth.ts"       │    │
│  │ Lead → All: "Priority: fix injection risk first"                       │    │
│  │ Testing Reviewer → Lead: "Added test for injection case"              │    │
│  │ Lead → All: "Good. Continue with remaining tasks."                     │    │
│  └────────────────────────────────────────────────────────────────────────┘    │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### 4.3 State Transitions

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                         STATE TRANSITIONS                                       │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  STATE.JSON LIFECYCLE:                                                         │
│                                                                                 │
│  1. INITIAL (Hook writes)                                                       │
│     {                                                                           │
│       "workflow": {"current_phase": "QUEUED", "progress": 0}                   │
│     }                                                                           │
│                                                                                 │
│  2. THINKER RUNNING (Skill updates)                                            │
│     {                                                                           │
│       "workflow": {"current_phase": "THINKING", "progress": 25}                │
│     }                                                                           │
│                                                                                 │
│  3. BUILDER RUNNING                                                             │
│     {                                                                           │
│       "workflow": {"current_phase": "BUILDING", "progress": 50}                │
│     }                                                                           │
│                                                                                 │
│  4. REVIEWER RUNNING (if careful workflow)                                     │
│     {                                                                           │
│       "workflow": {"current_phase": "TESTING", "progress": 75}                 │
│     }                                                                           │
│                                                                                 │
│  5. COMPLETE                                                                    │
│     {                                                                           │
│       "workflow": {"current_phase": "DONE", "progress": 100}                   │
│     }                                                                           │
│                                                                                 │
│  PHASE DIAGRAM:                                                                 │
│                                                                                 │
│  QUEUED ──► THINKING ──► BUILDING ──► TESTING ──► DONE                        │
│     │           │            │            │                                      │
│     └───────────┴────────────┴────────────┘                                      │
│                          │                                                       │
│                          ▼                                                       │
│                        ERROR (if failure)                                        │
│                          │                                                       │
│                          ▼                                                       │
│                    Ask user: retry/replan/cancel                                │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## 5. Real-World Execution Examples

### 5.1 Example: Simple Bug Fix (complexity 0.15)

```
USER: "แก้ typo ใน README"

HOOK OUTPUT:
[DEV-STACKS] MODIFY | general | complexity: 0.15
Workflow: quick | Implement directly

AI RESPONSE:
(Sees complexity < 0.2, implements directly)
"แก้ typo ใน README แล้วครับ"

NO SKILL INVOCATION NEEDED
```

### 5.2 Example: Add Feature (complexity 0.35)

```
USER: "เพิ่ม email validation ใน login form"

HOOK OUTPUT:
[DEV-STACKS] ADD_FEATURE | frontend | complexity: 0.35
Workflow: standard | Invoke: /dev-stacks:run
Tools: brainstorming, frontend-design

AI OR USER: /dev-stacks:run

SKILL EXECUTES:
1. Reads state.json (complexity: 0.35)
2. Determines workflow: standard
3. Spawns thinker subagent

THINKER OUTPUT:
"Plan: Add Zod schema for email, integrate with React Hook Form, add error display"

4. Spawns builder subagent

BUILDER OUTPUT:
"Created validation schema, integrated with form, added error messages"

SUMMARY TO USER:
"Email validation added to login form. Files: src/validations/auth.ts, src/LoginForm.tsx"
```

### 5.3 Example: Complex Feature (complexity 0.65)

```
USER: "เพิ่ม payment system รองรับ 3 providers"

HOOK OUTPUT:
[DEV-STACKS] ADD_FEATURE | backend | complexity: 0.65
Workflow: full | Invoke: /dev-stacks:team
Tools: brainstorming, serena

AI OR USER: /dev-stacks:team

SKILL EXECUTES:
1. Reads state.json (complexity: 0.65)
2. Creates agent team with TeamCreate
3. Spawns lead + 3 reviewers

TEAM COORDINATION:
Lead: "Breaking down into 5 subtasks..."
Lead: [TaskCreate] "Implement Stripe provider"
Lead: [TaskCreate] "Implement PayPal provider"
Lead: [TaskCreate] "Implement local bank provider"
Lead: [TaskCreate] "Add security measures"
Lead: [TaskCreate] "Write tests"

Security Reviewer: [SendMessage] "Found PCI compliance issue in card handling"
Lead: [SendMessage] "Priority: fix compliance first"
Testing Reviewer: [SendMessage] "Added E2E tests for all 3 providers"

SUMMARY TO USER:
"Payment system implemented with Stripe, PayPal, and local bank.
Security: 2 issues fixed. Tests: 15 added, all pass."
```

---

## 6. Component Specifications

### 3.1 Hooks

#### 3.1.1 File: hooks/prompt-enhancer.sh

```bash
#!/bin/bash
# Dev-Stacks Prompt Enhancer
# Version: 2.0.0
# Purpose: Entry point, state management, workflow recommendation

set -euo pipefail

# Configuration
REGISTRY_PATH=".dev-stacks/registry.json"
STATE_PATH=".dev-stacks/state.json"
MAX_OUTPUT_LINES=3

# Read input
INPUT=$(cat)
USER_PROMPT=$(echo "$INPUT" | jq -r '.user_prompt // ""')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')

# Skip slash commands
[[ "$USER_PROMPT" == /* ]] && exit 0

# Skip if registry missing
[[ ! -f "$REGISTRY_PATH" ]] && exit 0

# Main logic
main() {
    # Step 1: Classify intent
    local intent=$(classify_intent "$USER_PROMPT")

    # Step 2: Detect domain
    local domain=$(detect_domain "$USER_PROMPT")

    # Step 3: Calculate complexity
    local complexity=$(calculate_complexity "$USER_PROMPT" "$intent" "$domain")

    # Step 4: Determine workflow
    local workflow=$(determine_workflow "$complexity")

    # Step 5: Write state
    write_state "$SESSION_ID" "$USER_PROMPT" "$intent" "$domain" "$complexity" "$workflow"

    # Step 6: Output
    output "$intent" "$domain" "$complexity" "$workflow"
}

# Output function
output() {
    local intent="$1"
    local domain="$2"
    local complexity="$3"
    local workflow="$4"

    echo "[DEV-STACKS] $intent | $domain | complexity: $complexity"
    echo "Workflow: $workflow | Invoke: /dev-stacks:run"
}

main
exit 0
```

### 3.2 Skills

#### 3.2.1 File: skills/run/SKILL.md

```markdown
---
name: run
description: Execute workflow based on complexity. Reads state.json and spawns appropriate subagents or team.
---

# Dev-Stacks Run

Main workflow orchestrator. Reads task state and executes appropriate workflow.

## Process

1. Read `.dev-stacks/state.json`
2. Get complexity score
3. Determine workflow:
   - `< 0.2`: Quick (direct implementation)
   - `0.2-0.39`: Standard (thinker → builder)
   - `0.4-0.59`: Careful (thinker → builder → reviewer)
   - `>= 0.6`: Full (agent team)
4. Spawn appropriate agents
5. Return summary to main context

## Subagent Spawning

### Standard Workflow (0.2-0.39)
```
Spawn thinker subagent:
  skills: [context7, web_reader, memory]
  task: Analyze and plan

After thinker completes:
Spawn builder subagent:
  skills: [serena, frontend-design]
  task: Implement plan
```

### Careful Workflow (0.4-0.59)
```
Spawn thinker subagent:
  skills: [context7, web_reader, memory]
  task: Analyze and plan with risks

After thinker completes:
Spawn builder subagent:
  skills: [serena, frontend-design]
  task: Implement plan

After builder completes:
Spawn reviewer subagent:
  skills: [code-review, TDD]
  task: Verify implementation
```

### Full Workflow (>= 0.6)
```
Use /dev-stacks:team skill instead
```

## Output

Return concise summary to main context:
- Task completed
- Changes made
- Issues found (if any)
```

#### 3.2.2 File: skills/team/SKILL.md

```markdown
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

### Reviewer Agents (spawned in parallel)

**Security Reviewer**
- Skills: code-review
- Focus: Auth, data handling, injection risks

**Performance Reviewer**
- Skills: code-review
- Focus: Query optimization, caching, load

**Testing Reviewer**
- Skills: TDD, chrome-devtools
- Focus: Test coverage, edge cases, E2E

## Coordination

- Shared task list (all teammates see)
- Peer-to-peer messaging (teammates communicate directly)
- Independent work (lead doesn't micromanage)
- Task claiming (first to claim owns it)

## Process

1. Read state.json
2. Create team with 1 lead + 3 reviewers
3. Lead breaks down task into subtasks
4. Reviewers claim and work on subtasks
5. Teammates message each other for coordination
6. Lead reviews and integrates results
7. Return summary to main context

## Team Communication

Teammates use SendMessage tool for:
- Sharing findings
- Asking questions
- Coordinating work
- Reporting blockers

Lead uses TaskCreate/TaskUpdate for:
- Creating subtasks
- Tracking progress
```

#### 3.2.3 File: skills/research/SKILL.md

```markdown
---
name: research
description: Research-only workflow. Spawns thinker subagent for analysis without implementation.
---

# Dev-Stacks Research

Research and analysis only. No implementation.

## Use When

- Need to understand codebase
- Researching best practices
- Evaluating approaches
- Documentation review

## Process

1. Read state.json
2. Spawn thinker subagent with research focus
3. Return findings to main context

## Output

- Key findings
- Recommended approach
- Relevant code locations
- Documentation links
```

#### 3.2.4 File: skills/implement/SKILL.md

```markdown
---
name: implement
description: Implementation-only workflow. Skips planning, goes straight to building.
---

# Dev-Stacks Implement

Direct implementation without planning phase.

## Use When

- Plan already exists
- Simple, clear task
- Following established patterns

## Process

1. Read state.json
2. Spawn builder subagent
3. Return changes to main context

## Output

- Files modified
- Changes summary
- Next steps (if any)
```

#### 3.2.5 File: skills/review/SKILL.md

```markdown
---
name: review
description: Review-only workflow. Verifies existing implementation.
---

# Dev-Stacks Review

Verification and review only.

## Use When

- Code already written
- Need quality check
- Pre-commit review
- Post-implementation verification

## Process

1. Read state.json
2. Spawn reviewer subagent
3. Return findings to main context

## Output

- Issues found
- Recommendations
- Pass/Fail status
```

### 3.3 Subagents

#### 3.3.1 File: agents/thinker.md

```markdown
---
name: thinker
description: Analysis and planning agent. Researches, analyzes, creates implementation plans.
model: opus
skills:
  - context7
  - web_reader
  - memory
  - serena
---

# Thinker Agent

Analyze task and create implementation plan.

## Role

- Understand requirements
- Research unknowns (use MCP tools)
- Analyze existing code (use serena)
- Identify affected files
- Create step-by-step plan
- Identify risks and mitigations

## Tools Available

| Tool | Use For |
|------|---------|
| context7 | Library docs, API references |
| web_reader | Web content, tutorials |
| memory | Past patterns, decisions |
| serena | Code analysis, symbol finding |

## Output Format

```
THINKER ANALYSIS

Task: [description]

Research: [findings from docs/web]

Files Affected:
- [file]: [why]

Plan:
1. [step]
2. [step]

Risks:
- [risk]: [mitigation]

Ready for Builder.
```

## Guidelines

- Research when uncertain
- Check memory for similar past tasks
- Use serena to understand codebase
- Be specific about file locations
```

#### 3.3.2 File: agents/builder.md

```markdown
---
name: builder
description: Implementation agent. Builds, modifies, fixes code following plans.
model: opus
skills:
  - serena
  - frontend-design
  - TDD
---

# Builder Agent

Implement code following thinker's plan.

## Role

- Follow thinker's plan
- Implement changes
- Match existing code style
- Handle errors properly
- Quick self-verification

## Tools Available

| Tool | Use For |
|------|---------|
| serena | Code navigation, refactoring |
| frontend-design | UI/component creation |
| TDD | Test-driven implementation |

## Output Format

```
BUILDER IMPLEMENTATION

Following Thinker's plan...

Changes:
- [file]: [what changed]

Notes:
- [implementation notes]

Ready for Reviewer / Done.
```

## Guidelines

- Follow plan when available
- Match project code style
- Handle edge cases
- Don't over-engineer
```

#### 3.3.3 File: agents/reviewer.md

```markdown
---
name: reviewer
description: Verification agent. Tests, reviews, ensures quality.
model: sonnet
skills:
  - code-review
  - TDD
  - chrome-devtools
---

# Reviewer Agent

Verify implementation meets requirements.

## Role

- Verify requirements met
- Run tests
- Check edge cases
- Review code quality
- Ensure production-ready

## Tools Available

| Tool | Use For |
|------|---------|
| code-review | Quality review |
| TDD | Test verification |
| chrome-devtools | Browser testing |

## Output Format

```
REVIEWER VERIFICATION

Requirements:
- [req 1]: PASS/FAIL
- [req 2]: PASS/FAIL

Tests: [count] run
- [test]: PASS/FAIL

Quality:
- Code style: OK
- Error handling: OK

Result: PASSED / FAILED

[Notes if any]
```

## Quality Gates

1. Requirements met
2. Tests pass
3. No regressions
4. Code quality acceptable
```

### 3.4 Data Structures

#### 3.4.1 File: .dev-stacks/state.json

```json
{
  "version": "1.0.0",
  "session_id": "sess-abc123",
  "timestamp": "2026-03-19T15:30:00Z",

  "task": {
    "original_prompt": "เพิ่ม JWT auth ใน API",
    "intent": "ADD_FEATURE",
    "domain": "backend",
    "complexity": 0.55
  },

  "workflow": {
    "type": "careful",
    "agents": ["thinker", "builder", "reviewer"],
    "current_phase": "THINKING",
    "progress": 33
  },

  "results": {
    "thinker": {
      "status": "completed",
      "plan": ["Create JWT utility", "Add middleware", "Test"],
      "files_affected": ["src/auth/jwt.ts", "middleware/auth.ts"]
    },
    "builder": {
      "status": "in_progress"
    },
    "reviewer": {
      "status": "pending"
    }
  },

  "context": {
    "files_touched": [],
    "decisions_made": [],
    "patterns_used": []
  }
}
```

#### 3.4.2 File: .dev-stacks/registry.json

```json
{
  "version": "1.0.0",

  "mcp_servers": [
    "serena",
    "context7",
    "memory",
    "web_reader",
    "fetch",
    "chrome-devtools",
    "doc-forge",
    "filesystem"
  ],

  "skills": {
    "planning": ["brainstorming", "writing-plans"],
    "implementation": ["frontend-design", "TDD"],
    "verification": ["code-review", "simplify"],
    "git": ["dev-commit"]
  },

  "intent_categories": {
    "FIX_BUG": {
      "keywords": ["bug", "error", "fix", "crash", "แก้", "ซ่อม", "ไม่ได้"],
      "domains": ["backend", "frontend"],
      "workflow_modifier": 0.1
    },
    "ADD_FEATURE": {
      "keywords": ["add", "create", "implement", "new", "เพิ่ม", "สร้าง"],
      "domains": ["frontend", "backend"],
      "workflow_modifier": 0.15
    },
    "MODIFY": {
      "keywords": ["change", "update", "modify", "เปลี่ยน", "แก้ไข"],
      "domains": ["general"],
      "workflow_modifier": 0.05
    },
    "RESEARCH": {
      "keywords": ["find", "search", "docs", "explain", "หา", "อธิบาย"],
      "domains": ["general"],
      "workflow_modifier": -0.1
    },
    "TEST": {
      "keywords": ["test", "verify", "check", "ทดสอบ"],
      "domains": ["testing"],
      "workflow_modifier": 0.0
    },
    "COMMIT": {
      "keywords": ["commit", "push", "merge", "PR"],
      "domains": ["git"],
      "workflow_modifier": -0.2
    }
  },

  "domain_indicators": {
    "frontend": ["UI", "component", "page", "react", "css", "หน้า", "ปุ่ม"],
    "backend": ["API", "endpoint", "server", "database", "auth", "ฐานข้อมูล"],
    "testing": ["test", "spec", "verify", "ทดสอบ"],
    "security": ["auth", "login", "token", "password", "security"]
  },

  "complexity_factors": {
    "keywords": {
      "high": ["payment", "auth", "security", "database", "migration"],
      "medium": ["refactor", "API", "integration"],
      "low": ["typo", "comment", "style"]
    },
    "file_count": {
      "single": 0.0,
      "few": 0.1,
      "many": 0.2
    }
  }
}
```

### 3.5 CLAUDE.md Integration

#### 3.5.1 File: CLAUDE.md (project root)

```markdown
# Project Conventions

## Build Commands
- `npm run dev` - Start development server
- `npm run build` - Production build
- `npm test` - Run tests

## Code Style
- Use TypeScript strict mode
- Follow existing patterns
- Handle errors explicitly

## Dev-Stacks Integration

This project uses dev-stacks plugin for workflow automation.

### Available Commands
- `/dev-stacks:run` - Execute workflow (auto-selects based on complexity)
- `/dev-stacks:research` - Research only
- `/dev-stacks:implement` - Implementation only
- `/dev-stacks:review` - Review only
- `/dev-stacks:team` - Agent team for complex tasks

### Workflow Selection
- Complexity < 0.2: Direct implementation
- 0.2-0.39: thinker → builder
- 0.4-0.59: thinker → builder → reviewer
- >= 0.6: Agent team (lead + reviewers)
```

---

## 4. Workflow Specifications

### 4.1 Quick Workflow (< 0.2)

```
Trigger: complexity < 0.2

Flow:
USER → HOOK → AI implements directly

Output:
[DEV-STACKS] FIX_TYPO | general | complexity: 0.1
Workflow: quick | Implement directly

No subagents spawned.
```

### 4.2 Standard Workflow (0.2-0.39)

```
Trigger: 0.2 <= complexity < 0.4

Flow:
USER → HOOK → /dev-stacks:run
                ↓
        Spawn THINKER (analyze, plan)
                ↓
        THINKER returns plan
                ↓
        Spawn BUILDER (implement)
                ↓
        BUILDER returns changes
                ↓
        Summary to main context

Output:
[DEV-STACKS] ADD_FEATURE | frontend | complexity: 0.35
Workflow: standard | Invoke: /dev-stacks:run

After /dev-stacks:run:
THINKER: Plan created (3 steps)
BUILDER: Implemented (2 files modified)
Done. Changes: src/Form.tsx, src/validations.ts
```

### 4.3 Careful Workflow (0.4-0.59)

```
Trigger: 0.4 <= complexity < 0.6

Flow:
USER → HOOK → /dev-stacks:run
                ↓
        Spawn THINKER (analyze, plan, risks)
                ↓
        THINKER returns plan + risks
                ↓
        Spawn BUILDER (implement)
                ↓
        BUILDER returns changes
                ↓
        Spawn REVIEWER (verify)
                ↓
        REVIEWER returns results
                ↓
        Summary to main context

Output:
[DEV-STACKS] ADD_FEATURE | backend | complexity: 0.55
Workflow: careful | Invoke: /dev-stacks:run

After /dev-stacks:run:
THINKER: Plan created (4 steps), 2 risks identified
BUILDER: Implemented (3 files modified)
REVIEWER: PASSED (5 tests run, all pass)
Done. Changes: src/auth/jwt.ts, middleware/auth.ts, tests/auth.test.ts
```

### 4.4 Full Workflow (>= 0.6)

```
Trigger: complexity >= 0.6

Flow:
USER → HOOK → /dev-stacks:team
                ↓
        Create AGENT TEAM
        ├── LEAD (coordinate)
        ├── SECURITY REVIEWER
        ├── PERFORMANCE REVIEWER
        └── TESTING REVIEWER
                ↓
        Lead breaks down task
                ↓
        Reviewers claim subtasks
                ↓
        Parallel work with coordination
                ↓
        Lead integrates results
                ↓
        Summary to main context

Output:
[DEV-STACKS] ADD_FEATURE | backend | complexity: 0.75
Workflow: full | Invoke: /dev-stacks:team

After /dev-stacks:team:
LEAD: Task broken into 5 subtasks
SECURITY: Reviewed auth flow (2 issues found, fixed)
PERFORMANCE: Reviewed queries (optimized 3)
TESTING: Added 12 tests (all pass)
Done. Payment system implemented with 3 providers.
```

---

## 5. File Structure

### 5.1 Complete Directory Tree

```
dev-stacks/
├── .claude-plugin/
│   └── plugin.json
│
├── hooks/
│   ├── hooks.json
│   └── prompt-enhancer.sh
│
├── skills/
│   ├── run/
│   │   └── SKILL.md
│   ├── team/
│   │   └── SKILL.md
│   ├── research/
│   │   └── SKILL.md
│   ├── implement/
│   │   └── SKILL.md
│   └── review/
│       └── SKILL.md
│
├── agents/
│   ├── thinker.md
│   ├── builder.md
│   └── reviewer.md
│
├── .dev-stacks/
│   ├── state.json
│   └── registry.json
│
├── CLAUDE.md
│
└── docs/
    └── me.md
```

### 5.2 plugin.json

```json
{
  "name": "dev-stacks",
  "version": "2.0.0",
  "description": "Full-featured Claude Code plugin with hooks, skills, subagents, and agent teams",
  "author": {
    "name": "User"
  }
}
```

### 5.3 hooks.json

```json
{
  "UserPromptSubmit": [{
    "hooks": [{
      "type": "command",
      "command": "bash ${CLAUDE_PLUGIN_ROOT}/hooks/prompt-enhancer.sh",
      "timeout": 5000
    }]
  }]
}
```

---

## 6. Implementation Checklist

### 6.1 Phase 1: Hook Layer

- [ ] Create `hooks/prompt-enhancer.sh`
- [ ] Implement intent classification
- [ ] Implement complexity calculation
- [ ] Implement state writing
- [ ] Test hook output

### 6.2 Phase 2: Skill Layer

- [ ] Create `skills/run/SKILL.md`
- [ ] Create `skills/team/SKILL.md`
- [ ] Create `skills/research/SKILL.md`
- [ ] Create `skills/implement/SKILL.md`
- [ ] Create `skills/review/SKILL.md`
- [ ] Test skill invocation

### 6.3 Phase 3: Subagent Layer

- [ ] Create `agents/thinker.md`
- [ ] Create `agents/builder.md`
- [ ] Create `agents/reviewer.md`
- [ ] Test subagent spawning
- [ ] Test subagent isolation

### 6.4 Phase 4: Agent Team Layer

- [ ] Test team creation
- [ ] Test task distribution
- [ ] Test peer-to-peer messaging
- [ ] Test coordination

### 6.5 Phase 5: Integration

- [ ] Create registry.json
- [ ] Create state.json template
- [ ] Update CLAUDE.md
- [ ] Full integration test

---

## 7. Success Criteria

| Criteria | Target | Measurement |
|----------|--------|-------------|
| Feature utilization | 100% | All 6 features used |
| Token efficiency | < 1500 main | Main context token count |
| Context isolation | Yes | Subagent work isolated |
| Automation level | 80% | Auto-spawn subagents |
| Intent accuracy | > 80% | Classification tests |
| Workflow correctness | 100% | All workflows tested |

---

## 8. Expected Score

| Criteria | Score |
|----------|-------|
| Feature utilization | 10/10 |
| Token efficiency | 9/10 |
| Automation | 8/10 |
| Reliability | 9/10 |
| Maintainability | 9/10 |
| **Total** | **9.5/10** |

---

**Document Status:** DRAFT - Full Feature Architecture
**Next Steps:** Implement Phase 1 (Hook Layer)
