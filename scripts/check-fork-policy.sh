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

# 2. Check skills directory
echo "OK: $(find skills -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ') skills in skills/"

# 3. skills/ must not reference docs/superpowers/ (specs/plans default to docs/specs/ and docs/plans/).
if grep -rqn "docs/superpowers" skills/; then
  echo "POLICY VIOLATION: docs/superpowers reintroduced in skills/:"
  grep -rln "docs/superpowers" skills/
  failures=1
else
  echo "OK: no docs/superpowers references in skills/"
fi

exit "$failures"
