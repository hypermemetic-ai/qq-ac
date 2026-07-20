# Review guidelines

These owned rules ride the review engine's injection surfaces. A review brief
adds Change-specific intent, ownership boundary, non-goals, threat model, and
declared trust boundaries. Where it declares scope, the brief wins.

## Scope

- Review the Change, not the Repository. Report only material failures it
  introduced across correctness, security, reliability, intent, and standards
  no tool enforces.
- Honor the declared threat model. Its out-of-scope finding classes are
  owner-declined and do not affect the verdict. Review a drift-net against its
  threat model, never as a security boundary.
- A correctly implemented but unapproved responsibility is an intent finding.
- Review moves and deletions through their invariants, not unchanged bodies.

## Finding shape

- Every finding states the failure and names the file, line, concrete failure
  path, and supporting evidence. A remedy that wants a fence cites the brief's
  declared trust boundary; an empty citation means shrink.
- Fence-or-shrink is a lookup against declared boundaries, never origin
  archaeology. A fence is legitimate only at a cited boundary. Prescriptions
  are never addition-shaped: price both the guard and state-space-removal forms.
  An interior guard surviving the mechanical same-fix-smaller test may stand,
  labeled as interior.
- A code smell is a heuristic, not a violation. Report only a concrete future
  cost supported by diff or history, weigh counterevidence such as generated,
  boundary, compatibility, or deliberate bounded-context code, and never
  prescribe refactoring from a label.

## Remedy and gates

- The smallest remedy is the smallest resulting system after the Change; diff
  size only breaks ties. A state-space-shrinking or preserving remedy inside
  the agreed boundary is pre-authorized and appears in the completion envelope;
  boundary changes still align.
- Always display parallel, unblended net production-LOC and decision-point
  deltas per fix commit on completion and review surfaces. Growth in either
  spends one mechanical same-fix-smaller regeneration in the implementer's
  loop. Checks pass and strictly smaller takes it; otherwise the original
  stands without justification prose.
- Block only at shape. Merge-boundary gates are only-down budgets over counts
  such as complex functions or long files. Trend gauges, including fix-net
  percentage and health composites, gate nothing.
- Put obligations only where retry is cheap (the implementer's loop) or firing
  is rare (a shape budget); provide information elsewhere. Blended gates are
  gameable and undiagnosable; high-base-rate per-Change obligations become rote.

## Context gaps

A hole yields a context-gap report, not improvisation: name the missing or
contradictory fact, why the verdict depends on it, and evidence inspected. A
context gap is neither finding nor pass.
