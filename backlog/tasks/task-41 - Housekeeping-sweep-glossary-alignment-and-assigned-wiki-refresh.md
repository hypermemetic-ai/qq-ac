---
id: TASK-41
title: 'Housekeeping sweep: glossary alignment and assigned wiki refresh'
status: In Progress
assignee: []
created_date: '2026-07-14 22:47'
updated_date: '2026-07-15 01:08'
labels: []
dependencies:
  - TASK-39
documentation:
  - doc-42
ordinal: 38000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Per doc-42: clear Phase-4 vocabulary debt. CONCEPTS.md gains the new delegation vocabulary and its agent-messaging entry reflects the narrowed skill; the stale activation-chain description leaves the wiki through an assigned maintainer refresh.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 CONCEPTS.md defines work order and completion envelope, and its agent-messaging entry reflects cross-runtime coordination plus operator notifications
- [ ] #2 An assigned openwiki refresh lands as a maintainer docs pull request removing the deleted activation-chain description from openwiki/operations.md
- [ ] #3 Repository suites pass
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Implemented the glossary criterion: narrowed agent messaging, added work order and completion envelope definitions, and pinned all three in tests/test-qq-herdr-home.sh. All tests/test-*.sh pass. The BPMN pipeline is sandbox-limited: nested Node calls return spawnSync EPERM, so the owner must rerun that check outside the sandbox.
<!-- SECTION:NOTES:END -->
