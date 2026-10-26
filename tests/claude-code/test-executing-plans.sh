#!/usr/bin/env bash
# Test: executing-plans skill and single-session workflow
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Test: executing-plans skill ==="

CLAUDE_PROMPT_TIMEOUT="${CLAUDE_PROMPT_TIMEOUT:-60}"

# Test 1: Verify executing-plans skill is recognized
echo "Test 1: Check executing-plans skill recognition..."
output=$(run_claude "What is the executing-plans skill? Describe its key approach briefly." "$CLAUDE_PROMPT_TIMEOUT")

if assert_contains "$output" "executing-plans\|Executing Plans\|inline\|TDD" "Skill is recognized"; then
    echo "  Executing-plans skill documentation test passed"
else
    echo "  Skill recognition failed"
    exit 1
fi

echo "=== All executing-plans skill tests passed ==="
