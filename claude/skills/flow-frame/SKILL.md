---
name: flow-frame
description: Step 1 of the 10-step product workflow (Frame, Bet, Probe, Slice, Scaffold, Build, Verify, Ship, Release, Learn). Turns a vague idea, feature request, or "we should build X" into a stated problem with a named audience, before any solution is discussed. Use this whenever someone brings a new idea, feature, project, or initiative and starts describing what to build rather than what hurts — including non-software work. If the request already names a solution, use this skill to work backwards to the problem.
---

# Frame — step 1 of 10

## Purpose

Separate the problem from the solution. Everything downstream inherits this framing, so a solution smuggled in here is never re-examined.

## Procedure

1. Ask who has the problem. Name a segment specific enough that you could list ten of them.
2. Ask what they do today instead. If there is no current workaround, the problem may not be real.
3. Ask what it costs them: money, time, headcount, risk, or a spreadsheet somebody maintains by hand.
4. Write one sentence: `<audience> currently <workaround>, which costs them <cost>.`
5. Read it back. If the sentence contains a feature, a technology, or a product name, rewrite it.

## Output

One sentence. One named audience. No solution.

## Done when

The problem can be stated without naming anything you would build.

## Anti-patterns

- A solution restated as a problem ("they lack a dashboard" — no, they lack visibility, and maybe a dashboard is wrong).
- An audience defined by demographics rather than by the problem they have.
- Multiple problems bundled into one frame. Split them; each gets its own bet.

## Hand off

Pass the sentence to `flow-bet`.
