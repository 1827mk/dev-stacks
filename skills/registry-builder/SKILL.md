---
name: registry-builder
description: Use this skill when /dev-stacks:registry is run. Rebuilds registry.json by scanning actual connected MCP servers, installed plugins, and project DNA.
version: 3.0.0
---

# Registry Builder Skill

Rebuild registry from actual runtime state — not hardcoded values.

## Process

1. **Scan MCP servers** — use Bash: `claude mcp list 2>/dev/null || echo "cannot list"` → parse Connected servers
2. **Read DNA** — load `.dev-stacks/dna.json` if exists
3. **Check serena onboarding** — `mcp__serena__check_onboarding_performed`
4. **Write registry** to `.dev-stacks/registry.json`

## Registry schema

```json
{
  "version": "3.0.0",
  "updated": "<ISO timestamp>",
  "mcp_servers": ["<name of each Connected server>"],
  "serena_onboarded": true,
  "project_name": "<from DNA or unknown>",
  "stack": "<from DNA or unknown>",
  "intent_categories": {
    "FIX_BUG":     {"keywords": ["bug","error","fix","crash","แก้","พัง","ไม่ทำงาน"], "complexity_delta": 0.05},
    "ADD_FEATURE":  {"keywords": ["add","create","implement","new","เพิ่ม","สร้าง"],  "complexity_delta": 0.10},
    "MODIFY":       {"keywords": ["change","update","refactor","เปลี่ยน","ปรับ"],     "complexity_delta": 0.05},
    "EXPLAIN":      {"keywords": ["explain","how","why","อธิบาย","ยังไง"],             "complexity_delta": -0.15},
    "RESEARCH":     {"keywords": ["find","search","docs","หา","ค้นหา"],              "complexity_delta": -0.15},
    "DESIGN":       {"keywords": ["design","architect","plan","ออกแบบ","วางแผน"],    "complexity_delta": 0.10},
    "SECURITY":     {"keywords": ["security","auth","vuln","ความปลอดภัย"],          "complexity_delta": 0.20}
  },
  "complexity_factors": {
    "high": ["payment","auth","security","database","migration","oauth","webhook","encryption"],
    "medium": ["api","integration","service","endpoint","component"],
    "low": ["typo","comment","rename","format","log","message"]
  }
}
```

## Report

```
Registry rebuilt: [timestamp]
MCP servers found: [list]
Serena: [onboarded / not onboarded]
Project: [name from DNA]
Saved: .dev-stacks/registry.json
```
