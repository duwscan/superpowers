---
name: why
description: "Use for 'why does X work this way', 'why we picked Y', design rationale, regressions, postmortems, git blame history, or data-backed thresholds. Queries code history (git/gh) and available MCPs in parallel, then returns a cited read on decisions and tradeoffs. Use how for runtime behavior."
---

# Why

Investigate the motivation, historical context, and design intent behind code. The companion `how` skill answers what the code does and how it runs; `why` answers what forces, tradeoffs, and decisions led to its current shape.

## When to Use

- **Design rationale:** "Why was this architecture chosen?", "Why is this caching layer here?"
- **Historical archaeology:** "Why was this check added?", "What commit introduced this behavior?"
- **Pre-refactoring reconnaissance:** Understanding constraints and invariants before refactoring or deleting legacy code.
- **Incident & regression tracing:** "Why did this threshold get set to 500ms?", "What bug was this commit fixing?"

## Operating Posture

Operate as a **careful, cautious, and precise investigator**. Be honest about what you know from direct evidence versus what you are inferring. Refer to `references/epistemics.md` for the confidence framework and phrasing conventions.

## Investigation Strategy & Model Rule

| Investigation Scope | Approach | Tool / Model |
| :--- | :--- | :--- |
| **Local Git Archaeology** | Tracing `git blame`, recent commits, PR discussions | Inline in main session |
| **Broad / Multi-Source Investigation** | Querying broad git history or external MCPs (GitHub Issues, Linear, Notion, Slack, Sentry, Datadog) | Dispatch Investigator Subagent with **`model: "haiku"`** |

> [!IMPORTANT]
> **Subagent Dispatch Rule:**
> If you dispatch an investigator subagent, you **MUST explicitly specify `model: "haiku"`**. Never use Opus or high effort for investigation subagents. Haiku is fast, read-only, and prevents token budget inflation.

---

## The Process

### Step 1. Understand Target and Question
- **Target:** The specific lines of code, function, pattern, or named design decision.
- **Question:** The rationale, tradeoff, edge case, or external constraint being investigated.
- If vague ("why is this done this way?"), make a sensible interpretation from conversation context, state it, and begin.

### Step 2. Establish the Code Anchor (Git Archaeology)
Before exploring external tools, build the seed context directly:
```bash
# 1. Inspect who touched the target lines and when
git blame -L <start>,<end> <file>

# 2. View full commit history with patches for the file
git log --follow -p -n 5 -- <file>

# 3. Check commit log with PR references (#1234)
git log --oneline -20 -- <file>

# 4. If a substantive commit or PR number is found, fetch PR metadata
gh pr view <number> --json title,body,author,createdAt,mergedAt,labels,comments,reviews 2>/dev/null || git log -1 --format=%B <commit>
```

### Step 3. Investigate Evidence Categories
Check available MCP tools or git sources across relevant evidence categories:
1. **Source Control History (Always available):** Git commit messages, diffs, PR descriptions, and review comments.
2. **Issue / Ticket Tracker:** Linear, Jira, GitHub Issues (product/business forcing functions).
3. **Long-Form Documents:** Notion, Google Docs, Confluence, design specs in `docs/specs/`.
4. **Real-Time Team Chat:** Slack, Discord (deliberations that never made it into docs).
5. **Observability & Error Tracking:** Sentry, Datadog, Honeycomb (runtime exceptions, latency, rate limits).

*Execution:*
- **Inline:** If only git/gh or 1 MCP is needed, query directly in the session.
- **Subagent:** If sweeping wide history or querying multiple external MCPs, dispatch an explorer subagent with `model: "haiku"` using `references/investigator-prompt.md`.

### Step 4. Synthesize & Calibrate Confidence
Evaluate findings against the epistemics framework (`references/epistemics.md`):
- **Direct Evidence:** Directly stated in commit messages, PR descriptions, issue tickets, or comments.
- **Reasonable Inference:** Logically deduced from code structure, tests, or commit timing.
- **Unknown / Open Questions:** What cannot be proven from available data.

### Step 5. Present

Structure the findings using the Output Format below.

---

## Output Format

### The Question
The core question and the specific code/symbol in question.

### The Code in Question
Brief snippet with exact file path and line numbers (`file:start-end`).

### What We Found (Direct Evidence)
Documented facts with exact citations:
- Commit SHA, author, date, and commit message.
- PR number and relevant excerpts from PR description / review comments.
- Issue ticket links or external doc references.

### What We Can Reasonably Infer
Logical deductions based on the evidence (clearly labeled as inferences):
- Why this approach was chosen over alternatives.
- The likely constraints or edge cases that motivated the design.

### Competing Hypotheses & Tradeoffs
If multiple explanations are plausible, state each hypothesis and the evidence for/against it.

### What We Don't Know
Explicitly acknowledge gaps, missing context, or historical unknowns. Never invent facts.

### Sources Consulted & Confidence Summary
- Table listing sources checked (Git history, PRs, Issues, MCPs) and what each returned.
- **Confidence Rating:** High (direct primary evidence), Medium (strong indirect evidence), or Low (plausible inference only).

### Constraints for Future Changes (If modifying code)
If this inquiry is a precursor to changing the code, summarize constraints as:
- **Preserve:** Invariants or edge cases that must not be broken.
- **Change:** What can safely be modified or modernized.
- **Avoid:** Pitfalls or regressions that prior commits were trying to solve.
