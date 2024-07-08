hs.ipc.cliInstall()

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "N", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
end)

hs.hotkey.bind({ "alt" }, "z", function()
    local window = hs.window.focusedWindow()
    window:minimize()
    hs.notify.new({ title = "Hammerspoon", informativeText = "Hello World" }):send()
end)

hs.hotkey.bind({ "alt" }, "h", function()
    local windows = hs.window.allWindows()
    for i, window in ipairs(windows) do
        local title = window:title()
        window:maximize()
        hs.alert.show(title)
    end
end)

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "M", function()
    local window = hs.window.focusedWindow()
    local margin = 5
    window:maximize()
end)

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "C", function()
    local window = hs.window.focusedWindow()
    local screen = window:screen()

    local margin = 5

    local frame = window:frame()
    local max = screen:frame()

    frame.x = max.x + margin
    frame.y = max.y + margin
    frame.w = max.w - (margin * 2)
    frame.h = max.h - (margin * 2)

    window:setFrame(frame)
end)
