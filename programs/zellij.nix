{ pkgs, ... }:

{
  programs.zellij = {
    enable = true;
    settings = {
      default_mode = "locked";
      session_name = "default";
      attach_to_session = true;
      show_startup_tips = false;
      ui = { pane_frames = { hide_session_name = true; }; };
      keybinds = {
        _props.clear-defaults = true;
        locked = { "bind \"Ctrl g\"" = { SwitchToMode = "Normal"; }; };
        normal = {
          "bind \"Ctrl g\"" = { SwitchToMode = "Locked"; };
          "bind \"Ctrl c\"" = { SwitchToMode = "Locked"; };
          "bind \"p\"" = { SwitchToMode = "Pane"; };
          "bind \"t\"" = { SwitchToMode = "Tab"; };
          "bind \"r\"" = { SwitchToMode = "Resize"; };
          "bind \"s\"" = { SwitchToMode = "Scroll"; };
          "bind \"o\"" = { SwitchToMode = "Session"; };
          "bind \"h\"" = { SwitchToMode = "Move"; };
          "bind \"Ctrl q\"" = { Quit = { }; };
        };
        pane = {
          "bind \"Ctrl g\"" = { SwitchToMode = "Locked"; };
          "bind \"Ctrl c\" \"Enter\"" = { SwitchToMode = "Normal"; };
          "bind \"h\"" = { MoveFocus = "Left"; };
          "bind \"l\"" = { MoveFocus = "Right"; };
          "bind \"j\"" = { MoveFocus = "Down"; };
          "bind \"k\"" = { MoveFocus = "Up"; };
          "bind \"p\"" = { SwitchFocus = { }; };
          "bind \"n\"" = {
            NewPane = { };
            SwitchToMode = "Normal";
          };
          "bind \"d\"" = {
            NewPane = "Down";
            SwitchToMode = "Normal";
          };
          "bind \"r\"" = {
            NewPane = "Right";
            SwitchToMode = "Normal";
          };
          "bind \"q\"" = {
            CloseFocus = { };
            SwitchToMode = "Normal";
          };
          "bind \"f\"" = {
            ToggleFocusFullscreen = { };
            SwitchToMode = "Normal";
          };
          "bind \"w\"" = {
            ToggleFloatingPanes = { };
            SwitchToMode = "Normal";
          };
          "bind \"e\"" = {
            TogglePaneEmbedOrFloating = { };
            SwitchToMode = "Normal";
          };
          "bind \"c\"" = {
            SwitchToMode = "RenamePane";
            PaneNameInput = 0;
          };
        };
        tab = {
          "bind \"Ctrl g\"" = { SwitchToMode = "Locked"; };
          "bind \"Ctrl c\" \"Enter\"" = { SwitchToMode = "Normal"; };
          "bind \"h\" \"k\"" = { GoToPreviousTab = { }; };
          "bind \"l\" \"j\"" = { GoToNextTab = { }; };
          "bind \"n\"" = {
            NewTab = { };
            SwitchToMode = "Normal";
          };
          "bind \"q\"" = {
            CloseTab = { };
            SwitchToMode = "Normal";
          };
          "bind \"s\"" = {
            ToggleActiveSyncTab = { };
            SwitchToMode = "Normal";
          };
          "bind \"1\"" = {
            GoToTab = 1;
            SwitchToMode = "Normal";
          };
          "bind \"2\"" = {
            GoToTab = 2;
            SwitchToMode = "Normal";
          };
          "bind \"3\"" = {
            GoToTab = 3;
            SwitchToMode = "Normal";
          };
          "bind \"4\"" = {
            GoToTab = 4;
            SwitchToMode = "Normal";
          };
          "bind \"5\"" = {
            GoToTab = 5;
            SwitchToMode = "Normal";
          };
          "bind \"Tab\"" = { ToggleTab = { }; };
        };
        resize = {
          "bind \"Ctrl g\"" = { SwitchToMode = "Locked"; };
          "bind \"Ctrl c\" \"Enter\"" = { SwitchToMode = "Normal"; };
          "bind \"h\"" = { Resize = "Increase Left"; };
          "bind \"j\"" = { Resize = "Increase Down"; };
          "bind \"k\"" = { Resize = "Increase Up"; };
          "bind \"l\"" = { Resize = "Increase Right"; };
          "bind \"H\"" = { Resize = "Decrease Left"; };
          "bind \"J\"" = { Resize = "Decrease Down"; };
          "bind \"K\"" = { Resize = "Decrease Up"; };
          "bind \"L\"" = { Resize = "Decrease Right"; };
          "bind \"=\"" = { Resize = "Increase"; };
          "bind \"-\"" = { Resize = "Decrease"; };
        };
        scroll = {
          "bind \"Ctrl g\"" = {
            ScrollToBottom = { };
            SwitchToMode = "Locked";
          };
          "bind \"Ctrl c\" \"Enter\"" = { SwitchToMode = "Normal"; };
          "bind \"g\"" = { ScrollToTop = { }; };
          "bind \"G\"" = { ScrollToBottom = { }; };
          "bind \"j\" \"Down\"" = { ScrollDown = { }; };
          "bind \"k\" \"Up\"" = { ScrollUp = { }; };
          "bind \"Ctrl d\" \"l\"" = { PageScrollDown = { }; };
          "bind \"Ctrl u\" \"h\"" = { PageScrollUp = { }; };
          "bind \"d\"" = { HalfPageScrollDown = { }; };
          "bind \"u\"" = { HalfPageScrollUp = { }; };
        };
        session = {
          "bind \"Ctrl g\"" = { SwitchToMode = "Locked"; };
          "bind \"Ctrl c\"" = { SwitchToMode = "Normal"; };
          "bind \"d\"" = { Detach = { }; };
        };
      };
    };
  };
}
