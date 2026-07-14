---
id: TASK-35
title: Phase 4 — Engine/glass split (harness-native delegation)
status: In Progress
assignee: []
created_date: '2026-07-14 05:10'
updated_date: '2026-07-14 21:00'
labels: []
dependencies:
  - TASK-34
documentation:
  - doc-38
  - doc-39
  - doc-40
ordinal: 32000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Per doc-38 Phase 4: code-review and research delegate via harness-native subagents (fresh context by isolation), keeping only brief-composition and verification protocol; agent-messaging narrows to cross-runtime coordination and operator notifications; herdr retained as cockpit tooling only.

Folded review-governance rules (settled 2026-07-14, doc-39 and doc-40): review briefs must carry the Change's threat model with finding classes declared out of scope, and the loop must enforce a convergence circuit-breaker — sustained same-class findings across rounds stop the fix loop and escalate a design decision to the operator, instead of feeding a patch queue. Owned rules ride vendor injection surfaces (REVIEW.md for harness reviews; AGENTS.md review guidelines for codex reviewers). Graft candidates from the cited surveys, in rough priority: falsification gate (a finding needs a constructed failing scenario or is discarded), numeric confidence threshold with a versioned exclusion taxonomy, codex-rubric proportionality rule, K-of-N stability scoring for contested findings, fresh-session systemic audit after loop convergence, review-fed compound capture, periodic reviewer calibration against seeded-defect corpora. Benchmark the owned skill against the native /code-review on the same diffs to notice when the vendor laps it.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 code-review and research run on harness-native subagents with no herdr pane lifecycle management
- [ ] #2 agent-messaging covers only cross-runtime coordination and operator-visible notification
- [ ] #3 Review briefs declare the Change's threat model and out-of-scope finding classes, and reviewer instructions ride the harness injection surfaces
- [ ] #4 The review loop enforces the convergence circuit-breaker: sustained same-class findings across rounds halt fixes and escalate a design decision to the operator
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Batch worked as four tickets on branch worktree-agent-aaf66d60b2d5239f0 (local only; accountable agent carries review and delivery).

T1 (AC #1) — no change needed: code-review and research already run on codex exec --sandbox read-only with zero herdr references in their skills (landed in TASK-38); bin/ and tests/ hold only kept cockpit tooling (qq-herdr-home, qq-herdr-pull per doc-38 Phase 4). Evidence: grep sweeps recorded in the implementation report.

T2 (AC #2) — commit 327faa3: agent-messaging rewritten to exactly cross-runtime coordination between live agents plus operator-visible notifications (herdr notification show); temporary-delegates lifecycle section dropped; stale delegate-start test pin in tests/test-qq-herdr-home.sh swapped for a reintroduction guard and a notification-surface pin.

T3 (AC #3) — commit 4491836: review briefs now declare the Change's threat model with out-of-scope finding classes (owner-declined by default); owned reviewer rules ride vendor injection surfaces — new REVIEW.md at repo root for harness-native reviews, AGENTS.md review-guidelines section routing codex reviewers to it; code-review skill states the brief/injection-surface split.

T4 (AC #4) — commit fd1449f: convergence circuit-breaker added to the fix loop (a new confirmed finding of a class already fixed in two earlier rounds halts fixes and escalates a design decision to the operator); falsification gate folded into verification (failure-claiming findings need a constructed failing scenario or are discarded).

Checks after each ticket: shell suite 7/7 pass; BPMN node tests 16 pass / 2 skipped / 0 fail (QQ_BPMN_SKIP_RENDER=1). Deferred graft candidates (not implemented, per work order): numeric confidence threshold with versioned exclusion taxonomy, codex-rubric proportionality rule, K-of-N stability scoring, fresh-session systemic audit after convergence, review-fed compound capture, reviewer calibration against seeded-defect corpora, owned-vs-native benchmark. Known stale derived surface: openwiki/architecture.md still describes the delegate pane lifecycle (maintainer-owned refresh).
<!-- SECTION:NOTES:END -->
