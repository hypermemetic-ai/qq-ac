---
name: code-review
description: Delegates review of a branch, PR, or work in progress to a fresh read-only reviewer and returns verified findings. Use when the user asks to review changes, a PR, a branch, or work since a fixed point.
---

# Review with fresh context

1. Define the exact change surface. Honor a supplied base; otherwise infer the
   target branch and merge-base. For work in progress, include committed,
   staged, unstaged, and untracked changes.
2. Find the owning Backlog task or supplied intent and the relevant repository
   rules.
3. Give that surface, intent, and those rules to one fresh read-only reviewer as
   a leaf worker that performs the review directly. Have it inspect surrounding
   code, callers, and tests, and report only material findings introduced by the
   change across correctness, security, reliability, intent, and non-tool-enforced
   standards. Each finding needs a file/line and concrete failure path.
4. Use Fowler's code smells as maintenance heuristics, never violations. Report
   one only when the diff or history shows a concrete future cost; weigh
   counterevidence such as deliberate bounded-context duplication, generated or
   boundary code, adapters/facades, and compatibility constraints. Prescribe no
   refactoring from a label alone.
5. Verify every finding against the repository and reproduce it when practical.
   Deduplicate, rank by impact, and report only confirmed findings. State when
   none remain. Stop at review unless the user asks for fixes.
