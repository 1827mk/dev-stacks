---
name: UserPromptSubmit
description: Route user input through intent detection, complexity scoring, and team selection.
---

# UserPromptSubmit Hook

Executed when user submits a message.

## Purpose

Process user input through the Dev-Stacks pipeline:
1. Detect intent (what user wants)
2. Score complexity (how hard is it)
3. Select team (which agents)
4. Route to appropriate workflow

## Execution Steps

### Step 1: Quick Check + LOG

**ALWAYS OUTPUT:**
```
🔍 [DEV-STACKS] Processing user input...
```

Is this a command?
- If starts with `/dev-stacks:` → Route to command handler
- If starts with `/` (other) → Pass through (not our command)

### Step 2: Intent Detection + LOG

Invoke intent-router skill:
- Analyze user input
- Extract category, target, context
- Determine language (TH/EN/MIXED)
- Calculate confidence

**LOG OUTPUT:**
```
🔍 [DEV-STACKS] Step 1/4: Intent Detection
   └─ Category: FIX_BUG
   └─ Target: README.md
   └─ Language: TH
   └─ Confidence: 0.92
```

### Step 3: Complexity Scoring + LOG

Invoke complexity-scorer skill:
- Assess factors
- Calculate total score
- Determine workflow level

**LOG OUTPUT:**
```
🔍 [DEV-STACKS] Step 2/4: Complexity Scoring
   └─ Score: 0.12
   └─ Workflow: Quick
   └─ Factors: Simple edit (0.1), No dependencies (0.0), Low risk (0.02)
```

### Step 4: Team Selection + LOG

Invoke team-selector skill:
- Select agents based on workflow
- Determine execution order
- Check if confirmation needed

**LOG OUTPUT:**
```
🔍 [DEV-STACKS] Step 3/4: Team Selection
   └─ Agents: [Builder]
   └─ Order: Builder → Done
   └─ Confirmation: No
```

### Step 5: Pattern Check + LOG

**LOG OUTPUT:**
```
🔍 [DEV-STACKS] Step 4/4: Pattern Check
   └─ Patterns found: 0
   └─ Using: Default approach
```

Or if pattern found:
```
🔍 [DEV-STACKS] Step 4/4: Pattern Check
   └─ Patterns found: 1
   └─ Best match: "Form Validation Pattern" (0.92)
```

### Step 6: Display Plan + LOG

**FINAL LOG:**
```
🚀 [DEV-STACKS] Routing Complete!
   ┌─────────────────────────────────────────┐
   │ Intent:    FIX_BUG                      │
   │ Target:    README.md                    │
   │ Workflow:  Quick (0.12)                 │
   │ Team:      [Builder]                    │
   │ Confirm:   No                           │
   └─────────────────────────────────────────┘
   ⚡ Proceeding...
```

### Step 7: Execute or Confirm

If FULL workflow:
- Wait for user confirmation
- On confirm, invoke agents

Otherwise:
- Auto-proceed after short delay
- Invoke agents in order

## Output Examples

### Quick Task
```
🔍 [DEV-STACKS] Processing user input...
🔍 [DEV-STACKS] Step 1/4: Intent Detection
   └─ Category: FIX_BUG | Target: README.md | Confidence: 0.92
🔍 [DEV-STACKS] Step 2/4: Complexity Scoring
   └─ Score: 0.12 | Workflow: Quick
🔍 [DEV-STACKS] Step 3/4: Team Selection
   └─ Agents: [Builder]
🔍 [DEV-STACKS] Step 4/4: Pattern Check
   └─ No relevant patterns found

🚀 [DEV-STACKS] Routing Complete!
   │ Intent: FIX_BUG | Target: README.md
   │ Workflow: Quick | Team: [Builder]
   ⚡ Proceeding...

🛠️ Builder: Fixing typo...
✅ Fixed: "intallation" → "installation" in README.md:23
```

### Standard Task
```
🔍 [DEV-STACKS] Processing user input...
🔍 [DEV-STACKS] Step 1/4: Intent Detection
   └─ Category: ADD_FEATURE | Target: login form | Confidence: 0.88
🔍 [DEV-STACKS] Step 2/4: Complexity Scoring
   └─ Score: 0.35 | Workflow: Standard
🔍 [DEV-STACKS] Step 3/4: Team Selection
   └─ Agents: [Thinker, Builder]
🔍 [DEV-STACKS] Step 4/4: Pattern Check
   └─ Found: "Form Validation Pattern" (0.85)

🚀 [DEV-STACKS] Routing Complete!
   │ Intent: ADD_FEATURE | Target: login form validation
   │ Workflow: Standard | Team: [Thinker, Builder]
   ⚡ Proceeding in 3s...

🧠 Thinker: Analyzing...
   - Found: src/components/LoginForm.tsx
   - Approach: Add email validation regex

🛠️ Builder: Implementing...
   - Added email validation
   - Updated error messages

✅ Done!
```

### Full Task (Requires Confirmation)
```
🔍 [DEV-STACKS] Processing user input...
🔍 [DEV-STACKS] Step 1/4: Intent Detection
   └─ Category: ADD_FEATURE | Target: payment | Confidence: 0.75
🔍 [DEV-STACKS] Step 2/4: Complexity Scoring
   └─ Score: 0.72 | Workflow: Full
🔍 [DEV-STACKS] Step 3/4: Team Selection
   └─ Agents: [Thinker, Builder, Tester] + Confirmation Required
🔍 [DEV-STACKS] Step 4/4: Pattern Check
   └─ No patterns for payment integration

🚀 [DEV-STACKS] Routing Complete!
   │ Intent: ADD_FEATURE | Target: payment processing
   │ Workflow: Full | Team: [Thinker, Builder, Tester]
   │ ⚠️ Confirmation Required

⚠️ This task requires confirmation due to high complexity.
   Risk: Payment processing affects critical business logic

   Proceed? [Y/n]
```

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `mcp__memory__search_nodes` | Find relevant patterns |
| `mcp__filesystem__read_text_file` | Read project files |

## Notes

- This hook is the core of Dev-Stacks
- All user messages flow through here
- **ALWAYS LOG** each step for debugging
- Invokes skills for detection, scoring, selection
- Agents are invoked in sequence after routing
