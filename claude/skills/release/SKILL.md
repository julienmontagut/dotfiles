---
name: release
description: "Phase of the product workflow (Frame, Bet, Build or Experiment, Release, Learn). Exposes an increment that is deployed dark to users progressively and reversibly: open the feature flag to a cohort or canary, observe against the metric named in the frame doc, then expand or roll back. Use when a launch, rollout, go-live, beta or announcement is being planned, when a change is about to be turned on for everyone at once, and when rollback planning comes up. Do not use for git tags, release notes or GitHub releases (use the github skill)."
argument-hint: [frame doc]
---

# Release

## Purpose

Make exposure a dial rather than a switch, so that being wrong costs one cohort and one flag flip.
Deploy is mechanical; release is a product decision.

## Entry

Deployed and dark: `### Verify` passed, flag closed.

## Procedure

1. **Expose to a cohort**: yourself, then one design partner, then a percentage.
2. **Observe** against the metric in the frame doc's Hypothesis, plus the operational ones: error
   rate, latency, support contacts.
3. **Expand, or roll back.** Each widening is a decision, not a schedule. Rollback is flag-off, not
   redeploy. If reversal needs a deployment, the walking skeleton is incomplete: go back to `slice`.

Once the behaviour is permanent, remove the flag. Dead flags accumulate into their own problem.

## Exit test

Full exposure to the intended cohort, or rollback.

## Anti-patterns

- All users at once because the change "is small".
- A rollout schedule set in advance and followed regardless of the signal.
- Flags that never get removed.
- Announcing before the cohort is wide enough to absorb the interest.
- No Hypothesis in the frame doc. There is nothing to observe against; stop and say so.

## Artifact

Reads the frame doc. Sets `status: released` at full exposure. Appends `## Release` with each cohort,
what was observed, and the expand or rollback decision.

## Hand off

State the exposure, offer `learn`, and wait.
