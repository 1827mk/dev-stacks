---
name: test-write
description: Use this skill when writing tests or running existing tests. Covers unit, integration, and E2E test writing patterns for any language or framework.
version: 3.0.0
---

# Test-Write Skill

Test writing and execution — language-agnostic patterns.

## Before writing tests

1. Read existing tests to understand the pattern (naming, structure, assertions)
2. Identify the test framework in use (JUnit/Mockito, testify, Jest, pytest, etc.)
3. Match exact style — do not introduce a new test library

## Test writing principles

**Unit tests**
- Test one thing per test — single assertion when possible
- Name: `should_[expected]_when_[condition]` or match existing naming
- Mock external dependencies, not internal logic
- Cover: happy path, error path, edge cases (null, empty, boundary values)

**Integration tests**
- Use real dependencies when fast enough (H2 for Java, SQLite for Go/Python)
- Clean up state after each test
- Test the contract, not the implementation

**Running tests**
- Use Bash to run the project's test command
- Read the full output — do not assume pass/fail from partial logs
- If tests fail: show the error to the user and ask how to proceed

## Output

```
TEST COMPLETE
Tests written: [N]
Tests run: [N passed / N failed]
Coverage: [areas covered]
Failures (if any):
- [test name]: [error — ask user how to proceed]
```
