---
id: TASK-10
title: 'Evaluate the gate: what is no-mistakes actually buying us'
status: To Do
assignee: []
created_date: '2026-07-08 15:53'
labels: []
dependencies: []
priority: high
ordinal: 10000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Operator (07-08): 'first we figure out what no-mistakes is doing for us.' Inventory real runs — what the pipeline catches vs what it costs. Evidence from the document-stack landing: 6 review rounds, 8 findings of which 7 were real (incl. a genuine self-bypass hole in our own registry check) and 1 refuted (backlog config casing); but wall-clock was dominated by multi-minute LLM review rounds plus silent parked states. Decide: keep as-is, trim (fewer rounds / lower effort), or replace. If it stays, task-11 executes the visibility+latency fix.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 A written keep/trim/replace decision with per-run evidence (findings caught, false rate, wall-clock, parked time)
<!-- AC:END -->
