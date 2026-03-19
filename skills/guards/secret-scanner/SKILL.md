---
name: secret-scanner
description: Detect secrets before writing to files. Auto-invoked before Write/Edit.
---

# Secret Scanner

Detect and prevent secrets from being committed.

## Secret Patterns

| Type | Regex |
|------|-------|
| API Keys | `api[_-]?key\s*[:=]\s*['"][^'"]+['"]` |
| Passwords | `password\s*[:=]\s*['"][^'"]+['"]` |
| Tokens | `token\s*[:=]\s*['"][^'"]+['"]` |
| Private Keys | `-----BEGIN.*PRIVATE KEY-----` |
| DB URLs | `(mongo\|mysql\|postgres\|redis)://[^\s'"]+:[^\s'"]+@` |
| AWS Keys | `AKIA[0-9A-Z]{16}` |

## Output

### Secret Detected
```
Secret Scanner: DETECTED
Pattern: [type]
File: [path]:[line]
Found: [masked preview]

Suggestions:
1. Use process.env.VAR_NAME
2. Store in .env file
3. Use secrets manager

Proceed? [y/N]
```

## Safe Patterns
- `process.env.VAR`
- `"your-api-key-here"`
- `apiKey = ""`

## Usage
Auto-invoked by PreToolUse hook before Write/Edit.
