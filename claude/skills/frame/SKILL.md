---
name: frame
description: "Phase of the product workflow (Frame, Bet, Build or Experiment, Release, Learn). Turns a raw signal, such as a support request, a measurement, an idea, a feature request or a result from Learn, into a frame doc with a problem and its evidence, an appetite, a bounded solution sketch and a falsifiable hypothesis. Use when someone brings a new idea, feature, project or initiative, when a request names a solution instead of a problem, or when a build has no stated problem or appetite. Do not use for UI frames or picture framing."
argument-hint: [raw signal or subject]
---

# Frame

## Purpose

Separate the problem from the solution and make the work rejectable. Everything downstream inherits
this framing, so a solution smuggled in here is never re-examined.

## Entry

A raw signal: a support request, a measurement, an idea, or a result from `learn`.

## Procedure

1. **Problem with evidence.** Name who has it, specific enough that you could list ten of them. Ask
   what they do today instead and what that costs them: money, time, headcount, risk, or a
   spreadsheet somebody maintains by hand. No current workaround may mean no real problem. Write
   `<audience> currently <workaround>, which costs them <cost>.` and attach the evidence. If the
   sentence names a feature, a technology or a product, rewrite it.
2. **Appetite.** How much this is worth spending, not how long it will take. Fixed. Scope bends to
   fit the appetite; the appetite never bends to fit the scope.
3. **Sketch.** A bounded solution: rough, solved, bounded. Enough to see that it fits the appetite,
   not a spec.
4. **Hypothesis.** The claim, and the metric that would falsify it. The metric is behaviour that
   costs the observed person something: their data, their time, their money, their reputation.
   Opinions, stated intent and enthusiasm do not count. With a small population, use absolute
   counts: "5 of the 15 people shown it load their own data within two weeks." Class it as a
   **value** hypothesis (will anyone care) or a **feasibility** hypothesis (can it be done). This
   decides the branch at `bet`.
5. **Spike, only if blocked.** When a technical unknown blocks the sketch, run a spike capped in
   hours. Exceeding the cap turns it into an experiment bet.

Read `docs/vision.md` (is this our problem?), `docs/goals.md` (which goal does this serve?) and the
ADRs (what constrains the sketch?). If any is missing, say so and continue.

## Exit test

Someone can reject the frame for a concrete reason.

## Anti-patterns

- A solution restated as a problem ("they lack a dashboard"; no, they lack visibility, and a
  dashboard may be wrong).
- An audience defined by demographics rather than by the problem they have.
- Several problems bundled into one frame. Split them; each gets its own frame.
- Estimating instead of setting an appetite.
- A hypothesis nothing could falsify.
- With no customers yet, framing a build before demand. The first frames are reachability (can I
  get 20 people in one narrow segment into a conversation?), problem (do 5 describe it unprompted?)
  and urgency (will 2 give access to their real workflow or data?).

## Artifact

Creates `docs/frames/NNNN-<slug>.md`, NNNN being the next number, with `status: framed`:

```markdown
---
status: framed
type:
---
# <problem, one line>

## Problem
## Appetite
## Sketch
## Hypothesis

<!-- frozen above this line once status leaves "framed" -->
```

Later skills append `## Bet`, `## Build`, `## Experiment`, `## Release` and `## Learn` below the
marker. Before `bet`, the four sections can be edited freely.

## Hand off

State the frame, offer `bet` in one line, and wait. When another skill called this one, return to
it instead of offering.
