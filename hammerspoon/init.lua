hs.ipc.cliInstall()

-- Simplify the window animations and styling
hs.window.animationDuration = 0
hs.window.setShadows(false)

-- general settings
--
Margin = 10
Mod1 = "command"
Mod2 = "control"

function getScreenFrame(mainScreen)
	local screenFrame = mainScreen:frame()

	return {
		x = screenFrame.x + Margin,
		y = screenFrame.y + Margin,
		w = screenFrame.w - (Margin * 2),
		h = screenFrame.h - (Margin * 2),
	}
end

-- Creates a menubar item to handle workspaces
local workspace_menu = hs.menubar.new()
workspace_menu:autosaveName("workspaces")
workspace_menu:setTitle("[ " .. os.date("%H:%M:%S") .. " ]")

-- The application watcher handles the window tiling when enabled
hs.application.watcher.new(function(name, event, app)
	if event == hs.application.watcher.launched or event == hs.application.watcher.activated then
		local apps = hs.application.runningApplications()
		for _, otherApp in ipairs(apps) do
			if otherApp:pid() ~= app:pid() then
				otherApp:hide()
			end
		end
		local window = app:mainWindow()
		local screen = window:screen()
		local fullscreen = getScreenFrame(screen)
		if window then
			window:setFrame(fullscreen)
		end
	elseif event == hs.application.watcher.deactivated or event == hs.application.watcher.hidden then
		local windows = app:allWindows()
		if #windows == 0 then
			app:kill()
		end
	end
end)
	:start()

hs.hotkey.bind({ Mod1 }, "return", function()
	hs.execute("open -na Alacritty")
end)

hs.hotkey.bind({ Mod1, Mod2 }, "t", function()
	hs.execute("open -na Alacritty")
end)

hs.hotkey.bind({ Mod1, Mod2 }, "w", function()
	hs.execute("open -na Firefox")
	-- local screen = hs.screen.mainScreen()
	-- local fullscreen = getScreenFrame(screen)
	-- hs.webview.newBrowser(fullscreen)
end)

hs.hotkey.bind({ Mod1, Mod2 }, "c", hs.reload)

-- set up your windowfilter
-- local switcher = hs.window.switcher.new(hs.window.filter.new(), {
-- 	showThumbnails = false,
-- 	showSelectedThumbnail = false,
-- 	showSelectedTitle = true,
-- })
-- hs.hotkey.bind('alt', 'tab', function()
-- 	switcher:next()
-- end)
-- hs.hotkey.bind('alt-shift', 'tab', function()
-- 	switcher:previous()
-- end)
