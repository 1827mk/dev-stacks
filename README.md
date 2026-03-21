# dev-stacks

**Full-stack AI development orchestrator for Claude Code.**

dev-stacks เป็น gateway ที่รับทุก task แล้วกระจายงานให้ agents ที่เหมาะสม — วิเคราะห์, เขียนโค้ด, ตรวจสอบ — ผลลัพธ์ production-ready เสมอ

---

## Install

```bash
/plugin marketplace add 1827mk/dev-stacks
/plugin install dev-stacks@dev-stacks-marketplace
/reload-plugins
```

**Requirements:** `jq` and `python3` in PATH

```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt install jq python3
```

---

## First time setup

```
/dev-stacks:registry
```

สแกน codebase → สร้าง DNA → ลงทะเบียน MCP servers ทั้งหมด
รันครั้งเดียวต่อ project หรือเมื่อเพิ่ม MCP server ใหม่

---

## Daily usage

### ทำงานทุกประเภท
```
/dev-stacks:agents แก้ bug ที่ payment service fail สำหรับ user ต่างประเทศ
/dev-stacks:agents เพิ่ม rate limiting ให้ API endpoints ทั้งหมด
/dev-stacks:agents refactor AuthService ให้รองรับ OAuth2
```

dev-stacks เลือก workflow ให้อัตโนมัติ:
- **quick** `< 0.2` — Claude ทำตรง
- **standard** `0.2–0.4` — thinker → builder
- **careful** `0.4–0.6` — thinker → builder → reviewer
- **full** `≥ 0.6` — thinker → builder → reviewer×2

### Feature ใหญ่ / architecture
```
/dev-stacks:plan เพิ่ม microservice สำหรับ notification system
/dev-stacks:tasks   ← หลัง plan เสร็จ
```

### เช็คสถานะ
```
/dev-stacks:status
```

### Rebuild registry (หลังเพิ่ม MCP server)
```
/dev-stacks:registry
```

---

## Agents

| Agent | หน้าที่ | Model |
|-------|--------|-------|
| **thinker** | วิเคราะห์ + root cause + plan | opus |
| **builder** | implement + fix (read-first) | opus |
| **reviewer** | verify + security + production check | sonnet |

---

## Skills (knowledge agents ใช้)

| Skill | ใช้เมื่อ |
|-------|---------|
| **analyze** | trace flow, map dependencies, find root cause |
| **design** | architecture, interface contract, data model |
| **implement** | เขียนโค้ด — read-first, style-preserve, minimal diff |
| **test-write** | เขียน + รัน tests, อ่าน log |
| **security** | OWASP review, auth, input validation |

---

## Hooks (ทำงานอัตโนมัติ)

| Hook | ทำอะไร |
|------|--------|
| **SessionStart** | Load snapshot + DNA → inject context ก่อน Claude เริ่มทำงาน |
| **UserPromptSubmit** | Classify intent + complexity → routing hint |
| **PreCompact** | Save snapshot ก่อน context ถูก compress |
| **Stop** | ตรวจว่างานเสร็จจริง — ถ้า code เขียนแล้วไม่มี verification จะ block |
| **SubagentStop** | ตรวจ output header ของทุก agent |

---

## Core principles

1. **ถามก่อนทำเสมอ** เมื่อไม่แน่ใจ — ไม่ตัดสินใจเองในสิ่งที่ irreversible
2. **ขออนุญาต web search** ก่อนค้นหาข้อมูลจากอินเทอร์เน็ต
3. **Read before write** — builder อ่านไฟล์จริงก่อนเขียนทุกครั้ง
4. **ไม่มโน ไม่คิดเอง** — ถ้าหาข้อมูลไม่เจอ หยุดและถาม

---

## Context persistence

dev-stacks เก็บ state ข้าม session อัตโนมัติ:

```
.dev-stacks/
├── dna.json       ← project fingerprint
├── registry.json  ← MCP servers + classification config
├── snapshot.md    ← active task state (auto-saved before compaction)
├── state.json     ← current task intent/complexity/workflow
├── plan.md        ← current feature plan
└── tasks.md       ← task checklist with progress
```

เมื่อ session ใหม่เริ่ม — SessionStart hook โหลด snapshot กลับเข้า context อัตโนมัติ

---

## MCP servers ที่ใช้

| Server | หน้าที่ |
|--------|--------|
| **serena** | Code analysis, symbol search, read/write files |
| **memory** | Store patterns + decisions across sessions |
| **context7** | Library documentation lookup |
| **filesystem** | File operations |
| **fetch** | Web content when user permits |

---

## Troubleshooting

**Hook ไม่ทำงาน**
```bash
which python3   # ต้องมี
ls ~/.claude/plugins/dev-stacks/hooks/scripts/
```

**DNA ไม่ถูกต้อง**
```
/dev-stacks:registry
```
แล้วยืนยันข้อมูลกับ Claude

**Snapshot ไม่ถูกต้อง**
ลบไฟล์แล้ว registry ใหม่:
```bash
rm ~/.../project/.dev-stacks/snapshot.md
```
