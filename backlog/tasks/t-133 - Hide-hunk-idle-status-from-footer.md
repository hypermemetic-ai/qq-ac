---
id: T-133
title: Hide hunk idle status from footer
status: To Do
assignee: []
created_date: '2026-07-21 06:39'
labels: []
dependencies: []
ordinal: 58000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
pi-hunk publishes 'hunk · ready' to the extension status row when idle; it only carries signal during active /hunk review sessions (note counts, re-review due). Operator finds the persistent idle line noise.

Decision ledger: operator verbatim instruction — 'Hide it entirely' (asked-and-answered; alternatives presented: hide vs move inline vs leave). Mechanism: add 'hunk' to extensionStatusRow.hiddenKeys in extensions/pi-footer.json; pi-hunk itself has no status-only toggle, and /hunk review functionality is unaffected.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 footer status row no longer renders the hunk status (verified headless with mock statuses)
- [ ] #2 Change lands as one PR; operator merges
<!-- AC:END -->
