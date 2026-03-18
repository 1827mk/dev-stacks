---
name: secret-scanner
description: Detect and prevent secrets from being committed to code. Use before Write/Edit operations.
---

# Secret Scanner

Detects and prevents secrets from being written to code.

## Purpose

Scan content for sensitive information before writing to files.

## Secret Patterns

### API Keys
```
api[_-]?key\s*[:=]\s*['"][^'"]+['"]
apikey\s*[:=]\s*['"][^'"]+['"]
```

### Passwords
```
password\s*[:=]\s*['"][^'"]+['"]
passwd\s*[:=]\s*['"][^'"]+['"]
pwd\s*[:=]\s*['"][^'"]+['"]
```

### Tokens
```
token\s*[:=]\s*['"][^'"]+['"]
access[_-]?token\s*[:=]\s*['"][^'"]+['"]
auth[_-]?token\s*[:=]\s*['"][^'"]+['"]
```

### Private Keys
```
-----BEGIN.*PRIVATE KEY-----
```

### Database URLs
```
(mongodb|mysql|postgres|redis)://[^\s'"]+:[^\s'"]+@
```

### AWS Keys
```
AKIA[0-9A-Z]{16}
aws[_-]?secret[_-]?access[_-]?key\s*[:=]\s*['"][^'"]+['"]
```

## Process

### Step 1: Receive Content

Get the content being written to a file.

### Step 2: Scan for Patterns

Check against secret patterns.

### Step 3: Report Findings

| Finding | Action |
|---------|--------|
| Secret detected | BLOCK - Show warning |
| No secrets | ALLOW - Proceed |

## Output Format

### Secret Detected
```
🛡️ Secret Scanner: SECRET DETECTED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Pattern: [pattern type]
File: [file path]
Line: [line number]

Found: [masked secret preview]
Reason: [why this is risky]

Suggestions:
1. Use environment variable: process.env.[VAR_NAME]
2. Store in .env file (already protected)
3. Use secrets manager

Proceed anyway? [y/N]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### No Secrets
```
(no output - operation proceeds)
```

## Examples

### Example 1: API Key Detected
```
Content: const apiKey = "sk-abc123def456";

🛡️ Secret Scanner: SECRET DETECTED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Pattern: API Key
File: src/config/api.ts
Line: 42

Found: apiKey = "sk-abc..."
Reason: Hardcoded API keys can be exposed in version control

Suggestions:
1. Use environment variable: process.env.API_KEY
2. Store in .env file (already protected)
3. Use secrets manager

Proceed anyway? [y/N]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Example 2: Database URL
```
Content: const dbUrl = "postgres://user:password@localhost/db";

🛡️ Secret Scanner: SECRET DETECTED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Pattern: Database URL with credentials
File: src/db/connection.ts
Line: 15

Found: postgres://user:***@localhost/db
Reason: Database credentials in code

Suggestions:
1. Use environment variable: process.env.DATABASE_URL
2. Store in .env file

Proceed anyway? [y/N]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Safe Patterns

These patterns are NOT flagged:
- Environment variable references: `process.env.VAR`
- Placeholder values: `"your-api-key-here"`
- Empty strings: `apiKey = ""`
- Variable references: `const key = config.apiKey`

## Usage

Automatically invoked by PreToolUse hook before Write/Edit operations.
