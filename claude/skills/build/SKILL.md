---
name: build
description: "Phase of the product workflow (Frame, Bet, Build or Experiment, Release, Learn). Delivery branch. Turns a delivery bet into a verified increment live in production behind a closed feature flag. Fills whatever frame or bet context is missing, decides whether slicing is needed, sets the verification strategy (acceptance criteria and the lowest test level per risk) before any code, then runs slice, implement and verify in order. Use when work on a feature, product increment or delivery bet is about to start, with or without a frame doc. Do not use for compiling, running a build command, or fixing a broken build."
argument-hint: [frame doc or subject]
---

# Build

## Purpose

Take a delivery bet to production, dark, with the feedback loop as short as it can be made. Build is
also the entry point for doing work: it works with a complete frame doc, a partial one, or none.

## Entry

An open slot, typed delivery. If that does not exist yet, step 1 establishes it.

## Procedure

1. **Establish context.** Build needs Problem, Appetite and Sketch from the frame doc, and a
   delivery bet holding a slot. For each gap, say what is missing and which skill you are calling,
   then call it:
   - No frame doc: `frame`, seeded with the subject.
   - A frame doc with blank Problem, Appetite or Sketch: `decide` on that doc.
   - No `## Bet`: `bet`. A refused slot stops build here.

   A missing Hypothesis does not block build. Flag it: `release` cannot run without it.
2. **Decide on slicing.** One slice is enough when the work is a single reviewable change that can
   be deployed alone inside the feedback interval, in a component that already exists. Otherwise
   slice, with slice zero as the walking skeleton when the component is new. Decide the obvious case
   and say why; ask only when it is genuinely unclear. With one slice, write it as the only entry in
   `### Slices` and skip `slice`.
3. **Set the verification strategy**, before any code:
   - Acceptance criteria, derived from Problem and Sketch, that the increment must pass.
   - List what could break. Assign each to the lowest level that can catch it, and keep a test only
     if the level below cannot:
     - **Unit**: logic, branching, calculation, state transitions. Fast, numerous, no I/O.
     - **Integration**: one per real boundary, against the real thing: real database, real broker,
       real third-party contract. Containers, not mocks.
     - **End-to-end**: a handful, on paths where failure costs money or data. Never a regression
       suite.
     - **Static analysis**: in the same gate. It catches a class of defect no test targets.
   - All of it runs in the pipeline. If a human has to run it, it does not count.
4. **Run the activities in order, without asking in between:**
   1. `slice`, when step 2 said so.
   2. `implement`, once per slice, in order, against the strategy.
   3. `verify`, on the increment as a whole.

Trunk-based development and feature flags must exist. If they do not, they are slice zero.

## Exit test

The acceptance criteria pass and the increment is in production behind a closed flag.

## Anti-patterns

- Writing code before the strategy exists.
- Slicing a one-line change, or not slicing a new component.
- Testing at every level for its own sake, or coverage percentage as a target.
- QA as a phase after implementation. It is a gate inside the loop.
- Exiting at "in production, not visible" without trunk and flags. The phases collapse back into a
  release train.

## Artifact

Reads the frame doc. Sets `status: building`. Appends:

```markdown
## Build
### Slicing     one slice, or sliced, and why
### Strategy    acceptance criteria, test level per risk
### Slices      written by slice
### Verify      written by verify
```

## Hand off

State what is deployed and behind which flag, offer `release`, and wait.
