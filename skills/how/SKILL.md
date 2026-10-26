---
name: how
description: "Use for \"how does X work\", code walkthroughs before changing something, and placement / ownership / layering questions (\"where should this live\", \"which package owns this\", \"is this the right layer\"). Explains subsystem architecture, runtime flow, onboarding mental models."
---

# How

Explore the codebase inline to answer "how does X work?" questions, code walkthroughs before making changes, and architectural placement questions ("where should this live?", "which layer owns this?").

Produce architectural explanations at the level of a senior engineer onboarding onto a subsystem: enough to build an accurate mental model, not so detailed that it reads like an annotated line-by-line code dump.

## When to Use

- **"How does X work?"** / "Walk me through the authentication / sync flow"
- **Before changing unfamiliar code:** Walkthrough and understand the surrounding architecture before implementing
- **Placement & layering decisions:** "Where should this logic live?", "Which package should own this service?", "Is this the right layer for caching?"
- **Subsystem mental models:** Building onboarding understanding of complex modules or cross-cutting features

## The Process

All exploration and explanation happen directly within your current session (100% single-session, no subagents).

1. **Assess Question & Scope:**
   - Identify the specific subsystem, flow, or architectural decision being asked.
   - If the scope is broad or ambiguous, state your interpretation and begin exploring; your human partner can redirect if needed.

2. **Explore the Codebase Inline:**
   Use Claude Code's native tools (`Read`, `Grep`, `Glob`) directly:
   - Locate entry points, public interfaces, configuration schemas, and route handlers.
   - Trace the execution flow step by step: what triggers the flow, what methods run, what data is passed, and where decisions branch.
   - Map module boundaries and interactions with external services or databases.
   - Identify non-obvious behaviors, invariants, and historical constraints.

3. **Synthesize & Present:**
   Present a clear, structured explanation using the format below.

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

## Communication Style

- Use concrete language: name actual files and symbols, not abstractions-about-abstractions.
- When something is simple, don't pad it out.
- Acknowledge open questions or ambiguities if parts of the codebase could not be fully resolved.
