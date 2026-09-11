---
name: adr
description: Write an Architecture Decision Record in MADR format for Upcast. Use when the user says ADR, "record this decision", "document why we chose", or after a deliberation converges on a technical choice.
disable-model-invocation: true
argument-hint: [decision title]
---
# ADR (MADR)

1. Reuse the conversation: the context, options and trade-offs already discussed. Ask only for what is missing.
2. Write in MADR:

```
# <Title, imperative: "Use Dapper for the billing service">
Status: proposed | accepted | superseded by ADR-N
Date: YYYY-MM-DD

## Context and problem statement
## Decision drivers
## Considered options
## Decision outcome
Chosen option: "<X>", because <one sentence>.
### Consequences
- Good: …
- Bad: …
## Pros and cons of the options
### <option>
- Good: … / Bad: …
```

3. Destination: Slite ADR collection via the Slite MCP if connected; otherwise `docs/adr/NNNN-<slug>.md` in the repo, NNNN = next number.
4. Length: under 60 lines. Options that were never seriously considered are omitted.
