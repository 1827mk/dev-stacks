---
name: security
description: Use this skill for OWASP-based security review of code changes. Language-agnostic.
version: 4.0.0
---

# Security Skill

OWASP-based review — language-agnostic.

## Checklist

**Input validation** — all external inputs validated, no path traversal, file types restricted

**Injection** — parameterised queries only, no string-concat SQL, no exec with user input

**Auth/Authz** — every endpoint checks both, tokens expire, no bypass via method switching

**Secrets** — none hardcoded, no secrets in logs/errors, env vars or secret managers only

**Crypto** — bcrypt/argon2 for passwords, TLS for all external calls, no MD5/SHA1 for passwords

## Critical issue protocol

`⚠️ SECURITY: [type] at [file:line] — [impact]`
Ask: "Fix now or handle manually?"
Never ignore.

Write to memory: `mcp__memory__add_observations` on "security-findings" entity.
