# CLAUDE.md - Dotfiles Repository Guidelines

## Build/Lint/Test Commands
- Format Nix: `nixfmt *.nix`
- Format Lua: `stylua config/nvim/**/*.lua`
- Lint: `devenv ci` (runs pre-commit hooks)
- Rebuild macOS config: `darwin-rebuild switch --flake .`
- Deploy home-manager: `home-manager switch --flake .`
- Update dependencies: `nix flake update`
- Claude Code CLI: `claude` (auto-installed with home-manager)

## Code Style Guidelines
- Nix: 2-space indentation, comments start with `#`
- Lua: 4-space indentation, 100 column width, sorted requires
- Shell scripts: Start with `#!/bin/sh` and use `set -e`
- Git commits: Concise summaries, present tense verbs
- Error handling: Use appropriate error checking for each language
- Naming: Use descriptive names, camelCase for Lua, snake_case for shell scripts
- Configuration: Keep platform-specific settings separated using conditionals
- Modularity: Each tool config should be in its own file in appropriate directories

## Repository Structure
- `bin/`: Scripts added to PATH
- `config/`: Configuration files for tools
- `programs/`: Nix configurations for applications
- `*.nix`: Nix configuration files for home-manager and flakes