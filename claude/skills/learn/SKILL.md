---
name: learn
description: "Phase of the product workflow (Frame, Bet, Build or Experiment, Release, Learn). Closes the build-measure-learn loop on a released bet: measures the outcome against the frame doc's hypothesis, records an explicit continue, extend or kill decision, updates goals from the evidence, and emits new framed problems. Use after a feature, launch or initiative has been live long enough to observe, when a retrospective or post-launch review comes up, when a shipped feature has never been evaluated, or when deciding whether to remove a feature nobody uses. Do not use for explanations or tutorials."
argument-hint: [frame doc]
---

# Learn

## Purpose

Close the loop. Without this the hypothesis was decoration, and the product grows features nobody
ever justified. Kill must be a live option; if it never happens, the hypothesis was decorative.

## Entry

A frame doc with `status: released`.

## Procedure

1. **Measure** against the Hypothesis and its metric, read from the frame doc. Do not restate them
   from memory or soften them. Behaviour, not opinions. Talk to the people who did not adopt it;
   they carry more information than those who did.
2. **Decide**, out loud:
   - **Continue**: the metric moved. Stop working on it; the slot frees.
   - **Extend**: it partly moved and you can name what would move it further. That is a new frame
     with its own appetite, not an open-ended continuation.
   - **Kill**: it did not move. Remove the code, the flag, the menu entry and the documentation.
     Carrying dead features taxes every future change.
3. **Emit** the result as new frames through `frame`, and update `docs/goals.md` when the evidence
   says a goal or its direction was wrong. Goals change only on evidence from here.

## Exit test

The decision is recorded against the hypothesis, and the product reflects it, including the
deletion if that was the call.

## Anti-patterns

- Moving the goalposts after the fact.
- "It needs more time" with no new metric and no new appetite.
- Measuring output (shipped, delivered) instead of outcome.
- Keeping a feature because it was expensive to build. Sunk cost is not evidence.

## Artifact

Reads the frame doc. Sets `status: learned`, or `killed`. Appends `## Learn` with the decision, the
evidence and links to new frames. May edit `docs/goals.md`.

## Hand off

State the decision, offer `frame` for the new problems, and wait.
