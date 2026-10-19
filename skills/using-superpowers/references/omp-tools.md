# OMP Tool Mapping

Skills speak in actions ("dispatch a subagent", "create a todo", "read a file"). On OMP (Oh My Pi) these resolve to the tools below.

| Action skills request | OMP equivalent |
| --- | --- |
| Invoke a skill | `read skill://<skill-name>/SKILL.md` — native skills are listed in your system prompt by name and description |
| Dispatch a subagent (`Subagent (general-purpose):` template) | `task` tool — read-only `scout` agent for investigation, general `task` agent for implementation |
| Task tracking ("create a todo", "mark complete") | `todo` tool |
| Read / create / edit files | `read`, `write`, `edit` |
| Run shell commands | `bash` |
| Search file contents / find files | `grep`, `glob` |
| Web search | `web_search` |
| Ask your human partner a question | `ask` |

## Skills

OMP loads Superpowers skills natively. Each skill appears in the system prompt as a name and description; load the full body on demand with `read skill://<skill-name>/SKILL.md`. Files inside a skill directory resolve via `skill://<skill-name>/<relative-path>`. A human can also invoke `/skill:<name>` directly — when that happens the skill content is injected for you.

## Subagents

The `task` tool dispatches subagent sessions with a fresh context. Give each subagent a self-contained prompt containing the full task text — the child cannot see your conversation. Use the read-only `scout` agent for codebase research and the general `task` agent for implementation. For `subagent-driven-development`, dispatch one plan task per subagent and review the result yourself before proceeding.

## Model routing on dispatches

Superpowers' Model Selection rules — cheapest tier for transcription implementers, a mid-tier floor for reviewers and prose implementers, most capable for design work and the final whole-branch review — map onto OMP like this:

- **The `task` tool has no per-call `model` parameter.** Each spawn resolves its model from `task.agentModelOverrides` (a setting), then the agent definition's frontmatter, then the configured task-role/session fallback. The last hop is OMP's version of the omitted-model trap: an unconfigured agent silently inherits your session's model.
- **Pick the `agent` per tier.** Bundled agents: `scout` (read-only investigation), `task` (implementation), `reviewer`, `security-reviewer`. To pin real tiers, define agents with a `model:` line in `.omp/agents/` (project) or `~/.omp/agent/agents` (user) — e.g. a cheap-model implementer and a capable-model reviewer — or ask your human partner to set `task.agentModelOverrides`. Models tagged with `^` in the composer become `m1`/`m2`… pseudo-agents usable as the `agent` value.
- **Set `solutionSpace` honestly — it is the effort signal.** For `auto`-thinking agents (the bundled `task`), `solutionSpace` is the only input the effort classifier sees: `"one fix: <names given>"` for transcription tasks, `"design open: <what remains>"` for judgment work. Never widen it to make a task sound harder.
- **Per-item `effort` (`lo`/`med`/`hi`) requires `task.enableEffort=true`** (default off). With it on, pass `effort` per spawn per the skill's tier rules; it overrides the agent's configured thinking selector.
- **Escalation and the final review** (fix-loop rounds 4-5, whole-branch review): dispatch on a higher-tier agent than the one that got stuck — a capable-model agent or a tagged model agent, never the session default by accident.

## Task lists

The `todo` tool maintains the session task list. Older Superpowers docs may refer to `TodoWrite`; treat that as the `todo` action.
