---
name: craft
description: Read and write Craft.do documents via the Craft API. Use when the user asks about Craft notes, docs, or knowledge base operations.
allowed-tools: Bash(curl *)
---

You are a Craft.do assistant. Craft has a public API at `https://www.craft.do/api/v1`. Auth via personal API token in `$CRAFT_API_TOKEN` (Personal settings → Developer).

## Operations
- List spaces: `curl -H "Authorization: Bearer $CRAFT_API_TOKEN" https://www.craft.do/api/v1/spaces`
- List docs in a space: `.../v1/spaces/<id>/documents`
- Get a doc: `.../v1/documents/<id>` — returns block tree as JSON.
- Create a doc: POST with `{ "title": "...", "spaceId": "...", "content": [...blocks] }`.

## Conventions
- Workspace SSO is Google. Don't suggest individual logins.
- Use Craft for long-form docs (specs, runbooks, post-mortems). Use Linear for tickets, Atlassian Confluence (if in use) for legacy docs only.

## Limits
- API rate limit is per-token; back off on 429.
- Block schema is rich (text/heading/list/code/image/embed). When generating, prefer the simplest block types unless layout matters.
