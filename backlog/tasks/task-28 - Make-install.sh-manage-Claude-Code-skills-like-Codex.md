---
id: TASK-28
title: Make install.sh manage Claude Code skills like Codex
status: In Progress
assignee: []
created_date: '2026-07-14 03:01'
updated_date: '2026-07-14 03:28'
labels: []
dependencies:
  - TASK-27
priority: medium
ordinal: 25000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
From the 2026-07-13 architecture review: install.sh live-links skills only into ~/.codex/skills while ~/.claude/skills is hand-maintained and has drifted (missing bpmn-plans, deliver-change, openwiki-maintainer).
Operator-settled decision: the installer manages both runtimes symmetrically with identical link/prune/refuse semantics.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 install.sh links every qq skill into ~/.claude/skills and prunes dead qq-owned links there, same semantics as ~/.codex/skills
- [ ] #2 Non-qq entries in ~/.claude/skills are never touched or replaced
- [ ] #3 Running bin/install.sh heals the current three-skill drift
- [ ] #4 README.md installer description covers both runtimes
<!-- AC:END -->
