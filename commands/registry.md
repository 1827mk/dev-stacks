---
description: Register project and build DNA — run once per project, or after major refactor
argument-hint: "[project path - optional, defaults to cwd]"
model: opus
---

# dev-stacks: registry

Use the **dna-builder** skill. Follow every step exactly.

After DNA is written, ask user to confirm the detected stack:
```
Detected: [name] | [languages] | [frameworks]
Risk areas: [list]
Is this correct? (yes / correct me)
```

Wait for confirmation before finalising.
