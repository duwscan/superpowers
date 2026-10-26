# Claude Code Reference Guide

Superpowers is configured specifically for **Claude Code** with a streamlined, 100% single-session architecture (no subagents).

---

## 1. Single-Session Architecture (No Subagents)

All exploration, planning, development, and reviews run directly inside the main Claude Code session:
* **Direct Tools:** Use Claude Code's native tools (`Read`, `Edit`, `Grep`, `Glob`, `Bash`) directly.
* **No Subagent Spawns:** Subagents are eliminated to prevent context fragmentation, nested dispatch overhead, and token bloat.
* **Focused Inspections:** When reading logs or inspecting symbols, use targeted `grep` and file reading to keep session memory clean.

---

## 2. Planning: Native Plan Mode & Artifact Locations

The legacy `writing-plans` skill has been replaced by Claude Code's **Native Plan Mode**:
* **Spec document location:** Once design discussion concludes in `superpowers:brainstorming`, the approved design document is saved at:
  `docs/specs/YYYY-MM-DD-<topic>-design.md` (committed to git).
* **Plan document location:** In Claude Code's native Plan mode, decompose the approved design into bite-sized, verifiable tasks and save the implementation plan at:
  `docs/plans/YYYY-MM-DD-<feature-name>.md` (committed to git).
* Once the plan is approved by the user, initiate execution via `/executing-plans` or `superpowers:executing-plans`.

---

## 3. Model & Effort Configuration: `/executing-plans`

To optimize token efficiency and response speed:
* **Default Skill Execution:** When `superpowers:executing-plans` is invoked directly as a skill, it executes using the active model and effort of the current session.
* **Cost-Optimized Execution via `/executing-plans`:** When you want to execute using Sonnet with medium effort to save tokens and speed up iteration, use the dedicated slash command:
  ```
  /executing-plans [docs/plans/...]
  ```
  This command explicitly sets:
  - `model: sonnet`
  - `effort: medium`
  - Loads and follows `superpowers:executing-plans` to implement the plan step-by-step with strict TDD.

---

## 4. Execution Workflow

1. **Setup:** Switch or verify feature branch (`git branch --show-current`).
2. **Task Loop:**
   - Take Task $N$ from `docs/plans/...`.
   - Write failing test.
   - Implement minimal code to pass.
   - Commit cleanly: `git commit -m "[Task N] <description>"`.
   - Verify task contract & test suite.
3. **Inline Review Pass:** Inspect `git diff $(git merge-base main HEAD)..HEAD` using the rubric in `superpowers:requesting-code-review`.
4. **Completion:** Invoke `superpowers:finishing-a-development-branch`.
