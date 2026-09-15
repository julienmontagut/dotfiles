---
name: experiment
description: "Phase of the product workflow (Frame, Bet, Build or Experiment, Release, Learn). Experiment branch, parallel to Build. Decides a feasibility hypothesis with the cheapest instrument (a script, a spike against the real API, a load test, a paper prototype, user conversations, a concierge MVP or a fake door) run inside the appetite, concludes true, false or failed, then discards the artifact and records the finding as an ADR or a new frame. Use when a bet is typed experiment, when an assumption is about to be settled by building, or when someone proposes a large build to answer a question a two-day test could answer."
argument-hint: [frame doc]
---

# Experiment

## Purpose

Buy knowledge, not software. The goal is a decided hypothesis for the least possible cost, and
falsification rather than confirmation.

## Entry

An open slot, typed experiment.

## Procedure

1. **Instrument.** Write down what evidence would decide the hypothesis. If nothing could, it is not
   a hypothesis. Pick the cheapest thing that produces that evidence:
   - **Script or spike** against the real API: can it be done at all.
   - **Load test**: does it hold at the volume that matters.
   - **Conversation**: the problem exists and is urgent.
   - **Concierge**: deliver the outcome manually for one user.
   - **Fake door**: a link, a button, a signup.
   - **Prototype**: a clickable or paper mock, for comprehension and workflow fit.
2. **Run** inside the appetite, against the real thing and real people in the framed audience, not
   friends or peers. Overrunning the appetite is a kill, not an extension.
3. **Conclude**: true, false, or the experiment failed. "Interesting but unclear" is a failed
   experiment. Say so rather than laundering it into a delivery bet.
4. **Discard and record.** Delete the artifact. The finding survives as an ADR through `adr`, or as a
   new frame through `frame`.

## Scope limit

A laptop only decides feasibility. No value hypothesis is decidable locally. When the question is
value, the cheapest honest instrument is a thin slice deployed dark with the flag opened to a small
cohort: a delivery bet with a tiny appetite, not an experiment.

Skip the experiment when the build is cheaper than the instrument. Then building is the experiment,
as a delivery bet.

## Exit test

The hypothesis is decided and the artifact is gone.

## Anti-patterns

- Experimenting on something already decided.
- Asking people to predict their future behaviour. They cannot.
- Promoting experiment code into the product. It is never promoted.
- Needing slicing, a pipeline or a deployment. Then it is a delivery bet.

## Artifact

Reads the frame doc. Sets `status: experimenting` while running. Appends `## Experiment` with the
instrument, the run, the conclusion and a link to the ADR or new frame.

## Hand off

State the conclusion, offer `adr` or `frame`, and wait.
