---
name: dna-builder
description: Build and update Project DNA - the accumulated knowledge about your codebase. Use on first run, when project structure changes, or to learn from successful tasks.
---

# DNA Builder

Builds and maintains Project DNA - the accumulated knowledge about your codebase.

## Purpose

Create and update the project's "genetic code":
- Project identity (type, languages, frameworks)
- Architecture mapping
- Pattern detection
- Risk area identification
- Learning from usage
- Metrics tracking

## Storage

**File**: `.dev-stacks/dna.json`

---

## DNA Structure (Complete)

```json
{
  "version": "1.0.0",
  "created": "2026-03-18T10:00:00Z",
  "updated": "2026-03-18T15:30:00Z",
  "identity": {
    "name": "my-project",
    "type": "FULLSTACK | FRONTEND | BACKEND | LIBRARY | CLI | MOBILE | MONOREPO",
    "languages": ["TypeScript", "JavaScript"],
    "frameworks": ["React", "Express"],
    "build_tools": ["npm", "vite"],
    "testing": ["Jest", "React Testing Library"],
    "package_manager": "npm | yarn | pnpm | bun"
  },
  "architecture": {
    "structure": {
      "name": "src",
      "type": "DIRECTORY",
      "purpose": "Source code",
      "children": [
        {
          "name": "components",
          "type": "DIRECTORY",
          "purpose": "React components",
          "children": []
        },
        {
          "name": "services",
          "type": "DIRECTORY",
          "purpose": "API services",
          "children": []
        }
      ]
    },
    "entry_points": [
      {"path": "src/index.tsx", "type": "FRONTEND"},
      {"path": "src/server.ts", "type": "BACKEND"}
    ],
    "key_modules": [
      {
        "path": "src/auth",
        "exports": ["login", "logout", "validateToken"],
        "purpose": "Authentication logic",
        "risk_level": "CRITICAL",
        "dependencies": ["jsonwebtoken", "bcrypt"]
      },
      {
        "path": "src/payment",
        "exports": ["processPayment", "refund"],
        "purpose": "Payment processing",
        "risk_level": "CRITICAL",
        "dependencies": ["stripe"]
      }
    ],
    "config_files": [
      {"path": "tsconfig.json", "purpose": "TypeScript configuration"},
      {"path": "vite.config.ts", "purpose": "Build configuration"}
    ]
  },
  "patterns": {
    "naming_conventions": {
      "components": "PascalCase",
      "functions": "camelCase",
      "files": "kebab-case",
      "constants": "SCREAMING_SNAKE_CASE",
      "types": "PascalCase"
    },
    "file_organization": "FEATURE_BASED | LAYERED | MIXED",
    "testing_strategy": "UNIT | INTEGRATION | E2E | MIXED",
    "common_imports": [
      {"name": "react", "frequency": 50},
      {"name": "express", "frequency": 30},
      {"name": "zod", "frequency": 15}
    ],
    "code_style": {
      "prefer_const": true,
      "prefer_arrow_functions": true,
      "use_types": true
    }
  },
  "risk_areas": {
    "paths": ["src/auth", "src/payment", "src/users"],
    "details": {
      "src/auth": {
        "reason": "Authentication logic",
        "severity": "CRITICAL",
        "guards": ["NEEDS_CONFIRMATION", "NEEDS_TESTER"]
      },
      "src/payment": {
        "reason": "Payment processing",
        "severity": "CRITICAL",
        "guards": ["NEEDS_CONFIRMATION", "NEEDS_TESTER", "NEEDS_FULL_WORKFLOW"]
      },
      "src/users": {
        "reason": "User data handling (PII)",
        "severity": "HIGH",
        "guards": ["NEEDS_CONFIRMATION"]
      }
    }
  },
  "learned": {
    "common_tasks": [
      {"description": "Add form validation", "frequency": 5, "last_used": "2026-03-18T15:00:00Z"},
      {"description": "Create API endpoint", "frequency": 3, "last_used": "2026-03-18T14:00:00Z"},
      {"description": "Refactor component", "frequency": 2, "last_used": "2026-03-18T10:00:00Z"}
    ],
    "preferences": {
      "test_first": false,
      "use_types": true,
      "prefer_functional": true,
      "verbose_logging": false
    },
    "successful_patterns": [
      {"name": "Form Validation Pattern", "confidence": 0.92, "uses": 5},
      {"name": "CRUD API Pattern", "confidence": 0.85, "uses": 3}
    ],
    "avoided_patterns": [
      {"name": "Global State Pattern", "reason": "Prefer context/props"}
    ]
  },
  "metrics": {
    "total_files": 150,
    "source_files": 120,
    "test_files": 30,
    "lines_of_code": 15000,
    "complexity_score": 0.45,
    "test_coverage": 0.72,
    "documentation_coverage": 0.35
  },
  "git": {
    "main_branch": "main",
    "current_branch": "feature/auth",
    "last_commit": "abc123def456",
    "uncommitted_changes": false
  }
}
```

---

## Operations

### 1. Build Initial DNA

**Trigger**: First run (no DNA exists)

**Process**:

```
┌─────────────────┐
│  Scan Root      │ ← List all files/directories
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Detect Type    │ ← Identify project type
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Map Structure  │ ← Build directory tree
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Analyze Files  │ ← Find patterns, conventions
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Identify Risks │ ← Find auth, payment, etc.
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Calc Metrics   │ ← Count files, LOC, etc.
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Save DNA       │ ← Write to .dev-stacks/dna.json
└─────────────────┘
```

---

### 2. Update DNA

**Trigger**: After successful task completion

**Process**:
1. Read existing DNA
2. Update `learned.common_tasks` (increment frequency)
3. Update `learned.preferences` (if detected)
4. Update `learned.successful_patterns` (if pattern used)
5. Update `metrics` (files touched, etc.)
6. Update `git` info
7. Save updated DNA

---

### 3. Refresh DNA

**Trigger**:
- DNA age > 7 days
- Git branch change detected
- User request: `/dev-stacks:doctor --refresh-dna`
- Large structural changes detected

**Process**:
1. Full rescan of project
2. Merge with existing `learned` data (preserve)
3. Update all sections
4. Save refreshed DNA

---

## Detection Rules

### Project Type Detection

| Signals | Project Type |
|---------|--------------|
| `package.json` + `index.html` + React imports | FRONTEND |
| `package.json` + `server.ts` / `app.ts` | BACKEND |
| `package.json` + both frontend & backend signals | FULLSTACK |
| `lib/` + `index.ts` + exports | LIBRARY |
| `bin/` + shebang + CLI framework | CLI |
| `android/` + `ios/` | MOBILE |
| `packages/` + multiple `package.json` | MONOREPO |

### Language Detection

| File Extension | Language |
|----------------|----------|
| `.ts`, `.tsx` | TypeScript |
| `.js`, `.jsx` | JavaScript |
| `.py` | Python |
| `.go` | Go |
| `.rs` | Rust |
| `.java` | Java |
| `.kt`, `.kts` | Kotlin |
| `.swift` | Swift |
| `.rb` | Ruby |
| `.php` | PHP |

### Framework Detection (from package.json)

| Dependency | Framework |
|------------|-----------|
| `react` | React |
| `vue` | Vue |
| `svelte` | Svelte |
| `angular` | Angular |
| `express` | Express |
| `fastify` | Fastify |
| `nestjs` | NestJS |
| `next` | Next.js |
| `nuxt` | Nuxt |
| `remix` | Remix |
| `django` | Django |
| `fastapi` | FastAPI |
| `flask` | Flask |

### Risk Area Detection

| Pattern | Severity | Guards Applied |
|---------|----------|----------------|
| `auth/`, `authentication/`, `login/` | CRITICAL | NEEDS_CONFIRMATION, NEEDS_TESTER |
| `payment/`, `checkout/`, `billing/` | CRITICAL | NEEDS_CONFIRMATION, NEEDS_TESTER, NEEDS_FULL_WORKFLOW |
| `user/`, `users/`, `account/` | HIGH | NEEDS_CONFIRMATION |
| `api/`, `routes/`, `controllers/` | MEDIUM | Extra logging |
| `config/`, `settings/`, `env/` | MEDIUM | NEEDS_CONFIRMATION |
| `database/`, `db/`, `models/` | MEDIUM | NEEDS_CONFIRMATION |
| `utils/`, `helpers/`, `lib/` | LOW | None |

### Naming Convention Detection

| File Pattern | Convention Detected |
|--------------|---------------------|
| `ComponentName.tsx` | PascalCase components |
| `component-name.tsx` | kebab-case files |
| `useHookName.ts` | camelCase hooks |
| `CONSTANT_NAME.ts` | SCREAMING_SNAKE_CASE |
| `TypeName.ts` | PascalCase types |

### Testing Strategy Detection

| Signals | Strategy |
|---------|----------|
| `*.test.ts`, `*.spec.ts` | Unit tests |
| `__tests__/` | Jest convention |
| `*.e2e.ts`, `playwright.config.*` | E2E tests |
| `*.integration.test.*` | Integration tests |
| `cypress/` | Cypress E2E |
| `testing-library` | Component testing |

---

## Output Format

### Build Success

```
🧬 DNA BUILDER
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Scanning project structure...

✅ Project DNA Built:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 Identity:
   • Name: my-project
   • Type: FULLSTACK
   • Languages: TypeScript, JavaScript
   • Frameworks: React, Express
   • Build: npm, vite

🏗️ Architecture:
   • Entry points: 2 (frontend + backend)
   • Key modules: 5 identified
   • Config files: 3

📐 Patterns:
   • Naming: PascalCase components, kebab-case files
   • Organization: Feature-based
   • Testing: Jest + RTL

⚠️ Risk Areas:
   • CRITICAL: src/auth (authentication)
   • CRITICAL: src/payment (payment processing)
   • HIGH: src/users (PII handling)

📊 Metrics:
   • Files: 150 total (120 source, 30 tests)
   • LOC: ~15,000
   • Complexity: 0.45 (moderate)

💾 DNA saved to .dev-stacks/dna.json
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Update Success

```
🧬 DNA UPDATED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📚 Learned patterns updated:
   • +1 "Add form validation" (now: 5 uses)
   • Pattern "Form Validation" confidence: 0.92

📊 Metrics updated:
   • Files touched: +2
   • Tasks completed: +1

💾 DNA saved.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Refresh Required

```
🧬 DNA REFRESH NEEDED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️ DNA is stale (7 days old)

Changes detected:
   • New directory: src/features/
   • New files: 12
   • New dependencies: stripe
   • Branch changed: main → feature/auth

Run /dev-stacks:doctor --refresh-dna to update.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Refresh Complete

```
🧬 DNA REFRESHED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Full rescan complete.

Changes:
   ✓ New module detected: src/features/
   ✓ New dependency: stripe
   ✓ New risk area: src/payment (CRITICAL)
   ✓ Metrics updated

Preserved:
   • 5 learned patterns
   • User preferences
   • 3 successful patterns

💾 DNA saved.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Error Handling

### Scan Failed

```
🧬 DNA BUILDER ERROR
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
❌ Failed to scan project structure

Error: Permission denied accessing node_modules/

Options:
   1. Retry with elevated permissions
   2. Create minimal DNA (skip node_modules)
   3. Skip DNA build for this session

Reply with 1, 2, or 3.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Invalid DNA File

```
🧬 DNA CORRUPTED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
❌ Existing DNA file is corrupted

File: .dev-stacks/dna.json
Error: Invalid JSON at line 42

Options:
   1. Backup corrupted file and rebuild DNA
   2. Attempt to repair (may lose data)
   3. Keep corrupted file and skip

Reply with 1, 2, or 3.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Empty Project

```
🧬 DNA BUILDER
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️ Empty project detected

No source files found in current directory.

Options:
   1. Initialize new project structure
   2. Point to correct directory
   3. Skip DNA build

Reply with 1, 2, or 3.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `mcp__filesystem__directory_tree` | Scan project structure |
| `mcp__filesystem__read_text_file` | Read package.json, configs |
| `mcp__filesystem__write_file` | Save DNA |
| `mcp__filesystem__get_file_info` | Check DNA existence/age |
| `mcp__filesystem__search_files` | Find specific file patterns |
| `mcp__memory__search_nodes` | Find learned patterns |
| `mcp__memory__add_observations` | Update learned data |

---

## Integration Points

| Component | How DNA is Used |
|-----------|-----------------|
| **Complexity Scorer** | Risk areas → higher complexity score |
| **Intent Router** | Common tasks → better intent detection |
| **Pattern Manager** | Learned patterns → suggestions |
| **Team Selector** | Risk areas → more agents selected |
| **Guards** | Risk areas → protected paths |
| **Workflows** | Risk severity → workflow selection |

---

## Configuration

From `config/defaults.json`:

```json
{
  "dna": {
    "auto_build": true,
    "refresh_interval_days": 7,
    "max_modules_tracked": 50,
    "learn_from_tasks": true,
    "preserve_learned_on_refresh": true,
    "scan_exclusions": [
      "node_modules",
      ".git",
      "dist",
      "build",
      "coverage"
    ]
  }
}
```

---

## Usage

### Automatic (SessionStart Hook)

```
SessionStart → Check DNA exists → If not, invoke dna-builder
```

### Manual (Command)

```
/dev-stacks:doctor --refresh-dna    # Full refresh
/dev-stacks:doctor --update-dna     # Update learned only
/dev-stacks:status --dna            # View DNA
```

### Programmatic (After Task Success)

```
Task Success → dna-builder.update(task_info) → Save DNA
```

---

## Notes

- DNA is **project-specific** (stored in `.dev-stacks/`)
- **Not committed to git** (add `.dev-stacks/` to `.gitignore`)
- Refreshed automatically when structure changes detected
- **Learned data persists** across sessions and refreshes
- Used to **personalize** Dev-Stacks behavior for each project
- Can be **rebuilt** from scratch if corrupted
