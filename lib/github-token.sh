#!/usr/bin/env bash
# Obtain a GitHub token so mise's GitHub API calls are authenticated
# (60 → 5000 req/hr). Without one a fresh `mise bootstrap` exhausts the
# anonymous rate limit while resolving `latest` for the GitHub-backed tools.
# Exports GITHUB_TOKEN if one can be found.
ensure_github_token() {
  # Already provided (CI, prior export, MISE_GITHUB_TOKEN) → nothing to do.
  [[ -n "${GITHUB_TOKEN:-}${MISE_GITHUB_TOKEN:-}" ]] && return
  # Reuse an already-authenticated gh if one happens to exist.
  if command -v gh >/dev/null && gh auth token >/dev/null 2>&1; then
    GITHUB_TOKEN="$(gh auth token)"
    export GITHUB_TOKEN
    return
  fi
  # Interactive fallback: prompt for a PAT (no scopes needed — a bare token
  # just lifts the anonymous rate limit). Skippable with Enter.
  if [[ -t 0 ]]; then
    read -rsp "GitHub token (optional, lifts mise's API rate limit; Enter to skip): " GITHUB_TOKEN
    echo
    [[ -n "$GITHUB_TOKEN" ]] && export GITHUB_TOKEN
  fi
  [[ -z "${GITHUB_TOKEN:-}" ]] && \
    echo "warning: no GitHub token; mise may hit the anonymous API rate limit" >&2
}
