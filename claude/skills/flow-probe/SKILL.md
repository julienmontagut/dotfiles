---
name: flow-probe
description: Step 3 of the 10-step product workflow (Frame, Bet, Probe, Slice, Scaffold, Build, Verify, Ship, Release, Learn). Finds the cheapest evidence that could falsify a bet before anything gets built — concierge, fake door, landing page, prototype, or a conversation. Use this whenever an assumption is about to be settled by building, when validation or user research comes up, or when someone proposes a large build to answer a question a two-day test could answer. Also use it to decide when probing is NOT worth it.
---

# Probe — step 3 of 10

## Purpose

Resolve the bet for the least possible cost. The goal is falsification, not confirmation.

## Procedure

1. Write down what evidence would kill the bet. If nothing could kill it, the bet is not a bet.
2. Pick the cheapest instrument that produces that evidence:
   - **Conversation** — the problem exists and is urgent.
   - **Concierge** — deliver the outcome manually for one user. Tests value without any product.
   - **Fake door** — a link, a button, a signup. Tests demand.
   - **Prototype** — a clickable or paper mock. Tests comprehension and workflow fit.
   - **Landing page** — tests positioning and language, not value.
3. Run it against real people in the framed audience. Not friends, not peers.
4. Compare the result to the signal from `flow-bet`.

## Skip this step when

The build is cheaper than the probe. If the thing takes two weeks to build and the probe takes one, ship the build — shipping *is* the experiment. This is common for very small products and for solo builders.

## Done when

The bet is confirmed, killed, or reshaped. "Inconclusive" means the probe was badly designed — fix it or kill the bet.

## Anti-patterns

- Probing something you have already decided to build.
- Asking people to predict their future behaviour. They cannot.
- Treating a probe as a mini-build. If it produces production code, it is not a probe.

## Hand off

Confirmed → `flow-slice`. Killed → back to `flow-frame`.
