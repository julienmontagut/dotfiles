local wezterm = wezterm or require("wezterm")
local config = wezterm.config_builder()

-- Use zsh if available, fallback to sh
local shell = io.open("/bin/zsh", "r") and "/bin/zsh" or "/bin/sh"
config.default_prog = { shell, "-l" }

config.font = wezterm.font("Lilex")
config.font_size = 16

config.color_scheme = "Tokyo Night Storm"

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

config.window_decorations = "RESIZE"

return config
