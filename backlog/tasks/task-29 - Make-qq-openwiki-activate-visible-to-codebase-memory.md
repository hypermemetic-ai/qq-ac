---
id: TASK-29
title: Make qq-openwiki-activate visible to codebase-memory
status: In Progress
assignee:
  - '@codex'
created_date: '2026-07-14 03:01'
updated_date: '2026-07-14 04:26'
labels: []
dependencies:
  - TASK-30
priority: medium
ordinal: 26000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
From the 2026-07-13 architecture review: the extensionless Python script bin/qq-openwiki-activate (the repo's most complex artifact) is absent from the codebase-memory graph, contradicting AGENTS.md's discovery protocol.
Operator-settled decision: rename the source to bin/qq-openwiki-activate.py, preserving the installed command name qq-openwiki-activate via the existing installer symlink; desktop handler Exec path unchanged.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Source lives at bin/qq-openwiki-activate.py; installer links ~/.local/bin/qq-openwiki-activate to it; desktop entry still resolves
- [x] #2 tests reference the new path and pass
- [x] #3 codebase-memory reindex of the repository shows the module's functions (evidence in PR)
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Preserve history by renaming the activation source to bin/qq-openwiki-activate.py.
2. Keep the installed qq-openwiki-activate command and desktop Exec stable by updating installer symlink creation.
3. Update every test and documentation source-path reference, then run focused and repository Checks.
4. Reindex with codebase-memory-mcp and capture graph evidence that activation functions are present.
5. Obtain independent code review, publish one green PR, finalize TASK-29 in the same Change, and hand off without merging.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Implemented the history-preserving source rename and kept the installed command/desktop Exec stable. Focused Checks passed: bash tests/test-qq-openwiki-activate.sh; bash tests/test-bin-resolution.sh; Bash and Python syntax; shellcheck -x on changed shell files. A full codebase-memory-mcp CLI reindex reported 1,963 nodes and 2,525 edges; an exact query for Function nodes at bin/qq-openwiki-activate.py returned 24 functions, including activate, dispatch, main, and verify_merge.
<!-- SECTION:NOTES:END -->
