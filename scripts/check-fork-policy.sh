#!/usr/bin/env bash
# Fork-policy guards for duwscan/superpowers — invariants a clean upstream
# merge can silently break. See docs/FORK-SYNC.md.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"
failures=0

# 1. The deleted using-git-worktrees skill must not reappear in skills/ or README.
if grep -rqn "using-git-worktrees" skills/ README.md; then
  echo "POLICY VIOLATION: using-git-worktrees reintroduced in:"
  grep -rln "using-git-worktrees" skills/ README.md
  failures=1
else
  echo "OK: no using-git-worktrees references in skills/ or README.md"
fi

# 2. Check skills directory count and forbidden subagent skills
skill_count=$(find skills -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
if [ "$skill_count" -ne 11 ]; then
  echo "POLICY VIOLATION: expected 11 skills in skills/, found $skill_count"
  failures=1
else
  echo "OK: exactly 11 skills in skills/"
fi

if [ -d "skills/subagent-driven-development" ] || [ -d "skills/dispatching-parallel-agents" ]; then
  echo "POLICY VIOLATION: subagent skills reintroduced in skills/"
  failures=1
else
  echo "OK: no subagent skills in skills/"
fi

# 3. skills/ must not reference docs/superpowers/ (specs/plans default to docs/specs/ and docs/plans/).
if grep -rqn "docs/superpowers" skills/; then
  echo "POLICY VIOLATION: docs/superpowers reintroduced in skills/:"
  grep -rln "docs/superpowers" skills/
  failures=1
else
  echo "OK: no docs/superpowers references in skills/"
fi

exit "$failures"
