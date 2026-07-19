#!/usr/bin/env bash
set -euo pipefail

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
TEST_NAME="test-qq-status"
# shellcheck source=tests/helpers.sh
source "$TESTS_DIR/helpers.sh"
ROOT="$(cd "$TESTS_DIR/.." && pwd -P)"
STATUS="$ROOT/bin/qq-status"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

repo="$tmp/repo"
git init -q -b main "$repo"
git -C "$repo" -c user.name=test -c user.email=test@example.com \
  commit --allow-empty -qm initial
mkdir -p "$tmp/runtime"
export TMPDIR="$tmp/runtime"

fake_herdr="$tmp/herdr"
cat >"$fake_herdr" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$*" >>"$FAKE_HERDR_LOG"
printf '%s\n' '{"result":{"shown":true}}'
SH
chmod +x "$fake_herdr"
export QQ_HERDR_BIN="$fake_herdr"
export FAKE_HERDR_LOG="$tmp/herdr.log"

status_args=(
  --repo "$repo"
  --dispatcher-workspace home-1
  --work-session change-1
  --pane change-1:p1
  --agent worker-1
  --ticket T-83
  --label engines
)

run_status() {
  local expected_exit="$1"
  shift
  set +e
  "$STATUS" "$@" >"$tmp/result.json"
  actual_exit=$?
  set -e
  assert_equal "$expected_exit" "$actual_exit" "unexpected qq-status exit"
  jq -e . "$tmp/result.json" >/dev/null
}

# Dispatched publishes the stage and presence with strictly increasing
# wall-clock-derived sequence values.
run_status 0 dispatched "${status_args[@]}" \
  --runtime codex --events "$tmp/events" --stderr "$tmp/stderr"
jq -e '
  .status == "done"
  and .state.herdr_available == true
  and (.state.sequences | length) == 2
  and .state.sequences[1] > .state.sequences[0]
' "$tmp/result.json" >/dev/null
assert_file_contains "$FAKE_HERDR_LOG" \
  'workspace report-metadata change-1 --source qq-dispatch --token stage=dispatched'
assert_file_contains "$FAKE_HERDR_LOG" \
  'pane report-agent change-1:p1 --source qq-dispatch --agent worker-1 --state working'

# The deleted batch-label interface is now an ordinary unknown argument.
run_status 1 dispatched "${status_args[@]}" --batch-label t107-followon
jq -e '.status == "error"' "$tmp/result.json" >/dev/null

# Terminal clears the token and releases presence with a fresh sequence for
# each call.
: >"$FAKE_HERDR_LOG"
run_status 0 terminal "${status_args[@]}"
jq -e '
  (.state.sequences | length) == 2
  and .state.sequences[1] > .state.sequences[0]
' "$tmp/result.json" >/dev/null
assert_file_contains "$FAKE_HERDR_LOG" '--clear-token stage'
assert_file_contains "$FAKE_HERDR_LOG" 'pane release-agent change-1:p1'

# Herdr absence degrades to a noted no-op and exit 0; visibility never gates
# the caller's automation contract.
export QQ_HERDR_BIN="$tmp/missing-herdr"
run_status 0 queued "${status_args[@]}"
jq -e '
  .status == "done"
  and .state.herdr_available == false
  and .state.degraded == true
  and any(.state.notes[]; contains("herdr unavailable"))
' "$tmp/result.json" >/dev/null

# Invalid events are command errors.
run_status 1 invented "${status_args[@]}"
jq -e '.status == "error"' "$tmp/result.json" >/dev/null

printf 'test-qq-status: pass\n'
