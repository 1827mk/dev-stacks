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

### Step 1: Quick Check

Is this a command?
- If starts with `/ds:` → Route to command handler
- If starts with `/` (other) → Pass through (not our command)

### Step 2: Intent Detection

Invoke intent-router skill:
- Analyze user input
- Extract category, target, context
- Determine language (TH/EN/MIXED)
- Calculate confidence

### Step 3: Complexity Scoring

Invoke complexity-scorer skill:
- Assess factors
- Calculate total score
- Determine workflow level

### Step 4: Team Selection

Invoke team-selector skill:
- Select agents based on workflow
- Determine execution order
- Check if confirmation needed

### Step 5: Display Plan

Show user what will happen:
```
🎯 Intent: [CATEGORY] | Target: [TARGET]
📊 Complexity: [SCORE] ([WORKFLOW])
👥 Team: [AGENTS]
⚡ [Proceeding / Proceeding in 3s...]
```

### Step 6: Execute or Confirm

If FULL workflow:
- Wait for user confirmation
- On confirm, invoke agents

Otherwise:
- Auto-proceed after short delay
- Invoke agents in order

## Output Examples

### Quick Task
```
🎯 Intent: FIX_BUG | Target: README.md
📊 Complexity: 0.1 (Quick)
👥 Team: [Builder]
⚡ Proceeding...

🛠️ Builder: Fixing typo...
✅ Fixed: "intallation" → "installation" in README.md:23
```

### Standard Task
```
🎯 Intent: ADD_FEATURE | Target: login form validation
📊 Complexity: 0.35 (Standard)
👥 Team: [Thinker, Builder]
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
🎯 Intent: ADD_FEATURE | Target: payment processing
📊 Complexity: 0.72 (Full)
👥 Team: [Thinker, Builder, Tester]

⚠️ This task requires confirmation due to high complexity.
   Risk: Payment processing affects critical business logic

   Proceed? [Y/n]
```

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `mcp__memory__search_nodes` | Find relevant patterns |
| `mcp__filesystem__read_text_file` | Read project files |

## Pattern Matching

Before processing, check for relevant patterns:
- Search MCP Memory for patterns matching keywords
- If pattern found with high confidence, suggest it

```
📚 Found relevant pattern:
   "Form Validation Pattern" (confidence: 0.92)
   Last used: 2 days ago | Used 3 times

   Use this pattern? [Y/n]
```

## Notes

- This hook is the core of Dev-Stacks
- All user messages flow through here
- Invokes skills for detection, scoring, selection
- Agents are invoked in sequence after routing
