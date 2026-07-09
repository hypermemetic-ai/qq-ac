---
id: TASK-25
title: Make parallel-ok load-bearing or add explicit mutual exclusion
status: To Do
assignee: []
created_date: '2026-07-09 14:41'
labels:
  - tooling
  - parallel-ok
  - hitl
dependencies: []
priority: high
ordinal: 22000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Reported from the meeting-reviewer session, 2026-07-09, and verified against main: the 'parallel-ok' label is decorative. It appears in eleven backlog task files and twice in qq-methodology.md prose, and in ZERO lines of bin/ or skills/ ('grep -rn parallel-ok bin/ skills/' returns nothing). bin/qq-frontier drops a task when that task itself is claimed (a task-<id> branch exists), but two UNCLAIMED tasks that collide on the same files are both eligible and can be dispatched into the same wave. That leaves two bad workarounds: a false dependency edge, which over-serializes and inverts priority, or conductor prose, which nothing checks. The reporter's concrete case: their TASK-11 collides with TASK-7 on one file and with TASK-8 on two others, yet all three must be co-eligible, so the mutex now lives as prose in the task files. Decide: make 'parallel-ok' actually load-bearing, or add a first-class mutex/exclusive-with field that qq-frontier reads and a wave dispatcher honors. A triage invariant the methodology enforces in prose and nothing enforces in code is worse than no label.
<!-- SECTION:DESCRIPTION:END -->
