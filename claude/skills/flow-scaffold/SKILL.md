---
name: flow-scaffold
description: Step 5 of the 10-step product workflow (Frame, Bet, Probe, Slice, Scaffold, Build, Verify, Ship, Release, Learn). Stands up the whole delivery path end to end on an empty product — trunk, CI, one-command deploy, feature flags, telemetry, rollback — before any feature work. Use this at the start of any new project, repository, or service, whenever someone asks how to set up a project, and whenever deployment or CI is being deferred until "later". This step is non-negotiable at every product stage, including throwaway prototypes that reach real users.
---

# Scaffold — step 5 of 10

## Purpose

Prove the delivery path works while the product is empty and the cost of fixing it is near zero. This is the part that is expensive to retrofit and the part with the strongest evidence behind it.

## What must exist

- **Trunk** — one long-lived branch. No branching model.
- **CI** — build and test on every push. One config file.
- **Deploy** — one command, or automatic on green. Prove it by deploying the empty product.
- **Feature flags** — the mechanism that lets `flow-ship` and `flow-release` be separate steps.
- **Telemetry** — structured logs and error tracking on the request path.
- **Rollback** — exercised once, on purpose, before it is ever needed.
- **Backup and restore** — for anything holding user data. Restore tested, not just configured.

## Procedure

1. Create the smallest runnable thing: one endpoint, one screen, one command.
2. Wire CI to it.
3. Deploy it to the real production environment. Not staging.
4. Add the flag mechanism and put the trivial thing behind it.
5. Break something deliberately and roll back.

## Done when

A trivial change moves from local edit to production, behind a flag, without a manual step — and can be reversed.

## Anti-patterns

- Building features first and "adding CI later". The path never gets built.
- A staging environment standing in for production.
- Rollback that was configured but never exercised.
- Skipping this because the product is a prototype. If real users touch it, it needs the path.

## Non-software equivalent

Prove the delivery channel works with a trivial item before producing the real one: send the empty newsletter to yourself, run the process end to end with a dummy case.

## Hand off

Pass to `flow-build`.
