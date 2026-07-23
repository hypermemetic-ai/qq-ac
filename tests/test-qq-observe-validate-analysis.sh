#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2034
set -euo pipefail

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
TEST_NAME="test-qq-observe-validate-analysis"
# shellcheck source=tests/helpers.sh
source "$TESTS_DIR/helpers.sh"
ROOT="$(cd "$TESTS_DIR/.." && pwd -P)"
OBSERVE="$ROOT/bin/qq-observe"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
export XDG_STATE_HOME="$tmp/state"

session="$tmp/session.jsonl"
cat >"$session" <<'JSONL'
{"type":"session","version":3,"timestamp":"2026-07-23T00:00:00Z"}
{"type":"message","timestamp":"2026-07-23T00:00:01Z","message":{"role":"assistant","content":[{"type":"text","text":"done"}]}}
JSONL

valid="$tmp/valid.json"
jq -n --arg session "$session" '
  def episode($title; $confidence; $tokens; $kind; $location): {
    kind:$kind,
    title:$title,
    sessions:[$session],
    evidence:[{session:$session,entries:[2],quote:"done"}],
    what_happened:"A cited event happened.",
    root_cause:"A cited harness cause.",
    root_cause_location:$location,
    cost:{turns:1,tokens:$tokens,seconds:1.5,source:"facts.json#/token_usage/output"},
    remedy:{type:"harness-redesign",smallest_change:"Change one harness rule."},
    confidence:$confidence,
    confidence_why:"The citation is direct.",
    recurrence_key:$title
  };
  {
    schema:"qq-observer.analysis",
    schema_version:1,
    run:{change:"T-142-fixture",sessions:[$session]},
    episodes:[
      episode("Low tokens high";"high";10;"waste";"agent-behavior"),
      episode("High tokens high";"high";50;"design-question";"harness-design"),
      episode("Medium huge";"medium";1000;"friction";"instruction"),
      episode("Zulu low tie";"low";7;"substrate";"substrate"),
      episode("Alpha low tie";"low";7;"failure";"tool")
    ],
    dropped_signals:[{kind:"compaction",entries:[2],why:"Benign fixture signal."}],
    limitations:"Fixture analysis."
  }
' >"$valid"

(
  cd "$ROOT"
  "$OBSERVE" validate-analysis "$valid" "$session"
) >"$tmp/ranked.json" 2>"$tmp/ranked.stderr"
[ ! -s "$tmp/ranked.stderr" ] || fail 'valid analysis emitted stderr'
jq -e '
  [.episodes[].title] == [
    "High tokens high",
    "Low tokens high",
    "Medium huge",
    "Alpha low tie",
    "Zulu low tie"
  ]
  and [.episodes[].rank] == [1,2,3,4,5]
' "$tmp/ranked.json" >/dev/null \
  || fail 'valid analysis was not ranked by confidence, tokens, then title'

expect_analysis_failure() {
  local name="$1" analysis="$2"
  set +e
  (
    cd "$ROOT"
    "$OBSERVE" validate-analysis "$analysis" "$session"
  ) >"$tmp/$name.stdout" 2>"$tmp/$name.stderr"
  local status=$?
  set -e
  assert_equal 1 "$status" "$name did not exit 1"
  [ ! -s "$tmp/$name.stderr" ] || fail "$name emitted stderr instead of failure JSON"
  jq -e '
    .schema == "qq-observer.analysis"
    and .schema_version == 1
    and .status == "analysis_failed"
    and (.reason | type) == "string"
  ' "$tmp/$name.stdout" >/dev/null || fail "$name did not emit analysis_failed JSON"
}

jq '.episodes[0].evidence[0].entries = [99]' "$valid" >"$tmp/bad-index.json"
expect_analysis_failure bad-index "$tmp/bad-index.json"

jq '.episodes[0].evidence[0].session = "/not/in/the/package.jsonl"' \
  "$valid" >"$tmp/unknown-session.json"
expect_analysis_failure unknown-session "$tmp/unknown-session.json"

jq '.episodes += [.episodes[0]]' "$valid" >"$tmp/six-episodes.json"
expect_analysis_failure six-episodes "$tmp/six-episodes.json"

jq 'del(.episodes[0].root_cause)' "$valid" >"$tmp/missing-field.json"
expect_analysis_failure missing-field "$tmp/missing-field.json"

jq '.episodes[0].kind = "not-a-kind"' "$valid" >"$tmp/bad-kind.json"
expect_analysis_failure bad-kind "$tmp/bad-kind.json"

jq '.episodes[0].evidence[0].quote = ([range(0;201)] | map("x") | join(""))' \
  "$valid" >"$tmp/long-quote.json"
expect_analysis_failure long-quote "$tmp/long-quote.json"

failed_input="$tmp/failed-input.json"
cat >"$failed_input" <<'JSON'
{"schema":"qq-observer.analysis","schema_version":1,"status":"analysis_failed","reason":"observer could not read its package"}
JSON
(
  cd "$ROOT"
  "$OBSERVE" validate-analysis "$failed_input" "$session"
) >"$tmp/failed-output.json" 2>"$tmp/failed-output.stderr"
[ ! -s "$tmp/failed-output.stderr" ] || fail 'analysis_failed pass-through emitted stderr'
jq -S -c . "$failed_input" >"$tmp/failed-expected.json"
if ! cmp -s "$tmp/failed-expected.json" "$tmp/failed-output.json"; then
  diff -u "$tmp/failed-expected.json" "$tmp/failed-output.json" >&2 || true
  fail 'valid analysis_failed input did not pass through'
fi

printf 'test-qq-observe-validate-analysis: pass\n'
