#!/usr/bin/env bash
# Opens the menu bar that topmost=on hides (see sketchybarrc). The bar sits at window layer 25,
# one above the macOS menu bar's 24, so the real strip can never be revealed by pointer - but a
# menu opened through the Accessibility API draws as a popup well above both, so this reaches it
# without moving the bar out of the way.
#
# Left click opens the focused app's own menu, right click the Apple menu. Either one puts
# keyboard focus in the menu bar, so left/right then walks the rest of it (File, Edit, ...).
#
# $BUTTON is set by sketchybar on click_script. Needs Accessibility for System Events and
# Automation for sketchybar -> System Events. Both are already granted on a machine running
# aerospace; a fresh one prompts once for each, then never again. Denied, the click is a no-op -
# osascript's error goes to /dev/null rather than a dialog the bar cannot dismiss.

# menu bar item 1 is the Apple menu, 2 is the app's own.
case "$BUTTON" in
    right) INDEX=1 ;;
    *) INDEX=2 ;;
esac

osascript - "$INDEX" <<'OSA' 2>/dev/null
on run argv
    set idx to (item 1 of argv) as integer
    tell application "System Events"
        set frontApp to first application process whose frontmost is true
        tell frontApp
            -- A process with no menu bar (or only the Apple menu) has nothing to open.
            if (count of menu bar items of menu bar 1) < idx then return
            click menu bar item idx of menu bar 1
        end tell
    end tell
end run
OSA
