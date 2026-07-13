---
id: doc-30
title: Plan — Bound OpenWiki correction retries
type: other
created_date: '2026-07-13 16:16'
updated_date: '2026-07-13 16:20'
---
TASK-21 plan for replacing OpenWiki's unbounded whole-generation correction loop with proportional diagram-bundle rejection and a one-retry ceiling. Internal generator semantic authorship, single-writer locking, and reset-on-new-main behavior remain unchanged.

![Plan — Bound OpenWiki correction retries](assets/doc-30/plan.png)

The deterministic source specification is `assets/doc-30/plan-spec.json`; the semantic BPMN is `assets/doc-30/plan.bpmn`.
