---
name: bet
description: "Phase of the product workflow (Frame, Bet, Build or Experiment, Release, Learn). A single decision on a framed problem: type it as a delivery bet (payoff is working software) or an experiment bet (payoff is knowledge), and take a slot under the WIP limit, or refuse. Freezes the frame doc. Use when a framed problem competes for capacity, when deciding what to work on next, when a roadmap or backlog item needs justifying, or when work is about to start without a slot."
argument-hint: [frame doc]
---

# Bet

## Purpose

Make starting work a deliberate, capacity-bounded decision. Nothing enters the system without an
open slot under the WIP limit.

## Entry

A frame doc with `status: framed`, competing for capacity.

## Procedure

No substeps. It is one decision.

1. Check the frame against `docs/vision.md`. A frame that serves no one the vision is for, or builds
   something the vision rules out, is refused.
2. Type it. A **feasibility** hypothesis that a script, spike or prototype can decide is an
   **experiment** bet. Everything else, including a value hypothesis, is a **delivery** bet: value
   is only decidable by a thin slice deployed dark to a small cohort.
3. Count the slots. In-flight frame docs are those with `status` of `bet`, `building`,
   `experimenting` or `released`. Compare against `wip_limit` in the frontmatter of
   `docs/goals.md`. If the file or the limit is missing, ask for the limit and write it.
4. Take a slot or refuse. Refusing is a valid outcome; the frame waits or dies.

## Exit test

An open slot existed under the WIP limit, and the frame doc records the type and the slot.

## Anti-patterns

- Starting because the frame is interesting, with no open slot.
- Raising the WIP limit to fit the bet.
- Typing a value question as an experiment so it can be decided on a laptop.
- Editing the frame after betting. A changed frame is a kill and a new frame.

## Artifact

Reads the frame doc, `docs/vision.md` and `docs/goals.md`. Sets `status: bet` and `type:` in the
frontmatter, appends `## Bet` with the type, slot count and date. The four frame sections are now
frozen.

## Hand off

State the decision, offer `build` for a delivery bet or `experiment` for an experiment bet, and
wait. When another skill called this one, return to it instead of offering.
