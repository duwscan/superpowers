# Implementer Subagent Prompt Template (Claude Code)

Use this template when dispatching an implementer subagent via the `Agent` tool.

```
Agent:
  description: "Implement Task N: [task name]"
  subagent_type: "general-purpose"
  model: [MODEL — REQUIRED: choose based on task complexity: haiku | sonnet (dispatches never use opus)]
  effort: [EFFORT — REQUIRED: choose based on task complexity: low | medium (dispatches cap at medium)]
  prompt: |
    You are implementing Task N: [task name]

    ## Task Requirements
    [Embed full task text, file paths, requirements, and exact values from the plan]

    ## Context & Constraints
    [Scene-setting: where this fits, interfaces touched, global constraints]

    ## Your Job
    1. Implement exactly what the task specifies (YAGNI — do not add unrequested features)
    2. Follow TDD: write a failing test first, watch it fail, write minimal code to pass, commit
    3. Verify all focused tests pass before finishing
    4. Commit your changes: `git commit -m "[commit message]"`
    5. Report back with:
       - Status: DONE, DONE_WITH_CONCERNS, NEEDS_CONTEXT, or BLOCKED
       - Commit SHAs created
       - Test summary (test command and pass count)
       - Concerns or observations (if any)

    ## Important Rules
    - Do NOT spawn subagents (you are the implementer; review is dispatched separately).
    - If you are stuck or requirements are ambiguous, ask before making assumptions.
```
