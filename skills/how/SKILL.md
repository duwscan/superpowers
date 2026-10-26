---
name: how
description: "Use for \"how does X work\", code walkthroughs before changing something, and placement / ownership / layering questions (\"where should this live\", \"which package owns this\", \"is this the right layer\"). Explains subsystem architecture, runtime flow, onboarding mental models."
---

# How

Explore the codebase to answer "how does X work?" questions, code walkthroughs before making changes, and architectural placement questions ("where should this live?", "which layer owns this?").

Produce architectural explanations at the level of a senior engineer onboarding onto a subsystem: enough to build an accurate mental model, not so detailed that it reads like an annotated line-by-line code dump.

## When to Use

- **"How does X work?"** / "Walk me through the authentication / sync flow"
- **Before changing unfamiliar code:** Walkthrough and understand the surrounding architecture before implementing
- **Placement & layering decisions:** "Where should this logic live?", "Which package should own this service?", "Is this the right layer for caching?"
- **Subsystem mental models:** Building onboarding understanding of complex modules or cross-cutting features

## Exploration Strategy & Model Rule

Depending on complexity, you can explore inline or dispatch an explorer subagent:

| Complexity | Scope | Strategy | Model / Tool |
| :--- | :--- | :--- | :--- |
| **Simple** | Single function, utility, 1–2 files | Inline in main session | Native `Read`, `Grep`, `Glob` |
| **Complex** | Subsystem spanning multiple files/services, cross-cutting feature | Dispatch Explorer Subagent | `Agent` tool with **`model: "haiku"`** |

> [!IMPORTANT]
> **Subagent Dispatch Rule:**
> When dispatching an exploration subagent, you **MUST explicitly pass `model: "haiku"`** (with `subagent_type: "Explore"` or `"general-purpose"`). Never use Opus or high effort for exploration subagents. Haiku is fast, read-only, and prevents blowing up context and token budget.

## The Process

### 1. Assess Question & Scope
- Identify the specific subsystem, flow, or architectural decision being asked.
- Determine whether it is **Simple** (inspect inline) or **Complex** (dispatch Haiku subagent).

### 2. Exploration Phase

**For Simple Questions (Inline):**
- Use `Read`, `Grep`, and `Glob` directly in the session to trace the relevant function and return the explanation.

**For Complex Questions (Dispatch Haiku Subagent):**
- Dispatch an explorer subagent via the `Agent` tool using the template in `references/explorer-prompt.md`:
  ```json
  {
    "name": "Agent",
    "input": {
      "subagent_type": "Explore",
      "model": "haiku",
      "description": "Trace architecture and flow for <topic>",
      "prompt": "<Prompt from references/explorer-prompt.md filled with question and exploration angle>"
    }
  }
  ```
- For very wide subsystems, you may dispatch 2–3 focused Haiku explorers in parallel (e.g. one for frontend trigger/routing, one for backend processing/data models).

### 3. Synthesize & Present
The main session synthesizes the findings and presents the final explanation according to the Output Format below.

---

## Output Format

Adapt these sections to what makes sense for the question (drop any that do not apply):

### Overview
1–2 paragraphs. What is this subsystem, what does it do, and why does it exist. A reader should be able to read just this and decide whether to keep reading.

### Key Concepts & Abstractions
The essential types, services, models, or abstractions needed to understand the rest. Brief, concrete definitions—not an exhaustive dictionary.

### How It Works (Runtime Flow)
The core of the explanation:
- Walk through the execution flow step-by-step: trigger $\rightarrow$ processing $\rightarrow$ downstream calls $\rightarrow$ response/persistence.
- Use prose with concrete references to exact file paths, method names, and types (e.g. `AuthService.validateToken()` in `src/auth/service.ts`).
- When multiple components interact or data transforms across stages, include a **Mermaid diagram** (sequence diagram, flowchart, or component graph) or concise ASCII art. A diagram should clarify complex interactions, not decorate simple ones.
- When something is complex, explain *why* it is complex (concurrency, legacy compatibility, distributed transactions), not just what it does.

### Where Things Live
A brief, practical file/directory map listing the key files someone needs to start working in this area.

### Gotchas & Non-Obvious Behavior
Surprising behaviors, race conditions, edge cases, caching pitfalls, or historical context that is easy to misunderstand. Skip if none.

---

## Communication Style

- Use concrete language: name actual files and symbols, not abstractions-about-abstractions.
- When something is simple, don't pad it out.
- Acknowledge open questions or ambiguities if parts of the codebase could not be fully resolved.
