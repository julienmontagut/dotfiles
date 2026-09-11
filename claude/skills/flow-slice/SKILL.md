---
name: flow-slice
description: Step 4 of the 10-step product workflow (Frame, Bet, Probe, Slice, Scaffold, Build, Verify, Ship, Release, Learn). Cuts a confirmed bet into independently deliverable vertical increments, each of which can be put in front of a user alone. Use this whenever a plan, epic, milestone, or roadmap item needs breaking down, whenever work is being organised into phases or layers, or whenever a branch is about to live longer than a day. Applies to solo work too, where slicing limits sunk cost rather than coordinating people.
---

# Slice — step 4 of 10

## Purpose

Keep the batch small enough that being wrong is cheap and feedback arrives while it still matters.

## Procedure

1. List the outcomes the bet promises, in the user's language.
2. For each, cut a *vertical* slice: entry point through to storage and back, however thin. Never cut by layer, by component, or by team.
3. Check each slice against three tests:
   - Can it be delivered alone, with nothing else?
   - Would a user notice it?
   - Can it be thrown away without unpicking the others?
4. Order by risk: the slice most likely to invalidate the bet goes first.
5. Fit the slices inside the appetite. Whatever does not fit is cut, not deferred to "phase 2".

## Slicing solo

Slicing serves three purposes: parallelising across people, getting feedback early, and limiting sunk cost. Working alone, the first disappears and the third dominates. So slices can be coarser — a slice is "what I can put in front of a user this week", not "what fits a sprint board" — but the discipline still applies.

## Done when

No slice exceeds the feedback interval you can tolerate, and each is independently deliverable.

## Anti-patterns

- Horizontal slices: "the database layer", "the API", "the UI". None of them can be delivered.
- A slice nobody can see. That is a task, not a slice.
- Slicing to fill a fixed period rather than cutting to fit the appetite.

## Hand off

Pass the ordered slices to `flow-scaffold` (first time) or `flow-build` (thereafter).
