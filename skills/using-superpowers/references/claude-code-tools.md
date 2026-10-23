# Claude Code Reference Guide

Superpowers is configured specifically for **Claude Code**. All workflows utilize Claude Code's native agent orchestration, tools, and model routing.

---

## 1. Codebase Exploration: Prioritize `Explore` Subagent

To keep the main session context clean and avoid premature compaction:
* **Recommendation:** For non-trivial codebase research, multi-file inspection, or symbol tracing, **prioritize dispatching an `Explore` subagent** instead of loading multiple files into the primary session.
* **Direct Tools Permitted:** You are NOT forbidden from using `Read`, `Grep`, or `Glob` directly in the main session for quick, targeted checks.
* **Mechanism:** Dispatch an `Explore` subagent via the `Agent` tool:
  ```json
  {
    "name": "Agent",
    "input": {
      "subagent_type": "Explore",
      "model": "haiku",
      "description": "Explore <target module / symbol>",
      "prompt": "Find all definitions, interfaces, schemas, and dependencies for <topic>. Return a concise summary with exact file paths and signatures."
    }
  }
  ```
* **Why Haiku:** `Explore` is read-only. `haiku` provides lightning-fast search and symbol analysis at minimal token cost without consuming thinking effort.

---

## 2. Planning: Native Plan Mode & Artifact Locations

The legacy `writing-plans` skill has been replaced by Claude Code's **Native Plan Mode**:
* **Spec document location:** Once design discussion concludes in `superpowers:brainstorming`, the approved design document is saved at:
  `docs/specs/YYYY-MM-DD-<topic>-design.md` (committed to git).
* **Plan document location:** In Claude Code's native Plan mode (or built-in `Plan` subagent), decompose the approved design into bite-sized, verifiable tasks and save the implementation plan at:
  `docs/plans/YYYY-MM-DD-<feature-name>.md` (committed to git).
* Once the plan is approved by the user, pass the plan path (`docs/plans/...`) to `superpowers:subagent-driven-development` or `superpowers:executing-plans`.

---

## 3. Subagent Model & Effort Optimization

> [!IMPORTANT]
> **Allocation Rule:**
> - `model: "opus"` and `effort: "high"` are strictly reserved for the **main interactive session**.
> - **All dispatched subagents MUST use `effort: "medium"` (or `"low"`) and model `"sonnet"` (or `"haiku"`). Subagents NEVER use `opus` or `high` effort.**
> - **Always explicitly pass both `model` and `effort`** in every `Agent` tool call. If omitted, the subagent silently inherits the main session's active model and effort (e.g. Opus / High), wasting budget.

When dispatching subagents in `subagent-driven-development` or `executing-plans`, explicitly match `model` and `effort` to task complexity:

| Task Complexity | Indicators | Subagent Type | Model | Effort |
| :--- | :--- | :--- | :--- | :--- |
| **Codebase Research** | Searching symbols, mapping files, reading logs | `Explore` | `haiku` | *N/A (0)* |
| **Low Complexity** | 1–2 files, boilerplate, transcription of plan code, simple unit tests | `general-purpose` | `haiku` or `sonnet` | `low` |
| **Medium Complexity** | Standard business logic, module integration, TDD implementation, task review | `general-purpose` | `sonnet` | `medium` |
| **High Complexity / Concurrency** | Tricky async, architectural changes, complex state machines | `general-purpose` | `sonnet` | `medium` |
| **Fix Loop Escalation (Rounds 4–5)** | Implementer got stuck, persistent test failures | `general-purpose` | `sonnet` (fresh context) | `medium` |
| **Whole-Branch Final Review** | Final gate checking entire branch diff, security, design compliance | `general-purpose` | `sonnet` | `medium` |

---

## 4. Orchestration Subagent (Optional for Large Plans)

The main controller session can become expensive when reading multiple task reports. Claude Code supports nested subagents (up to 3 levels by default; configurable via `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH`).

For long plans, you may dispatch ONE orchestrator subagent on `sonnet` with `medium` effort to run `superpowers:subagent-driven-development` end-to-end. The orchestrator dispatches its own task workers and reviewers per the table above, reporting only the final results and decisions back to the main session.
