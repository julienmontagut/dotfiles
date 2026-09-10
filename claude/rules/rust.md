---
paths:
    - "**/*.rs"
    - "**/Cargo.toml"
---

# Rust

- Before declaring done: `cargo fmt && cargo clippy --all-targets -- -D warnings && cargo test`.
- No `unsafe` in Rust code.
- Web: MASH stack — Maud + Axum + SQLx + HTMX. CSS via Lightning CSS, cascade layers, custom properties. No Tailwind, no JS framework.
- Explicit re-render/immediate-mode for GUI (egui). No DSL-based UI toolkits.
- Prefer std over a crate; prefer one well-known crate over a small one.
