---
description: Generate code from templates — scaffold, logic, or full with tests
argument-hint: "<what> --level=[scaffold|logic|full]"
model: sonnet
---

# dev-stacks: generate

Use the **code-generator** skill.

## Levels

| Level | What it generates |
|-------|-------------------|
| scaffold | File structure + empty functions/classes |
| logic | Scaffold + business logic implementation |
| full | Logic + unit tests + integration tests |

## Usage

```
/dev-stacks:generate api-endpoint --level=scaffold
/dev-stacks:generate react-component --level=logic
/dev-stacks:generate service-class --level=full
```

After generation, run `/dev-stacks:check` to verify.
