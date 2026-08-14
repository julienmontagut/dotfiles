#!/usr/bin/env bash
# Nerd Fonts v3 glyphs (Lilex Nerd Font Mono), named once so no other file carries a bare literal.
#
# Glyphs are literal UTF-8, not $'\uXXXX': macOS /bin/bash is 3.2, and ANSI-C \u escapes only
# landed in bash 4.2 - they would come out as the literal text "\uf268". The codepoint and Nerd
# Fonts name live in the trailing comment instead. Every codepoint below is present in
# LilexNerdFontMono-Regular.ttf; re-check the cmap before adding one.

# --- workspaces ---
export ICON_GEN=󰋜 # U+F02DC nf-md-home catch-all
export ICON_CODE=󰅩 # U+F0169 nf-md-code_braces
export ICON_REF=󰖟 # U+F059F nf-md-web
export ICON_MISC=󰒓 # U+F0493 nf-md-cog

# --- right cluster ---
export ICON_CPU=󰻠 # U+F0EE0 nf-md-cpu_64_bit
export ICON_RAM=󰍛 # U+F035B nf-md-memory
export ICON_DATE=󰃰 # U+F00F0 nf-md-calendar_clock
export ICON_WIFI=󰖩 # U+F05A9 nf-md-wifi
export ICON_WIFI_OFF=󰖪 # U+F05AA nf-md-wifi_off

# --- battery ramps, lowest to highest; see battery.sh ---
export ICON_BAT_0=󰂎 # U+F008E nf-md-battery_outline
export ICON_BAT_20=󰁻 # U+F007B nf-md-battery_20
export ICON_BAT_40=󰁽 # U+F007D nf-md-battery_40
export ICON_BAT_60=󰁿 # U+F007F nf-md-battery_60
export ICON_BAT_80=󰂁 # U+F0081 nf-md-battery_80
export ICON_BAT_100=󰁹 # U+F0079 nf-md-battery
export ICON_CHG_20=󰂆 # U+F0086 nf-md-battery_charging_20
export ICON_CHG_40=󰂈 # U+F0088 nf-md-battery_charging_40
export ICON_CHG_60=󰂉 # U+F0089 nf-md-battery_charging_60
export ICON_CHG_80=󰂊 # U+F008A nf-md-battery_charging_80
export ICON_CHG_100=󰂅 # U+F0085 nf-md-battery_charging_100

# Every app aerospace.toml routes, plus the ones that turn up unrouted. The fallback is a
# window, not a document - what we failed to recognise is a window.
app_icon() {
    case "$1" in
        Ghostty)                                            echo 󰊠 ;; # U+F02A0 nf-md-ghost
        Alacritty | kitty | iTerm2 | Terminal)              echo  ;; # U+F489 nf-oct-terminal
        Zed)                                                echo 󰈮 ;; # U+F022E nf-md-file_code
        Xcode | Simulator)                                  echo  ;; # U+F179 nf-fa-apple
        Rider | "JetBrains Toolbox" | dotMemory | dotTrace) echo  ;; # U+E7B5 nf-dev-intellij
        RustRover)                                          echo  ;; # U+E7A8 nf-dev-rust
        "Google Chrome" | Chrome)                           echo  ;; # U+F268 nf-fa-chrome
        Firefox*)                                           echo  ;; # U+E745 nf-dev-firefox
        Safari)                                             echo  ;; # U+F267 nf-fa-safari
        Claude)                                             echo 󰚩 ;; # U+F06A9 nf-md-robot
        Slite | Craft)                                      echo 󰎚 ;; # U+F039A nf-md-note_text
        Linear)                                             echo  ;; # U+F0AE nf-fa-tasks
        Slack)                                              echo  ;; # U+F198 nf-fa-slack
        Spotify)                                            echo  ;; # U+F1BC nf-fa-spotify
        Steam)                                              echo  ;; # U+F1B6 nf-fa-steam
        Mail | Thunderbird)                                 echo  ;; # U+F0E0 nf-fa-envelope
        Finder)                                             echo 󰉋 ;; # U+F024B nf-md-folder
        "System Settings")                                  echo 󰒓 ;; # U+F0493 nf-md-cog
        OrbStack | DevPod)                                  echo  ;; # U+F308 nf-linux-docker
        Numbers)                                            echo 󰓫 ;; # U+F04EB nf-md-table_large
        Pages)                                              echo 󰈙 ;; # U+F0219 nf-md-file_document
        Keynote)                                            echo 󱁷 ;; # U+F1077 nf-md-presentation
        *)                                                  echo  ;; # U+F2D0 nf-fa-window_maximize
    esac
}
