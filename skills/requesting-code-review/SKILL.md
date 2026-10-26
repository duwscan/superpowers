---
name: requesting-code-review
description: Use when completing tasks, implementing major features, or before merging to verify work meets requirements via an inline code review pass
---

# Code Review (Inline Self-Review Pass)

Perform a structured, critical review of code changes against requirements and engineering standards before merging to main or finishing a branch.

**Core principle:** Review early, review often. Read the diff with the skepticism of an external reviewer.

## When to Review

**Mandatory:**
- Before completing an implementation branch (`superpowers:finishing-a-development-branch`)
- After completing a major feature or refactor
- Before merging to `main`

**Optional but valuable:**
- When stuck (pause and review what changed)
- Before refactoring (baseline diff check)
- After fixing a complex bug

## Review Process

**1. Inspect the Git Diff:**
```bash
BASE_SHA=$(git merge-base origin/main HEAD 2>/dev/null || git merge-base main HEAD)
git diff --stat "$BASE_SHA"..HEAD
git diff "$BASE_SHA"..HEAD
```

**2. Evaluate Against the Review Rubric:**
Apply the rubric at [code-reviewer.md](code-reviewer.md):
- **Plan alignment:** Does the implementation match the plan or requirements? Any unjustified scope creep or omissions?
- **Code hygiene:** Clean interfaces, proper error handling, type safety, no leftover debug prints or commented-out code.
- **Test coverage:** Do tests verify actual behavior rather than mocks? Are edge cases and error paths tested?
- **Regression check:** Does the entire test suite run and pass cleanly?

**3. Act on Feedback:**
- **Critical / Important:** Fix immediately in a focused TDD pass before proceeding.
- **Minor:** Note in the final summary for your human partner.

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "I wrote the code, so I know it works" | Authors suffer confirmation bias. Reading the actual `git diff` line-by-line reveals missed edge cases and unintended edits. |
| "Tests pass, so review isn't needed" | Passing tests don't catch architectural flaws, security holes, or unhandled negative cases not in the tests. |
| "The diff is small, I can skip review" | Small changes frequently cause subtle regressions. Run the rubric. |

## Red Flags

**Never:**
- Skip review because "it's simple"
- Ignore Critical or Important issues
- Merge or complete a branch without running the full test suite
- Assume behavior without checking the diff

See rubric details at: [code-reviewer.md](code-reviewer.md)
