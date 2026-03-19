# Agent Contracts: Dev-Stacks

**Feature**: 002-dev-stacks
**Created**: 2026-03-18

---

## Overview

Dev-Stacks มี 3 agents ที่ทำงานร่วมกันเหมือน developer team เก่งๆ

---

## Agent: Thinker

### Role
วิเคราะห์ วางแผน และออกแบบ implementation

### When Invoked
- Complexity score >= 0.2 (STANDARD, CAREFUL, FULL workflows)

### Capabilities
- วิเคราะห์ task requirements
- ระบุไฟล์ที่เกี่ยวข้อง
- ออกแบบ implementation approach
- ระบุ potential risks
- **ค้นคว้าหาความรู้เพิ่มเติม** เมื่อไม่คุ้นเคยกับ architecture/library

### Available MCP Tools

| Tool | Purpose | When to Use |
|------|---------|-------------|
| `context7` | Library documentation | Unknown library/framework |
| `web_reader` | Web content | Tutorials, articles |
| `WebSearch` | General search | Solutions, best practices |
| `fetch` | Specific URLs | GitHub, docs |
| `memory` | Pattern storage | Retrieve relevant patterns |
| `filesystem` | File operations | Read project files |
| `serena` | Code intelligence | Analyze codebase structure |

### Output Format
```
🧠 THINKER ANALYSIS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Task: [Task description]

Research Findings: (if applicable)
📚 Topic: [What was researched]
   Sources: [Where info came from]
   Key Learnings: [Summary]

Analysis:
- Files to modify: [List]
- Approach: [Description]
- Risks: [List]
- Estimated complexity: [Score]

Recommendations:
1. [Recommendation 1]
2. [Recommendation 2]

Ready for Builder.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Agent: Builder

### Role
Implement แก้ไข และสร้าง code

### When Invoked
- Always (every task)

### Capabilities
- Implement features
- Fix bugs
- Refactor code
- Follow Thinker's plan
- **ค้นคว้า API usage** เมื่อไม่คุ้นเคยกับ library
- **ค้นคว้า best practices** เมื่อ implement feature ใหม่

### Available MCP Tools

| Tool | Purpose | When to Use |
|------|---------|-------------|
| `context7` | Library documentation | Unknown API |
| `web_reader` | Web content | Code examples |
| `WebSearch` | General search | Error solutions |
| `fetch` | Specific URLs | Package docs |
| `filesystem` | File operations | Read/write files |
| `serena` | Code intelligence | Find symbols, references |
| `memory` | Pattern storage | Save successful patterns |

### Output Format
```
🛠️ BUILDER IMPLEMENTATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Following Thinker's plan...

Research Applied: (if applicable)
📚 Used: [What research was applied]

Changes:
- [File 1]: [Description]
- [File 2]: [Description]

Implementation complete.
Ready for Tester.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Agent: Tester

### Role
Verify validate และทดสอบ implementation

### When Invoked
- Complexity score >= 0.4 (CAREFUL, FULL workflows)

### Capabilities
- Verify implementation meets requirements
- Run tests if available
- Check edge cases
- Review code quality
- **ค้นคว้า testing best practices** เมื่อใช้ framework ใหม่

### Available MCP Tools

| Tool | Purpose | When to Use |
|------|---------|-------------|
| `context7` | Library documentation | Testing framework docs |
| `web_reader` | Web content | Testing tutorials |
| `WebSearch` | General search | Testing patterns |
| `filesystem` | File operations | Read test files |
| `serena` | Code intelligence | Find test coverage |

### Output Format
```
✅ TESTER VERIFICATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Testing implementation...

Tests Run: [Count]
- [Test 1]: ✅ Pass
- [Test 2]: ✅ Pass

Code Review:
- [Aspect 1]: ✅ OK
- [Aspect 2]: ⚠️ Minor issue

Edge Cases Checked:
- [Case 1]: ✅ Handled
- [Case 2]: ✅ Handled

Verification: ✅ PASSED
Task complete.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Research Triggers

Agents ควร research เมื่อ:

| Trigger | Example | Tool to Use |
|---------|---------|-------------|
| Unknown library | "ใช้ Zod สำหรับ validation" | context7 |
| Unfamiliar API | "Stripe payment API" | context7, web_reader |
| New error | "Error: ECONNREFUSED" | WebSearch |
| Best practice needed | "React performance optimization" | WebSearch, web_reader |
| Architecture pattern | "Microservices pattern" | web_reader, fetch |

---

## Research Process

When agent needs to research:

1. **Identify Gap**: What knowledge is missing?
2. **Select Tool**: Which MCP tool is appropriate?
3. **Search/Query**: Execute research
4. **Synthesize**: Extract relevant information
5. **Apply**: Use findings in implementation
6. **Report**: Share what was learned

---

## Tool Access Matrix

| Tool | Thinker | Builder | Tester |
|------|:-------:|:-------:|:------:|
| context7 | ✅ | ✅ | ✅ |
| web_reader | ✅ | ✅ | ✅ |
| WebSearch | ✅ | ✅ | ✅ |
| fetch | ✅ | ✅ | ✅ |
| filesystem | ✅ | ✅ | ✅ |
| serena | ✅ | ✅ | ✅ |
| memory | ✅ | ✅ | ❌ |

---

## Notes

- All agents can research autonomously - no explicit skill needed
- Research findings are shared via conversation context
- Agents should report what they researched and learned
- Research can be saved as patterns for future use
