---
name: implement
description: "Activity inside the Build phase (Slice, Implement, Verify) of the product workflow, and the test-first loop for any behaviour change. Implements one slice outside-in: acceptance test first, red/green/refactor, small commits, review, merge to trunk, then confirms the pipeline deployed it dark behind a closed feature flag. Use when implementation of a feature, slice or behaviour change is about to start, when someone asks how to approach writing it, when a pull request is growing large or sitting unreviewed, and when TDD or refactoring practice comes up. Do not use for config, docs, or refactors with no behaviour change."
argument-hint: [frame doc, slice or behaviour]
---

# Implement

## Purpose

Turn one slice into integrated, working software in production, with the feedback loop as short as
it can be made.

## Entry

One slice from `### Slices`, or any behaviour change. No frame doc is required.

## The loop, per example

Start from the acceptance test, at the level `### Strategy` assigns. With no strategy recorded, use
the lowest level that catches the behaviour.

1. **Example**: one concrete case. Given this input, this observable output. A sentence, not a spec.
2. **Failing test** at the boundary the example describes: HTTP, CLI argument, message, function
   signature. Outside-in: the acceptance test first, then the units it drives.
3. **Fake it**: hardcode the return. Green. This proves the wiring, not the behaviour.
4. **Triangulate**: add the second and third example. The hardcoded value dies because the tests
   force it out.
5. **Refactor under green**: rename until the code reads like the example. Extract only what
   duplication demands. Small moves, green between each.
6. **Commit** every green refactor. Merge to trunk at least daily.

## Review

Continuous, not batched: pairing, or small pull requests reviewed within hours. Batching review
until implementation is finished reintroduces the long feedback loop this activity exists to remove.
Solo, the review is the test suite plus a static-analysis gate.

Architectural choices made along the way go to `adr`.

## Deploy

No human decision here. Merge to trunk with the gates green, and the pipeline builds, tests,
publishes and deploys to production with the new behaviour behind a closed flag. Confirm it is
running: health check, logs, no change in error rate. A manual step anywhere means the walking
skeleton is incomplete.

## Listen to the tests

- Painful setup means bad coupling. Fix the design, not the test.
- Slow tests mean the boundary is in the wrong place.
- A test you must change to make a refactor pass was testing implementation.

## Stage adaptation

At the explore stage, when the half-life of code is hours, spike and stabilise: throwaway code to
find the shape, then rewrite what survives, test-first. Test the core domain (the pricing rule, the
sync algorithm, the state machine), not CRUD or glue. Switch to full discipline once paying users
have data you cannot afford to corrupt.

## Exit test

The slice is on trunk, green, deployed behind a closed flag, and healthy.

## Anti-patterns

- Production code with no failing test, outside a declared spike.
- Refactoring on red.
- Long-lived branches.
- Abstractions designed ahead of the code that needs them. Extract from working code.
- Mocking the boundary you were trying to verify.
- Deploying and exposing in one move, so rollback means redeploy.
- Holding finished work back to bundle it into a bigger release.

## Artifact

Reads `### Strategy` and `### Slices` when a frame doc exists. Ticks the slice in `### Slices`, creating `## Build` and the entry if absent.

## Hand off

When `build` called this, return to it. Invoked on its own inside a bet: state what is deployed,
offer to run the rest of Build (remaining slices, then `verify`) once, and wait. Outside a bet, stop
at the exit test.
