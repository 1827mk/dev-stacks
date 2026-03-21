---
name: security
description: Use this skill when reviewing code for security issues, implementing auth/authz, or validating that changes don't introduce vulnerabilities.
version: 3.0.0
---

# Security Skill

Security review and implementation — language-agnostic, OWASP-based.

## Review checklist

**Input validation**
- All external inputs validated before use (query params, body, headers, env vars)
- No trusting user-supplied IDs without authorisation check
- File paths sanitised — no path traversal (`../`)

**Injection**
- No string-concatenated SQL — use parameterised queries/ORM
- No string-concatenated shell commands — use argument arrays
- No eval or dynamic code execution with user input

**Authentication & Authorisation**
- Every endpoint checks authentication
- Every resource operation checks authorisation (not just authentication)
- Token/session expiry enforced
- No auth bypass via HTTP method switching or parameter manipulation

**Secrets**
- No secrets, API keys, or passwords in code or logs
- Secrets come from environment variables or secret managers only
- No secrets in error messages or stack traces

**Cryptography**
- No MD5/SHA1 for passwords — use bcrypt/argon2/scrypt
- No custom crypto — use established libraries
- TLS enforced for external calls

## When you find an issue

State exactly: `⚠️ SECURITY: [vulnerability type] at [file:line] — [impact]`
Ask user: "This needs to be fixed before this is safe to deploy. Should I fix it or do you want to handle it?"
**Never silently ignore a security issue.**

If you need to research a vulnerability or library: ask user for permission to search the web first.
