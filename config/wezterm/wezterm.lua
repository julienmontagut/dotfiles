local wezterm = wezterm or require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- Use zsh if available, fallback to sh
local shell = io.open("/bin/zsh", "r") and "/bin/zsh" or "/bin/sh"
config.default_prog = { shell, "-l" }

config.font = wezterm.font("Lilex")
config.font_size = 16

config.color_scheme = "Tokyo Night Storm"

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

local is_gnome = (os.getenv("XDG_CURRENT_DESKTOP") or ""):match("GNOME") ~= nil
config.window_decorations = is_gnome and "TITLE|RESIZE" or "RESIZE"

-- Leader key: Ctrl+Space (timeout 1 second)
config.leader = { key = "A", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
    -- Pane splitting (vim style)
    { key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "s", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

    -- Pane navigation (vim motions)
    { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
    { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
    { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
    { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

    -- Pane resizing (vim motions with shift)
    { key = "h", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
    { key = "j", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
    { key = "k", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
    { key = "l", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },

    -- Pane management
    { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
    { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
    { key = "o", mods = "LEADER", action = act.RotatePanes("Clockwise") },

    -- Tab management
    { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
    { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
    { key = "7", mods = "LEADER|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },
    {
        key = ",",
        mods = "LEADER",
        action = act.PromptInputLine({
            description = "Rename tab",
            action = wezterm.action_callback(function(window, _, line)
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        }),
    },

    -- Tab navigation by number
    { key = "1", mods = "LEADER", action = act.ActivateTab(0) },
    { key = "2", mods = "LEADER", action = act.ActivateTab(1) },
    { key = "3", mods = "LEADER", action = act.ActivateTab(2) },
    { key = "4", mods = "LEADER", action = act.ActivateTab(3) },
    { key = "5", mods = "LEADER", action = act.ActivateTab(4) },
    { key = "6", mods = "LEADER", action = act.ActivateTab(5) },
    { key = "7", mods = "LEADER", action = act.ActivateTab(6) },
    { key = "8", mods = "LEADER", action = act.ActivateTab(7) },
    { key = "9", mods = "LEADER", action = act.ActivateTab(8) },

    -- Copy mode (like vim visual mode)
    { key = "[", mods = "LEADER", action = act.ActivateCopyMode },

    -- Send Ctrl+Space to terminal when pressed twice
    { key = "Space", mods = "LEADER|CTRL", action = act.SendKey({ key = "Space", mods = "CTRL" }) },
}

return config
