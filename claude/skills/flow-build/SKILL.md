---
name: flow-build
description: Step 6 of the 10-step product workflow (Frame, Bet, Probe, Slice, Scaffold, Build, Verify, Ship, Release, Learn). Executes the craft on one slice — test-first at the boundary, small commits on trunk, continuous review, refactoring only under green. Use this whenever implementation is about to start, whenever someone asks how to approach writing a feature, whenever a pull request is growing large or sitting unreviewed, and whenever TDD, refactoring, or code review practice comes up. Includes when to loosen the discipline at Explore stage.
---

# Build — step 6 of 10

## Purpose

Turn one slice into integrated, working software, with the feedback loop as short as it can be made.

## The loop, per example

1. **Example** — state one concrete case: given this input, this observable output. A sentence, not a spec.
2. **Failing test** at the boundary the example describes: HTTP, CLI argument, message, function signature.
3. **Fake it** — hardcode the return. Green. This proves the wiring, not the behaviour.
4. **Triangulate** — add the second and third example. The hardcoded value dies because the tests force it out.
5. **Refactor under green** — rename until the code reads like the example. Extract only what duplication demands. Small moves, green between each.
6. **Commit** — every green refactor. Push to trunk at least daily.

## Review

Continuous, not batched. Pairing, or small pull requests reviewed within hours. Batching review until implementation is finished reintroduces exactly the long feedback loop this step exists to remove — and is the current failure mode of AI-accelerated teams, where throughput rises and review becomes the bottleneck.

Solo: the review is the test suite plus a static-analysis gate. Batch size discipline matters more, not less.

## Listen to the tests

- Painful setup means bad coupling. Fix the design, not the test.
- Slow tests mean the boundary is in the wrong place.
- A test you must change to make a refactor pass was testing implementation.

## Stage adaptation

At **Explore** stage, when the half-life of the code is hours and the goal is experiments per unit time, use spike-and-stabilise: throwaway code to find the shape, then rewrite what survives, test-first. Test the core domain — the pricing rule, the sync algorithm, the state machine. Not CRUD, not glue.

Switch to full discipline at the point where paying users have data you cannot afford to corrupt. Missing that transition is a more common failure than starting too loose.

## Done when

The slice is integrated on trunk and green.

## Anti-patterns

- Writing production code with no failing test (outside a declared spike).
- Refactoring with a red test.
- Long-lived branches.
- Designing abstractions ahead of the code that needs them. Extract from working code instead.

## Hand off

Pass to `flow-verify`.
