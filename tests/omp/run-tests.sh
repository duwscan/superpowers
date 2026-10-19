#!/usr/bin/env bash
# Unit tests for the OMP bootstrap extension (.omp/extensions/superpowers.ts).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
exec node --test "$SCRIPT_DIR/test-omp-extension.mjs"
