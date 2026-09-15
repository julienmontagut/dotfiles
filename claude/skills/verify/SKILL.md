---
name: verify
description: "Activity inside the Build phase (Slice, Implement, Verify) of the product workflow. Checks the increment as a whole against its acceptance criteria, then against the framed problem and the appetite, before it is released. The only verification that is a distinct act rather than a continuous one. Use when a delivery bet's slices are implemented and deployed dark, when deciding whether an increment is ready for release, or when asking whether what was built still solves the framed problem. Do not use for running or fixing the test suite."
argument-hint: [frame doc]
---

# Verify

## Purpose

Confirm that what was built solves what was framed, inside what it was worth. Tests prove the code
does what the examples say; this proves the examples were the right ones.

## Entry

All slices ticked in `### Slices`, deployed behind a closed flag.

## Procedure

1. Read `### Strategy`. With no strategy recorded, derive acceptance criteria from Problem and Sketch
   in the frame doc, or ask for them when there is no frame doc.
2. Check each acceptance criterion against the running increment, with the flag on for yourself
   only. Record pass or fail with the evidence.
3. Check the increment against Problem: would the audience's workaround actually go away?
4. Check it against Appetite: what was spent, against what it was worth. An overrun is recorded, not
   explained away.
5. Fail means back to `implement` for the failing criterion, or a kill if the appetite is spent.

## Exit test

Every acceptance criterion passes, the increment still answers the Problem, and the spend is
recorded against the Appetite.

## Anti-patterns

- Re-running the test suite and calling it verification.
- Checking against the Sketch instead of the Problem.
- Quietly extending the appetite to make a failing increment pass.
- Verifying with the flag open to users. That is `release`.

## Artifact

Reads the frame doc. Writes `### Verify` under `## Build`, creating `## Build` if absent.

## Hand off

When `build` called this, return to it. Invoked on its own: state the result, offer `release` on a
pass or `implement` on a fail, and wait.
