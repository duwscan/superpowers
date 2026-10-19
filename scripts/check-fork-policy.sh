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

# 2. Every skills/<name>/ directory must have a .muse-plugin/plugin.json
#    entry, and vice versa, so upstream's new skills get registered.
python3 - <<'EOF' || failures=1
import json, os, sys

skills = sorted(d for d in os.listdir("skills") if os.path.isdir(os.path.join("skills", d)))
listed = sorted(e["id"] for e in json.load(open(".muse-plugin/plugin.json"))["capabilities"]["skills"])
missing = [s for s in skills if s not in listed]
extra = [s for s in listed if s not in skills]
if missing or extra:
    print("POLICY VIOLATION: .muse-plugin/plugin.json out of sync with skills/")
    print(f"  skills without manifest entry: {missing}")
    print(f"  manifest entries without skill: {extra}")
    sys.exit(1)
print(f"OK: {len(skills)} skills, all registered in .muse-plugin/plugin.json")
EOF

exit "$failures"
