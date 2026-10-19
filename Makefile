# Fork maintenance targets for duwscan/superpowers.
# See docs/FORK-SYNC.md for the full sync procedure.

UPSTREAM_REMOTE := upstream
UPSTREAM_BRANCH := main
MARKETPLACE     := superpowers
PLUGIN_ID       := duwscan-s-superpowers@$(MARKETPLACE)
VERSION         ?=

.PHONY: help sync sync-verify sync-push test check-fork-policy validate push dist-update bump-version bump-check

help:
	@echo "Fork maintenance targets:"
	@echo "  make sync                  Fetch upstream, show incoming commits, merge into main"
	@echo "  make sync-verify           test + check-fork-policy + validate (run after resolving conflicts)"
	@echo "  make sync-push             push + dist-update"
	@echo "  make test                  Fast deterministic tests (OMP extension, SDD workspace)"
	@echo "  make check-fork-policy     Guard fork invariants (no worktree skill, manifest parity)"
	@echo "  make validate              claude plugin validate ."
	@echo "  make push                  git push origin main"
	@echo "  make dist-update           Refresh local OMP marketplace catalog + upgrade install"
	@echo "  make bump-version VERSION=x.y.z   Bump version across all manifests"
	@echo "  make bump-check            Report version drift"

sync:
	@git fetch $(UPSTREAM_REMOTE)
	@echo "=== Incoming upstream commits ==="
	@git log --oneline main..$(UPSTREAM_REMOTE)/$(UPSTREAM_BRANCH)
	@# Merge prints "Already up to date." when there is nothing new.
	@echo "=== Merging $(UPSTREAM_REMOTE)/$(UPSTREAM_BRANCH) ==="
	@git merge $(UPSTREAM_REMOTE)/$(UPSTREAM_BRANCH)
	@echo ""
	@echo "If conflicts appeared: resolve them per docs/FORK-SYNC.md, then run:"
	@echo "  make sync-verify && make sync-push"

sync-verify: test check-fork-policy validate

test:
	bash tests/omp/run-tests.sh
	bash tests/claude-code/test-sdd-workspace.sh
check-fork-policy:
	bash scripts/check-fork-policy.sh

validate:
	claude plugin validate .

push:
	git push origin main

dist-update:
	omp plugin marketplace update $(MARKETPLACE)
	omp plugin upgrade $(PLUGIN_ID)

bump-version:
ifndef VERSION
	@echo "Usage: make bump-version VERSION=x.y.z"; exit 2
endif
	bash scripts/bump-version.sh $(VERSION)

bump-check:
	bash scripts/bump-version.sh --check
