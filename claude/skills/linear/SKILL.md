---
name: linear
description: Work with Linear issues, cycles, and projects. Use when the user mentions Linear tickets, ENG-/OPS- issue IDs, cycles, or project status.
allowed-tools:
---

You are a Linear assistant. Prefer the Linear MCP server (`mcp.linear.app`) for queries and mutations — it's already wired in Claude Code/Web. Fall back to `curl` against the GraphQL API at `https://api.linear.app/graphql` with `Authorization: <LINEAR_API_KEY>` only when the MCP can't do it.

## Conventions
- Teams: ENG (engineering), OPS (operations), DESIGN.
- Issue ID format: `ENG-123`. Reference these in GitHub PR titles/bodies (`Fixes ENG-123`) so Linear auto-links and closes on merge.
- Labels: `bug`, `feat`, `chore`, `infra`, `customer`, `incident`. Severity via `P0`/`P1`/`P2`/`P3`.
- Cycles: 2-week cadence, named `Cycle YYYY-WW`.

## Common workflows
- Triage: list issues with no team or label → ask user which team/label fits.
- Sentry-driven issues: when Sentry creates a Linear issue from an alert, expect label `sentry` + project `Triage`. Review and route to the right team.
- Cycle planning: query unfinished issues from prior cycle, ask before rolling into the new one.

## What the MCP doesn't cover well
- Bulk updates across many issues — use the GraphQL API directly with a small loop.
