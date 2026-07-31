# The macOS packages that don't map cleanly to [bootstrap.packages] in config.macos.toml:
#   - trusted third-party taps: brew bundle's `trusted:` auto-confirms the install prompt, which
#     the mise brew/brew-cask backend may not do non-interactively.
#   - Mac App Store apps: `mas` needs its CLI installed first, which brew bundle orders here.
# Installed by the mise.toml [tasks.bootstrap] via `brew bundle`. The plain casks live in
# config/mise/config.macos.toml. Run only on macOS.

# Tap-level: formula-level `trusted:` wouldn't cover tart's softnet dep.
tap "cirruslabs/cli", trusted: true

brew "mas"
brew "jundot/omlx/omlx", trusted: true
brew "cirruslabs/cli/tart"
cask "nikitabobko/tap/aerospace", trusted: true

# Not in mise: its pkg-cask check wants x86_64 receipts that never exist here, so it reinstalls
# with sudo every bootstrap.
cask "google-drive"
mas "Bitwarden", id: 1352778147
mas "Keynote", id: 361285480
mas "Magnet", id: 441258766
mas "Numbers", id: 361304891
mas "Pages", id: 361309726
mas "Xcode", id: 497799835
