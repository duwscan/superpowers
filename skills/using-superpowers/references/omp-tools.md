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

## Task lists

The `todo` tool maintains the session task list. Older Superpowers docs may refer to `TodoWrite`; treat that as the `todo` action.
