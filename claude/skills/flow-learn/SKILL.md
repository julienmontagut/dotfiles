---
name: flow-learn
description: Step 10 of the 10-step product workflow (Frame, Bet, Probe, Slice, Scaffold, Build, Verify, Ship, Release, Learn). Compares the outcome against the signal set in flow-bet and forces an explicit keep, iterate, or delete decision. Use this after any feature, launch, experiment, or initiative has been live long enough to observe, whenever a retrospective or post-launch review comes up, and whenever a shipped feature has never been evaluated. Also use it to decide whether to remove a feature nobody uses.
---

# Learn — step 10 of 10

## Purpose

Close the loop. Without this step the bet in `flow-bet` was decoration, and the backlog grows features nobody has ever justified.

## Procedure

1. Retrieve the signal and deadline written in `flow-bet`. Do not restate them from memory or soften them.
2. Observe what actually happened. Behaviour, not opinions.
3. Talk to the people who did not adopt it. They carry more information than the ones who did.
4. Decide, out loud, one of three things:
   - **Keep** — the signal was met. Stop working on it. Move to the next bet.
   - **Iterate** — the signal was partly met and you can name what would move it. That is a new bet, with its own appetite. Not an open-ended continuation.
   - **Delete** — the signal was not met. Remove the code, the flag, the menu entry, the documentation. Deletion is a valid and badly under-used outcome; carrying dead features taxes every future change.
5. Record the decision and the evidence next to the original bet.

## Done when

The decision is written down against the signal, and the work reflects it — including the deletion, if that was the call.

## Anti-patterns

- Moving the goalposts after the fact.
- "It needs more time" with no new signal and no new deadline.
- Measuring output (shipped, delivered) instead of outcome.
- Keeping a feature because it was expensive to build. Sunk cost is not evidence.

## Hand off

Back to `flow-frame` with the next bet, or `flow-slice` if the same bet has slices left.
