# Research: Dev-Stacks Plugin

**Feature**: 002-dev-stacks
**Created**: 2026-03-18
**Updated**: 2026-03-18
**Purpose**: Resolve technical unknowns and establish best practices

---

## Architecture Decision: Pure Markdown-First

**Decision**: Use Pure Markdown-First architecture - all intelligence driven by Claude through Markdown skills

**Rationale**:
- **Maximum Output Quality** - Claude's intelligence > hard-coded rules
- **Context Understanding** - Claude understands nuance, mixed language, context
- **Adaptive Decision Making** - Claude adjusts to each situation dynamically
- **Explainable** - Claude can explain reasoning to users
- **Simpler Deployment** - No build step, no TypeScript compilation
- **Easier Maintenance** - Edit Markdown files directly

**Alternatives Considered**:
- TypeScript + MCP Server: Faster execution but lower quality output
- Pure MCP Server: More complex, loses Claude's reasoning capability
- Hybrid approach: Unnecessary complexity for quality-focused goal

---

## Research Topics

### 1. Claude Code Plugin Architecture

**Decision**: Use Claude Code plugin system with `.claude-plugin/` directory structure

**Rationale**:
- Native integration with Claude Code
- Supports agents, skills, commands, hooks
- Auto-discovery mechanism built-in
- No external dependencies required

**Best Practices**:
- Place agents in `agents/` directory with YAML frontmatter
- Skills in `skills/` directory with SKILL.md naming
- Hooks as Markdown files in `hooks/` directory
- Commands as Markdown files in `commands/` directory

---

### 2. Intent Detection Approach

**Decision**: Claude-driven intent detection through Markdown skill

**Rationale**:
- **Superior Quality** - Claude understands context, nuance, mixed language
- **No Hard-coded Rules** - Adapts to new patterns naturally
- **Explainable** - Claude can explain why it detected a specific intent
- **Mixed Language Support** - Naturally handles Thai/English/mixed input

**Alternatives Considered**:
- Rule-based NLP (TypeScript): Faster but rigid, misses context
- Keyword matching: Too simplistic, high error rate
- LLM API call: Unnecessary latency, Claude already available

**Implementation**:
```markdown
# Intent Router Skill

## Detection Process

1. Analyze user input for action keywords
2. Identify target (file, function, module)
3. Extract context hints
4. Determine intent category

## Intent Categories

| Intent | Thai Keywords | English Keywords |
|--------|---------------|------------------|
| FIX_BUG | แก้, ซ่อม, ไม่ทำงาน | fix, repair, broken, error |
| ADD_FEATURE | เพิ่ม, สร้าง | add, create, implement, new |
| MODIFY_BEHAVIOR | เปลี่ยน, แก้ไข | change, modify, update |
| OPTIMIZE | เร็ว, ปรับปรุง | fast, optimize, improve |
| INVESTIGATE | ทำไม, หา, สาเหตุ | why, find, investigate |
| EXPLAIN | อธิบาย, ทำงานยังไง | explain, how |

## Output Format

Return intent as structured data:
- category: [Intent Category]
- target: [What to act on]
- description: [Original user input]
- language: [TH | EN | MIXED]
- context: [Relevant context hints]
```

---

### 3. Complexity Scoring Algorithm

**Decision**: Claude-driven complexity assessment through Markdown skill

**Rationale**:
- **Adaptive** - Claude adjusts scoring based on actual context
- **Context-aware** - Understands project-specific complexity
- **Explainable** - Claude can justify the score to users
- **Nuanced** - Factors beyond simple file counts

**Alternatives Considered**:
- Multi-factor weighted (TypeScript): Rigid formula, misses context
- ML-based: Overkill, requires training
- Lines of code: Poor correlation

**Implementation**:
```markdown
# Complexity Scorer Skill

## Assessment Factors

Evaluate these factors based on task description:

1. **Files Affected** (consider impact)
   - Single file → Low
   - Multiple related files → Medium
   - Cross-cutting changes → High

2. **Risk Level** (consider consequences)
   - UI/Display changes → Low
   - Business logic → Medium
   - Auth/Payment/Data → High

3. **Dependencies** (consider ripple effects)
   - Isolated change → Low
   - Affects few modules → Medium
   - System-wide impact → High

4. **Reversibility** (consider recovery)
   - Easy to revert → Low
   - Requires migration → Medium
   - Breaking changes → High

## Total Score → Workflow

- 0.0-0.19 → QUICK (Builder only, no confirmation)
- 0.2-0.39 → STANDARD (Thinker + Builder)
- 0.4-0.59 → CAREFUL (Full team + preview)
- 0.6-1.0 → FULL (Full team + user approval required)

## Output Format

Return score with justification:
- score: [0.0-1.0]
- factors: [List of contributing factors]
- workflow: [QUICK | STANDARD | CAREFUL | FULL]
- reasoning: [Brief explanation]
```

---

### 4. Pattern Storage Strategy

**Decision**: MCP Memory (Knowledge Graph) for pattern storage

**Rationale**:
- **Semantic Matching** - Claude understands semantic similarity
- **Native Integration** - MCP Memory is built-in
- **Structured Storage** - Entities with observations
- **Queryable** - Can search by keywords, relationships

**Alternatives Considered**:
- SQLite: Faster queries but requires TypeScript server
- JSON files: No query capability
- Vector DB: Overkill for local plugin

**Implementation**:
```markdown
# Pattern Memory Skill

## Storage: MCP Memory Knowledge Graph

Patterns are stored as entities:
- Entity name: "Pattern: [pattern-name]"
- Entity type: "dev-stacks-pattern"
- Observations:
  - trigger_keywords: [keywords that activate pattern]
  - solution_steps: [step-by-step instructions]
  - code_example: [optional code template]
  - use_count: [number of times used]
  - success_count: [successful uses]
  - confidence: [success / total]

## Pattern Matching Process

1. Search MCP Memory for patterns matching keywords
2. Claude evaluates semantic similarity
3. Return patterns with confidence > 0.5
4. Sort by relevance and confidence

## Pattern Lifecycle

- Created: When user saves successful task as pattern
- Updated: After each use (increment counts)
- Deleted: When confidence < 0.3 and unused > 30 days
```

**MCP Memory Tools Used**:
- `create_entities` - Store new pattern
- `search_nodes` - Find matching patterns
- `add_observations` - Update use/success counts
- `delete_entities` - Remove low-confidence patterns

---

### 5. Guard Implementation

**Decision**: Claude-driven guard skills with pattern matching

**Rationale**:
- **Explainable** - Claude can explain why action was blocked
- **Context-aware** - Understands when to be strict vs lenient
- **Adaptive** - Can adjust based on project context
- **Configurable** - Rules in JSON config files

**Alternatives Considered**:
- TypeScript regex: Faster but rigid, no explanation
- External security tool: Overkill
- No guards: Unsafe

**Implementation**:
```markdown
# Scope Guard Skill

## Protected Paths

**ALWAYS BLOCK** (cannot override):
- .env* (environment secrets)
- *.pem, *.key (certificates/keys)
- .git/ (version control)
- credentials*, secrets* (obvious secret files)

**REQUIRE CONFIRMATION**:
- package.json, package-lock.json (dependencies)
- tsconfig.json, *.config.* (configuration)
- migrations/, schema.* (database)

## Guard Process

1. Before file edit/write operation
2. Check file path against protected patterns
3. If ALWAYS BLOCK → Show warning, suggest manual edit
4. If REQUIRE CONFIRM → Ask user for confirmation
5. Log decision in audit trail

## Output Format

- action: [ALLOW | BLOCK | CONFIRM]
- reason: [Explanation]
- suggestion: [Alternative action if blocked]
```

**Similar skills for**:
- `secret-scanner` - Detect secrets in content
- `bash-guard` - Filter dangerous commands

---

### 6. Agent Communication Pattern

**Decision**: Sequential skill invocation with context passing via conversation

**Rationale**:
- **Simple** - No complex coordination mechanism
- **Natural** - Follows conversation flow
- **Debuggable** - Each step visible in conversation
- **Context Preserved** - Claude maintains context between steps

**Alternatives Considered**:
- Parallel agents: Coordination overhead, context sharing issues
- Subagent spawning: More complex, harder to debug

**Flow**:
```
User Input
    │
    ▼
┌─────────────────────────────────────────────┐
│ UserPromptSubmit Hook                        │
│   → Invoke intent-router skill               │
│   → Invoke complexity-scorer skill           │
│   → Invoke team-selector skill               │
└─────────────────────────────────────────────┘
    │
    ▼ (if complexity >= 0.2)
┌─────────────────────────────────────────────┐
│ Thinker Agent                                │
│   → Analyze task                             │
│   → Create implementation plan               │
│   → Identify files to modify                 │
└─────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────┐
│ Builder Agent                                │
│   → Implement changes                        │
│   → Follow Thinker's plan                    │
└─────────────────────────────────────────────┘
    │
    ▼ (if complexity >= 0.4)
┌─────────────────────────────────────────────┐
│ Tester Agent                                 │
│   → Verify implementation                    │
│   → Run tests if available                   │
│   → Report results                           │
└─────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────┐
│ PostToolUse Hook                             │
│   → Log to audit trail                       │
│   → Ask to save as pattern if successful     │
└─────────────────────────────────────────────┘
```

**Context Passing**: Via Claude's conversation context - no explicit state management needed

---

### 7. Checkpoint & Recovery

**Decision**: JSON checkpoint files via MCP Filesystem + Git integration

**Rationale**:
- **Git provides reliable version control**
- **JSON is human-readable and debuggable**
- **MCP Filesystem is built-in**
- **Can recover even if plugin crashes**

**Alternatives Considered**:
- In-memory only: Lost on crash
- Full git branch per task: Too much overhead
- SQLite: Overkill for simple checkpoint storage

**Implementation**:
```markdown
# Checkpoint Skill

## Storage: MCP Filesystem

File: .dev-stack/checkpoint.json

{
  "session_id": "uuid",
  "timestamp": "ISO-8601",
  "state": {
    "phase": "idle | thinking | building | testing",
    "current_task": "task description",
    "progress": 0-100
  },
  "context": {
    "files_touched": ["file1.ts", "file2.ts"],
    "decisions_made": [
      {"question": "...", "answer": "...", "reason": "..."}
    ]
  },
  "recovery": {
    "base_commit": "git-sha",
    "undo_stack": [
      {
        "timestamp": "ISO-8601",
        "action": "Edit file.ts",
        "files_modified": ["file.ts"],
        "git_diff": "diff content"
      }
    ]
  }
}

## Undo Process

1. Read checkpoint.json via MCP Filesystem
2. Display preview of changes to revert
3. Ask user confirmation
4. Use git to revert changes (git checkout or git stash)
5. Update checkpoint.json
```

**Undo Levels**:
- `action` - Undo last action
- `phase` - Undo entire phase (think/build/test)
- `checkpoint` - Restore to last checkpoint
- `commit` - `git reset --hard` to base commit

---

### 8. Multi-Language Support

**Decision**: Claude-native language understanding (no detection code needed)

**Rationale**:
- **Claude naturally understands** Thai, English, and mixed input
- **No detection algorithm needed** - Claude handles this implicitly
- **No keyword mapping needed** - Claude understands semantic meaning

**Alternatives Considered**:
- TypeScript keyword mapping: Rigid, misses context
- Language detection + translation: Unnecessary complexity

**Implementation**:
```markdown
# Language Handling in Intent Router Skill

## Approach

Claude naturally understands input in any language. No explicit language
detection or keyword mapping is required.

Simply analyze the user's input and extract intent regardless of language.

## Examples Claude Handles Natively

| User Input | Claude Understands |
|------------|-------------------|
| "แก้ typo ใน README" | FIX_BUG, target: README.md |
| "Fix the login validation" | FIX_BUG, target: login validation |
| "แก้ login flow ตรง session timeout" | FIX_BUG, target: session timeout in login flow |
| "Add validation ในฟอร์ม register" | ADD_FEATURE, target: register form validation |

## Output

Include detected language for statistics:
- language: [TH | EN | MIXED]
```

Claude determines language by character analysis automatically.

---

## Technology Stack Decisions

### Plugin Core (Pure Markdown)
| Component | Technology | Reason |
|-----------|------------|--------|
| Plugin System | Claude Code native | Best integration |
| Agents | Markdown + YAML frontmatter | Native format |
| Skills | Markdown | Progressive disclosure |
| Hooks | Markdown | Event-driven |
| Commands | Markdown | User-facing |

### Data Layer (MCP Tools)
| Component | Technology | Reason |
|-----------|------------|--------|
| Pattern Storage | MCP Memory (Knowledge Graph) | Semantic search, built-in |
| Checkpoints | MCP Filesystem (JSON) | Human-readable |
| DNA | MCP Filesystem (JSON) | Human-readable |
| Configuration | MCP Filesystem (JSON) | Simple, editable |

### Intelligence Layer (Claude-Driven)
| Component | Technology | Reason |
|-----------|------------|--------|
| Intent Detection | Claude (via skill) | Context-aware, nuance understanding |
| Complexity Scoring | Claude (via skill) | Adaptive, explainable |
| Pattern Matching | Claude (via skill) | Semantic similarity |
| Guard Decisions | Claude (via skill) | Context-aware, explainable |

---

## Architecture Benefits

| Benefit | Description |
|---------|-------------|
| **Maximum Quality** | Claude's intelligence > hard-coded rules |
| **Simpler** | No build step, no TypeScript compilation |
| **Faster Development** | Edit Markdown files directly |
| **Explainable** | Claude can explain all decisions |
| **Adaptive** | Adjusts to context naturally |
| **Multi-language** | Native Thai/English/mixed support |

---

## Open Questions Resolved

| Question | Resolution |
|----------|------------|
| Pattern storage location | MCP Memory (Knowledge Graph) |
| DNA refresh trigger | On session start + manual via `/dev-stacks:doctor` |
| Undo levels | Keep last 20 actions (configurable) |
| Language detection | Claude-native (no code needed) |
| TypeScript utilities | Not needed - Claude provides intelligence |

---

## Next Steps

1. **Phase 1**: Update data-model.md for MCP-based storage
2. **Phase 1**: Update quickstart.md
3. **Phase 2**: Generate task list via `/speckit.tasks`
4. **Phase 2**: Begin implementation
