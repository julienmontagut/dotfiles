---
name: flow-verify
description: Step 7 of the 10-step product workflow (Frame, Bet, Probe, Slice, Scaffold, Build, Verify, Ship, Release, Learn). Decides which test levels are worth running — unit, integration, end-to-end — by keeping only what catches something the level below cannot. Use this whenever test strategy, QA, coverage targets, a test pyramid, or a slow or flaky suite comes up, and whenever someone proposes testing "at all levels". Also use it to push back on QA as a phase after implementation.
---

# Verify — step 7 of 10

## Purpose

Buy confidence at the lowest possible cost in time. Every test that duplicates coverage from a lower level slows the loop without adding information.

## The rule

Keep a test only if it catches something the level below cannot.

- **Unit** — logic, branching, calculation, state transitions. Fast, numerous, no I/O.
- **Integration** — one per real boundary, against the real thing: real database, real broker, real third-party contract. Containers, not mocks.
- **End-to-end** — a handful, on paths where failure costs money or data. Never a regression suite.
- **Static analysis** — in the same gate. It catches a class of defect no test targets.

## Procedure

1. For each slice, list what could break.
2. Assign each to the lowest level that can catch it.
3. Delete anything left over that only re-tests a lower level.
4. Put all of it in the pipeline. If a human has to run it, it does not count.

## Done when

Gates pass automatically, with no manual step, and the suite is fast enough that nobody is tempted to skip it.

## Anti-patterns

- Testing at every level for its own sake.
- Coverage percentage as a target. It measures execution, not verification.
- QA as a phase after implementation. It is a gate inside the loop.
- Mocking the boundary you were trying to verify.

## Hand off

Pass to `flow-ship`.
