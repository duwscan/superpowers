# Scoped Re-Review Prompt Template (Claude Code)

Use this template when re-reviewing fixes from the fix loop via the `Agent` tool.

```
Agent:
  description: "Re-review Task N fixes (Round R)"
  subagent_type: "general-purpose"
  model: "sonnet"
  effort: "low"
  prompt: |
    You are performing a scoped re-review of fixes applied in Task N.

    ## Open Findings to Verify
    [List of findings from previous review that required fixes]

    ## Fix Diff
    Fix Base: [FIX_BASE_SHA]
    Head: [HEAD_SHA]

    Inspect the fix diff:
    `git diff [FIX_BASE_SHA]..[HEAD_SHA]`

    ## Evaluation
    For each open finding:
    - Verdict: ADDRESSED or NOT ADDRESSED (with file and line reference).
    - Check if the fix introduced any new breakage in the fix diff only.

    Return:
    - All findings addressed? (Yes / No)
    - Residual open findings (if any)
```
