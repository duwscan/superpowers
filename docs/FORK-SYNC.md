# Syncing the fork with upstream

This fork (`duwscan/superpowers`, branch `main`) tracks upstream `obra/superpowers`
(remote `upstream`). It carries deliberate fork-specific changes that must survive
every sync:

1. **No git-worktree usage** — the `using-git-worktrees` skill is deleted; SDD and
   executing-plans work on a feature branch in the current checkout.
2. **Oh My Pi (OMP) support** — `.omp/extensions/superpowers.ts` bootstrap,
   `references/omp-tools.md`, `omp.extensions` in `package.json`, `tests/omp/`.
3. **Plugin renamed to `duwscan-s-superpowers`** in `.claude-plugin/` (the shared
   OMP/Claude Code distribution identity), with homepage/repository pointing at
   the fork.
4. **Specs and plans default to `docs/specs/` and `docs/plans/`** — `brainstorming`
   and `writing-plans` save artifacts to `docs/specs/` and `docs/plans/` instead of
   `docs/superpowers/specs/` and `docs/superpowers/plans/` to keep consumer projects
   clean of vendor namespaces.

Upstream PRs land on `dev`; releases are cut to `main`. Sync from `upstream/main`
(stable releases only).

## Quick path

```bash
make sync          # fetch upstream, show incoming commits, merge
# resolve conflicts if any, then:
make sync-verify   # tests + fork-policy checks + plugin validation
make sync-push     # push, then refresh the local OMP marketplace install
```

## Merge rules per conflict area

| File | Why it conflicts | Resolution |
|---|---|---|
| `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json` | Upstream bumps `version` every release; fork changed `name` + URLs | Take upstream's **version**, keep fork's **name** (`duwscan-s-superpowers`) and URLs |
| `README.md`, `RELEASE-NOTES.md` | Both sides edit | Take upstream's text, re-add the fork's OMP install section and the 6-step workflow if overwritten |
| `skills/subagent-driven-development/SKILL.md`, `skills/executing-plans/SKILL.md` | Fork removed worktree usage; upstream iterates on these skills constantly | Merge block by block; preserve the fork policy: feature branch, no worktree |
| `tests/claude-code/*` | Fork deleted the two worktree tests | Modify/delete conflict → delete again. New upstream worktree tests merge clean but will fail — remove or adapt them |
| `.muse-plugin/plugin.json` | Fork dropped one skill entry; upstream adds new skills to the same list | Add upstream's new entries, keep `using-git-worktrees` absent |

Use `git merge upstream/main` (not rebase): the fork commits are pushed and
published via the marketplace catalog; rebasing would force-push and break
installed copies.

## Semantic checks git will not do

A clean merge can still reintroduce fork violations in new upstream prose.
`make check-fork-policy` runs these guards:

1. **No worktree reintroduction** — `using-git-worktrees` must not reappear in
   `skills/` or `README.md`. Note: `finishing-a-development-branch` legitimately
   mentions worktree *cleanup*, and `requesting-code-review/code-reviewer.md`
   uses a `/tmp` worktree as a read-only reviewer checkout — both stay.
2. **Skill/manifest count parity** — every `skills/<name>/` directory must have
   an entry in `.muse-plugin/plugin.json` (and vice versa), so upstream's new
   skills get registered.
3. **No `docs/superpowers` in skills** — skills must not reintroduce
   `docs/superpowers/` paths for specs or plans.

## Version bumps

After a sync that brings a new upstream version, or before publishing fork
changes:

```bash
make bump-version VERSION=7.0.1   # scripts/bump-version.sh across all manifests
make bump-check                    # report drift
```

The renamed `.claude-plugin/` files are still tracked by `.version-bump.json`
by path — name changes do not affect bumping.

## Distributing the update

```bash
make push         # git push origin main
make dist-update  # refresh local OMP catalog + upgrade the installed plugin
```

Requires `jq` and `yq` on PATH (used by `scripts/bump-version.sh`).

```
omp plugin marketplace add duwscan/superpowers
omp plugin install duwscan-s-superpowers@superpowers
```
