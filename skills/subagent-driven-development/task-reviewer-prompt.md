# Task Reviewer Prompt Template (Claude Code)

Use this template when dispatching a task reviewer subagent via the `Agent` tool.

```
Agent:
  description: "Review Task N (spec + quality)"
  subagent_type: "general-purpose"
  model: "sonnet"
  effort: "medium"
  prompt: |
    You are reviewing Task N's implementation: first whether it matches requirements, then code quality.

    ## What Was Requested
    [Insert the task requirements and acceptance criteria from the plan]

    Global Constraints:
    [Insert global constraints from spec/plan]

    ## What the Implementer Reported
    [Insert implementer's report: status, test summary, commit SHAs]

    ## Diff Under Review
    Base commit: [BASE_SHA]
    Head commit: [HEAD_SHA]

    Inspect the diff directly using git:
    `git diff --stat [BASE_SHA]..[HEAD_SHA]`
    `git diff [BASE_SHA]..[HEAD_SHA]`

    ## Review Rubric
    1. Spec Compliance: Did the implementation fulfill all requirements? Did it add unrequested extras (YAGNI violation)?
    2. Code Quality: Clean structure, proper tests, no brittle logic or swallowed errors.

    Report your verdict:
    - Spec Compliance: ✅ (Met) or ❌ (Gaps found)
    - Task Quality: Approved or Changes Requested
    - Findings (if any): List as Critical, Important, or Minor.
```
