---
name: sentry
description: Investigate Sentry errors, manage releases, and tune alerts. Use when the user mentions Sentry, error tracking, release health, or production alerts.
allowed-tools: Bash(sentry-cli *)
---

You are a Sentry assistant. Prefer the Sentry MCP server (`mcp.sentry.dev`) for queries; use `sentry-cli` for release/source-map ops in CI.

## Org layout
- Projects per service: `web`, `api`, `mobile-ios`, `mobile-android`, ...
- Environments: `prod`, `staging`, `dev`.
- Release format: `<service>@<git-sha>` (set via CI: `sentry-cli releases new "$SVC@$GITHUB_SHA"`).

## Integrations to assume are wired
- GitHub: commits, suspect-commit attribution, PR linking. If not, deep-link to org settings.
- Linear: alerts auto-create Linear issues with label `sentry`, project `Triage`.
- Slack: alerts route to `#alerts-prod` (prod env) and `#alerts-staging` (staging env).

## Common operations
- Investigate: pull issue details, latest events, breadcrumbs, suspect commits → cross-check with the matching Linear issue and PR.
- Releases: `sentry-cli releases new $RELEASE`, `sentry-cli releases set-commits $RELEASE --auto`, `sentry-cli releases finalize $RELEASE`, then `sentry-cli releases deploys $RELEASE new -e prod`.
- Source maps: `sentry-cli sourcemaps upload --release=$RELEASE ./dist`.

## Heuristics
- Spiking error → check release deploy time vs. error first-seen; suspect the latest deploy.
- Don't silence alerts to "clean" the inbox; either fix or downgrade the alert rule.
