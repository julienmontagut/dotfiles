---
name: flow-ship
description: Step 8 of the 10-step product workflow (Frame, Bet, Probe, Slice, Scaffold, Build, Verify, Ship, Release, Learn). Puts the artifact into production inert, behind a flag, visible to nobody — deliberately separate from exposing it to users. Use this whenever deployment comes up, whenever deploy and release are being treated as one event, whenever a change is waiting for a release window, and whenever someone is nervous about deploying because deploying means exposing.
---

# Ship — step 8 of 10

## Purpose

Decouple the technical act (code in production) from the business act (users see it). Collapsing the two is what makes deployment frightening and reversal slow.

## Procedure

1. Merge to trunk. Gates from `flow-verify` pass.
2. Deploy automatically on green. Every green commit reaches production.
3. The new behaviour sits behind a flag, defaulted off.
4. Confirm it is running: health, logs, no error rate change.

## Done when

The artifact runs in production and no user has seen it.

## Anti-patterns

- Release windows and deployment freezes. They batch risk instead of reducing it.
- Deploying and exposing in one move, so rollback means redeploy.
- Manual deployment steps. Anything manual gets skipped under pressure.
- Holding finished work back to bundle it into a bigger release.

## Non-software equivalent

The thing is printed, staged, loaded, ready — and not yet announced.

## Hand off

Pass to `flow-release`.
