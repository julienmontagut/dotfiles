local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.window_close_confirmation = 'NeverPrompt'

-- Preferred color scheme
config.color_scheme = 'carbonfox'
config.use_fancy_tab_bar = false
config.window_decorations = 'INTEGRATED_BUTTONS | RESIZE'

-- Padding around the window
config.window_padding = {
    left = 4,
    right = 4,
    top = 4,
    bottom = 4,
}

-- Custom font
config.font = wezterm.font 'Lilex'
config.font_size = 16
config.line_height = 1.2

-- Key bindings
config.leader = { key = 'Space', mods = 'SHIFT' }

config.keys = {
    {
        key = 't',
        mods = 'LEADER',
        action = wezterm.action.ShowTabNavigator,
    },
    {
        key = 's',
        mods = 'LEADER',
        action = wezterm.action {
            SplitVertical = {
                domain = 'CurrentPaneDomain',
            },
        },
    },
    {
        key = 'v',
        mods = 'LEADER',
        action = wezterm.action {
            SplitHorizontal = {
                domain = 'CurrentPaneDomain',
            },
        },
    },
    {
        key = 'h',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection 'Left',
    },
    {
        key = 'l',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection 'Right',
    },
    {
        key = 'j',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection 'Down',
    },
    {
        key = 'k',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection 'Up',
    },
}

return config
