---
id: TASK-26
title: Warn when a hitl task sits on an afk dependency path
status: To Do
assignee: []
created_date: '2026-07-09 14:41'
labels:
  - tooling
  - parallel-ok
  - afk
dependencies: []
priority: medium
ordinal: 23000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Reported from the meeting-reviewer session, 2026-07-09. Their chain TASK-12(afk) -> TASK-7(afk) -> TASK-9(hitl) -> TASK-8(afk) made 'qq-frontier --afk' return empty after TASK-7, stranding TASK-8, which was unattended-safe. CORRECTED MECHANISM: the report attributes this to the --afk filter running after dependency resolution (qq-frontier: status -> assignee -> unmet deps -> claimed -> afk). That ordering is real but is NOT the cause, and reordering the filter would be a no-op: TASK-8 is withheld because its dependency TASK-9 is not Done, and dependencies gate on status regardless of label. The actual gap is that nothing WARNS when an attended task is inserted into an unattended task's dependency path, silently halting a background wave. Add that lint (qq-frontier, or a registry check): for every afk task, if any transitive dependency is hitl, say so loudly. The reporter restructured to a DAG to work around it; the hazard survives the workaround.
<!-- SECTION:DESCRIPTION:END -->
