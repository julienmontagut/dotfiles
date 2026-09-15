---
name: decide
description: "Converges the product workflow artifacts (a frame doc in docs/frames, docs/vision.md or docs/goals.md) until every required detail is set and nothing is stale. Finds blank or TBD fields, sections made stale by an edit above them, and in-flight frames that a changed vision or goals no longer fit, then proposes a value for each and asks until none remain. Use when a frame doc has blanks or an uncommitted edit, when vision or goals changed, when build or another workflow skill stalls for an answer, or when asked to pin the details down. Do not use for ordinary implementation questions outside the product workflow."
argument-hint: "[frame doc | vision | goals] [git rev]"
---

# Decide

## Purpose

Converge. A phase that ends with open details hands its ambiguity downstream, where it gets resolved
silently by whoever writes the code.

## Procedure

1. **Diff once, at the start**: `git diff <rev, default HEAD> -- <file>`. Later writes by this skill
   do not count as edits.
2. **List the items:**
   - **Blank**: an empty field, or one reading `TBD`, `later` or `depends`, in a section the frame's
     status requires, or that the calling skill asked for.
   - **Stale**: in a frame doc still `framed`, every written section below the topmost changed one.
     Say what the edit contradicts.
   - **Reshape or kill**: after a change to `docs/vision.md` or `docs/goals.md`, every `framed` doc
     that no longer fits is a reshape item. Every in-flight doc (`bet`, `building`, `experimenting`,
     `released`) that no longer fits is a kill candidate. A kill candidate is never edited.
   - **Frozen edit**: a change above the freeze marker on a doc past `framed`. Do not reconcile it.
     Offer to revert, or to kill and open a new frame.
3. **Resolve.** For each item, state the tradeoff in one sentence and propose a value. Decide the
   obvious ones yourself and say so. Batch the rest, up to four per `AskUserQuestion`.
4. **Write** the answers into the file. Answers open new items; add them to the list.
5. **Repeat** from 3 until nothing is blank, stale or pending.

## Exit test

Nothing is blank, stale or pending, and a stranger could run the next skill from the files alone.

## Anti-patterns

- Accepting "we'll figure it out later".
- Asking questions whose answer does not change what gets built.
- Presenting a menu where a default is obvious.
- Stopping after one round of answers.
- Editing a frozen section to make a frame fit a changed vision.

## Hand off

Architectural choices go to `adr`. When another skill called this one, return to it. Otherwise
state what was settled, offer the skill the frame's status points to next, and wait.
