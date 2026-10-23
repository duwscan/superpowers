---
name: using-superpowers
description: Use when starting any conversation - establishes how to find and use skills, requiring skill invocation before ANY response including clarifying questions
---

<SUBAGENT-STOP>
If you were dispatched as a subagent to execute a specific task, ignore this skill.
</SUBAGENT-STOP>

<EXTREMELY-IMPORTANT>
If you think there is even a 1% chance a skill might apply to what you are doing, you ABSOLUTELY MUST invoke the skill.

IF A SKILL APPLIES TO YOUR TASK, YOU DO NOT HAVE A CHOICE. YOU MUST USE IT.

This is not negotiable. You cannot rationalize your way out of this.
</EXTREMELY-IMPORTANT>

## The Rule

**Invoke relevant or requested skills BEFORE any response or action** — including clarifying questions, exploring the codebase, or checking files. If it turns out wrong for the situation, you don't have to use it.

**Before entering plan mode:** if you haven't already brainstormed, invoke the brainstorming skill first.

Then announce "Using [skill] to [purpose]" and follow the skill exactly. If it has a checklist, create a todo per item.

## Skill Priority

When multiple skills apply, process skills come first — they set the approach, then implementation skills (frontend-design, etc.) carry it out. Brainstorming and systematic-debugging are Superpowers' most common process skills, but the rule holds for any of them.

- "Let's build X" → superpowers:brainstorming first, then implementation skills.
- "Fix this bug" → superpowers:systematic-debugging first, then domain skills.

## Codebase Exploration & Research: Prioritize `Explore` Subagent

When you need to research or explore the codebase (such as searching symbols, mapping files, or understanding architecture across multiple modules), **prioritize dispatching an `Explore` subagent** rather than performing extensive searches in the main session.

- Direct file reads or quick checks in the main session are completely permitted (you are not forbidden from using `Read`, `Grep`, or `Glob` directly for targeted tasks).
- However, for non-trivial exploration or broad codebase research, dispatching an `Explore` subagent keeps the main session's context window clean and minimizes token burn:
  ```json
  {
    "name": "Agent",
    "input": {
      "subagent_type": "Explore",
      "model": "haiku",
      "description": "Explore <topic / module / symbol>",
      "prompt": "Find <files, interfaces, schemas, call sites> for <topic>. Return a concise summary with exact file paths and signatures."
    }
  }
  ```
- Use `model: "haiku"` for fast, cost-efficient, read-only exploration without wasting reasoning tokens.

## Planning: Claude Code Native Plan Mode

The `writing-plans` skill has been replaced by Claude Code's native planning feature.
- After brainstorming is completed and the design is approved (saved to `docs/specs/YYYY-MM-DD-<topic>-design.md`), transition directly to **Claude Code native Plan mode** (or built-in `Plan` subagent) to formulate the task plan.
- Break work into small, verifiable tasks with explicit test expectations, and save the plan to `docs/plans/YYYY-MM-DD-<feature-name>.md`.

## Red Flags

These thoughts mean STOP—you're rationalizing:

| Thought | Reality |
|---------|---------|
| "This is just a simple question" | Questions are tasks. Check for skills. |
| "I need more context first" | Skill check comes BEFORE clarifying questions. |
| "Let me explore the codebase first" | Prioritize dispatching Explore subagent (`model: haiku`) for broad research to keep main context clean. |
| "I can check git/files quickly" | Quick checks are fine, but prefer Explore subagent for multi-file investigations. |
| "Let me gather information first" | Skills tell you HOW to gather information. |
| "This doesn't need a formal skill" | If a skill exists, use it. |
| "I remember this skill" | Skills evolve. Read current version. |
| "This doesn't count as a task" | Action = task. Check for skills. |
| "The skill is overkill" | Simple things become complex. Use it. |
| "I'll just do this one thing first" | Check BEFORE doing anything. |
| "This feels productive" | Undisciplined action wastes time. Skills prevent this. |
| "I know what that means" | Knowing the concept ≠ using the skill. Invoke it. |

## Platform Reference

This repository is dedicated solely to **Claude Code**:
- Refer to `references/claude-code-tools.md` for specific tool parameters (`Agent`, `subagent_type`, `model`, `effort`).

## User Instructions

User instructions (CLAUDE.md, AGENTS.md, GEMINI.md, etc, direct requests) take precedence over skills, which in turn override default behavior. Only skip skill workflows or instructions when your human partner has explicitly told you to.
