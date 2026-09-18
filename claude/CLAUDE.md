# Global instructions (Julien)

## Context

- Solo founder of Upcast (Bordeaux, EU). C#/.NET and Rust for work; Zig for low-level/FFI layers and experiments; Rust or Zig only on personal projects unless the repo says otherwise.
- Runtime targets: Linux amd64, sometimes arm64/riscv64. Dev on macOS or Fedora, servers on CentOS Stream. Toolchains via mise (`rust-toolchain.toml`, `global.json`).
- New projects: Apache-2.0 for libraries and embedded/appliance code, GPL-3.0 for applications. Never MIT.
- Client/product data stays on EU infrastructure (Scaleway primary, GCP only for non-EU).

## Working style

- YAGNI and KISS: implement only what was asked, prefer single-line solutions. No extra options, config, abstractions, "future-proofing", or speculative error handling.
- Fewest files possible, smallest diffs possible. Do not create comments, docs, helper scripts, or tests for code that was not requested.
- Verify before asserting: read the docs or the source (`cargo doc --open`, decompiled/NuGet source, `man`). If unverifiable, say so.
- Dependencies: stdlib/platform first, then one well-known crate/package, then write it. State in one line why a new dependency is needed.
- Never introduce JavaScript, TypeScript or Python.
- Behaviour changes are test-first: use `/implement`.
- Ask before: force-push, history rewrite, deleting branches/files outside the task, `tofu apply`, anything touching production data.

## Code style

- Composition over inheritance, always.
- No Clean-Code: no one-line wrapper methods, no interface per class, no DI without a second implementation, no splitting a readable 40-line function. Optimise for the reader of the call site and for allocations/perf.
- Prefer explicit over clever. No ternary chains, no nested LINQ expressions spanning 5 lines.
- Follow language conventions, not arbitrary style guides. Format using standard tools.

## Testing

Write tests that catch real bugs. Skip tests that just prove the compiler works.

- Integration over mocks when possible. A test that hits a real database catches migration bugs that mocks hide.
- Test behavior, not implementation. Assert on outcomes, not on which internal method was called.
- Test names describe the scenario, not the method: `ReturnsNotFound_WhenConnectorDoesNotExist` over `TestGetConnector`.
- One assertion per concept, but multiple assertions per test are fine if they test the same behavior.

## Git

- Rebase workflow. Pull with rebase, keep history linear. Default branch: `main`.
- Push with `--force-with-lease`, never `--force`.
- Commit messages: a single expressive one-liner, imperative mood, never a body. Put the _why_ in the PR description, not the commit.
- PR descriptions explain the general purpose and the main changes, high level. Don't narrate every file or line.

## Communication

- Be direct and concise. Skip preamble and summaries.
- Don't explain what you just did — I can read the diff.
- Answer questions as questions. "What's the best way to X", "how do I X", "can I X" means
  tell me, don't do X. Investigating to answer is fine; changing the machine is not.
- When unsure between approaches, state the tradeoff in one sentence and pick one. Don't present a menu unless the choice genuinely matters.
- Use technical terms precisely. Don't simplify unless I ask.
- Never use em dashes or en dashes. Use a regular hyphen (-), a comma, or two sentences instead. Only write characters I could type on a normal keyboard.
- Don't use "+" as shorthand for "and". Write "and".

## Pull requests

- The description explains the general purpose and the main changes, enough to understand why the change exists and what it does. Stay high level. Don't narrate every file or line.
