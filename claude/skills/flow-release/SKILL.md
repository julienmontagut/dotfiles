---
name: flow-release
description: Step 9 of the 10-step product workflow (Frame, Bet, Probe, Slice, Scaffold, Build, Verify, Ship, Release, Learn). Exposes shipped work to users progressively and reversibly — flag on for a subset, widen, or switch off. Use this whenever a launch, rollout, go-live, beta, or announcement is being planned, whenever a change is about to be turned on for everyone at once, and whenever rollback planning comes up. The counterpart to flow-ship, which puts the artifact in production without exposing it.
---

# Release — step 9 of 10

## Purpose

Make exposure a dial rather than a switch, so that being wrong costs one cohort and one flag flip.

## Procedure

1. Choose the first cohort: yourself, then one design partner, then a percentage.
2. Flip the flag for that cohort.
3. Watch the signals defined in `flow-bet` plus the operational ones: error rate, latency, support contacts.
4. Widen in steps. Each step is a decision, not a schedule.
5. Remove the flag once the behaviour is permanent. Dead flags accumulate into their own problem.

## Reversal

Rollback is flag-off, not redeploy. Exercise it at least once deliberately before you need it. If reversal requires a deployment, `flow-scaffold` is incomplete — go back.

## Done when

It is live for the intended cohort and the reversal path has been exercised.

## Anti-patterns

- All users at once because the change "is small".
- A rollout schedule set in advance, followed regardless of signals.
- Flags that never get removed.
- Announcing before the cohort is wide enough to absorb the interest.

## Hand off

Pass to `flow-learn`.
