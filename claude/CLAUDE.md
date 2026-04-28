# How I Work

Senior developer running a software company. Primary stack: .NET 8/C#, Rust, Lua, Bash. Infrastructure: MongoDB, Kubernetes, Docker. Editor: Neovim. Shell: zsh + tmux. Cross-platform: Linux and macOS.

## Code Philosophy

Write code that works, reads clearly, and stays simple until complexity is earned.

- **No premature abstraction.** Don't extract a function, interface, or pattern until there's a proven second use case. Three similar lines are better than a premature helper.
- **No Clean Code theater.** Don't split a 20-line function into five 4-line functions for "readability." A function should exist because it has a name worth calling, not because someone counted lines.
- **Composition over inheritance.** Always. Interfaces and delegation beat class hierarchies.
- **Validate at boundaries, trust internals.** Validate user input, API responses, config. Don't litter internal code with defensive checks against impossible states.
- **Delete dead code.** No commented-out blocks, no `_unused` renames, no "just in case" re-exports. Version control remembers.
- **Name things honestly.** A `Manager` or `Helper` suffix means you haven't figured out what it does yet. Be specific.
- **Avoid indirection for indirection's sake.** If a wrapper adds no logic, skip it. If a service just forwards to a repository, question its existence.
- **Keep dependencies minimal.** Don't add a library for something the standard library handles. Every dependency is a liability.

## Code Style

- 4 spaces indentation (2 for JSON). Enforced via .editorconfig.
- 100-character line width as soft guide, 120 as hard max.
- Prefer explicit over clever. No ternary chains, no nested LINQ expressions spanning 5 lines.
- Use `var` / `auto` / type inference when the type is obvious from the right side. Spell it out when it's not.

## Testing

Write tests that catch real bugs. Skip tests that just prove the compiler works.

- **Integration over mocks when possible.** A test that hits a real database catches migration bugs that mocks hide.
- **Test behavior, not implementation.** Assert on outcomes, not on which internal method was called.
- **No 100% coverage targets.** Test the tricky parts: edge cases, error paths, business logic. Skip trivial getters and obvious mappings.
- **Test names describe the scenario**, not the method: `ReturnsNotFound_WhenConnectorDoesNotExist` over `TestGetConnector`.
- **One assertion per concept**, but multiple assertions per test are fine if they test the same behavior.

## Git

- Rebase workflow. Pull with rebase, keep history linear.
- Push with `--force-with-lease`, never `--force`.
- Commit messages: imperative mood, concise, focused on *why* not *what*. The diff shows the what.
- Default branch: `main`.
- Small, focused commits. One logical change per commit.

## Scope & PR sizing

Slice every task into chunks equivalent to **1–2 days of human dev effort**. Every PR must be reviewable in **under 1 hour** and stay concise.

- Before non-trivial work, propose a slicing plan (PR 1, PR 2, …) and confirm before coding.
- If a task naturally exceeds ~2 days, split it — even if the split forces stub interfaces, follow-up tickets, or temporary `NotImplementedException`s. Open a follow-up ticket for the deferred piece.
- One concern per PR. No drive-by cleanups, no opportunistic refactors, no formatting churn outside the touched area.
- If a PR creeps past the 1h review budget mid-flight, stop and split rather than push through.
- Prefer narrow vertical slices (end-to-end on a small surface) over wide horizontal layers (one layer across everything).

## Communication

- Be direct and concise. Skip preamble and summaries.
- Don't explain what you just did — I can read the diff.
- Don't ask permission for obvious next steps. Just do them.
- When unsure between approaches, state the tradeoff in one sentence and pick one. Don't present a menu unless the choice genuinely matters.
- Use technical terms precisely. Don't simplify unless I ask.
