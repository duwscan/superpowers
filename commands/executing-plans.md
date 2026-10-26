---
description: Execute an implementation plan in single-session mode with sonnet and medium effort
model: sonnet
effort: medium
argument-hint: [plan-path]
---

Invoke and execute the `superpowers:executing-plans` skill in single-session mode with `model: sonnet` and `effort: medium`.

1. **Model & Effort Verification:**
   - Active execution model must be `sonnet`.
   - Reasoning effort must be `medium`.
   - All tasks run inline in this session (no subagents).

2. **Locate Plan:**
   - If `$ARGUMENTS` provides a plan path, use it.
   - Otherwise, check `docs/plans/` for the latest implementation plan.
   - If multiple or none, confirm with the user.

3. **Execute via `superpowers:executing-plans`:**
   - Verify active branch is a feature branch (`git branch --show-current`).
   - Read the plan context and Global Constraints.
   - Follow the task loop with strict Test-Driven Development (failing test -> pass -> commit per task).
   - Once all tasks are complete, conduct an inline whole-branch self-review of `git diff $(git merge-base main HEAD)..HEAD`.
   - Proceed to `superpowers:finishing-a-development-branch` when review passes.
