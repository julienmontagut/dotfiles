---
name: slice
description: "Activity inside the Build phase (Slice, Implement, Verify) of the product workflow. Cuts a delivery bet into independently deliverable vertical slices ordered by risk and cut to fit the appetite, with slice zero as the walking skeleton (trunk, CI, one-command deploy, feature flags, telemetry, rollback) when the component does not exist yet. Use when a plan, epic, milestone or feature needs breaking down, when work is being organised into phases or layers, when a branch is about to live longer than a day, or when a new project, repository or service is being set up."
argument-hint: [frame doc or subject]
---

# Slice

## Purpose

Keep the batch small enough that being wrong is cheap and feedback arrives while it still matters.

## Entry

A delivery bet whose `### Slicing` says slicing is needed, or a direct call.

## Procedure

1. List the outcomes the frame promises, in the user's language.
2. For each, cut a *vertical* slice: entry point through to storage and back, however thin. Never cut
   by layer, by component or by team.
3. Check each slice:
   - Can it be delivered alone, with nothing else?
   - Would a user notice it?
   - Can it be thrown away without unpicking the others?
4. Order by risk: the slice most likely to invalidate the bet goes first.
5. Fit the slices inside the appetite. Whatever does not fit is cut, not deferred to "phase 2".

## Slice zero: the walking skeleton

Only when the component does not exist yet. Prove the delivery path on an empty product, while
fixing it costs nothing:

- **Trunk**: one long-lived branch.
- **CI**: build and test on every push.
- **Deploy**: one command, or automatic on green. Proven by deploying the empty product to real
  production, not staging.
- **Feature flags**: the trivial thing sits behind one.
- **Telemetry**: structured logs and error tracking on the request path.
- **Rollback**: break something on purpose and roll back.
- **Backup and restore**: for anything holding user data. Restore tested, not just configured.

Done when a trivial change moves from local edit to production, behind a flag, without a manual
step, and can be reversed.

## Slicing solo

Working alone, slicing limits sunk cost rather than coordinating people. Slices can be coarser, "what
I can put in front of a user this week", but the discipline still applies.

## Exit test

No slice exceeds the feedback interval you can tolerate, and each is independently deliverable.

## Anti-patterns

- Horizontal slices: "the database layer", "the API", "the UI". None of them can be delivered.
- A slice nobody can see. That is a task, not a slice.
- Slicing to fill a fixed period rather than cutting to fit the appetite.
- Features first and "CI later". The path never gets built.
- A rollback that was configured but never exercised.

## Artifact

Reads the frame doc. Writes `### Slices` under `## Build`, creating `## Build` if absent, as a checklist, slice zero first when
present.

## Hand off

When `build` called this, return to it. Invoked on its own: state the slices, offer to run the rest
of Build (`implement` per slice, then `verify`) once, and wait.
