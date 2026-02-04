{
  pkgs
}:

{
  programs.zed-editor = {
      enable = true;
      userSettings = {
        vim_mode = true;
        ui_font_size = 16;
        buffer_font_size = 14;
        theme = "Tokyo Night Storm";
        scrollbar.show = "never";
        tab_bar.show = false;
        relative_line_numbers = false;
      };
      userKeymaps = [
        # Search (matching neovim <leader>s* bindings)
        {
          context = "Editor && vim_mode == normal && !menu";
          bindings = {
            "space s f" = "file_finder::Toggle";
            "space s g" = "pane::DeploySearch";
            "space s w" = "buffer_search::Deploy";
            "space s b" = "tab_switcher::Toggle";
            "space s h" = "zed::OpenBrowser";
            "space s r" = "editor::FindAllReferences";
            "space s s" = "outline::Toggle";
            "space s a" = "project_symbols::Toggle";
            "space s i" = "editor::GoToImplementation";
            "space s t" = "editor::GoToTypeDefinition";
            "space s p" = "diagnostics::Deploy";
            "space s c" = "command_palette::Toggle";
            "space s k" = "zed::OpenKeymap";
            "space s l" = "buffer_search::Deploy";
            "space s m" = "editor::GoToDefinition";
            "space s j" = "pane::GoBack";
          };
        }
        # Git (matching neovim <leader>g* bindings)
        {
          context = "Editor && vim_mode == normal && !menu";
          bindings = {
            "space g g" = "workspace::ToggleBottomDock";
            "space g l" = "editor::ToggleGitBlame";
            "space g s" = "workspace::ToggleBottomDock";
            "space g b" = "editor::ToggleGitBlame";
          };
        }
        # Problems (matching neovim <leader>p* bindings)
        {
          context = "Editor && vim_mode == normal && !menu";
          bindings = {
            "space p p" = "diagnostics::Deploy";
            "space p b" = "diagnostics::Deploy";
            "space p s" = "outline::Toggle";
          };
        }
        # Quickfix navigation
        {
          context = "Editor && vim_mode == normal && !menu";
          bindings = {
            "[ q" = "search::SelectPrevMatch";
            "] q" = "search::SelectNextMatch";
          };
        }
        # Tools (matching neovim bindings)
        {
          context = "Editor && vim_mode == normal && !menu";
          bindings = {
            "space e" = "workspace::ToggleLeftDock";
            "space t t" = "terminal_panel::ToggleFocus";
          };
        }
        # LSP/Code navigation (g* bindings - gD and K are standard vim)
        {
          context = "Editor && vim_mode == normal && !menu";
          bindings = {
            "g d" = "editor::GoToDefinition";
            "g shift-d" = "editor::GoToTypeDefinition";
            "g i" = "editor::GoToImplementation";
            "g r" = "editor::FindAllReferences";
            "shift-k" = "editor::Hover";
          };
        }
        # Code actions (matching neovim <leader>c* and <leader>r* bindings)
        {
          context = "Editor && vim_mode == normal && !menu";
          bindings = {
            "space r n" = "editor::Rename";
            "space c a" = "editor::ToggleCodeActions";
            "space c f" = "editor::Format";
          };
        }
        # Diagnostics navigation
        {
          context = "Editor && vim_mode == normal && !menu";
          bindings = {
            "[ d" = "editor::GoToPrevDiagnostic";
            "] d" = "editor::GoToNextDiagnostic";
          };
        }
        # Terminal toggle with Ctrl+`
        {
          context = "Workspace";
          bindings = {
            "ctrl-`" = "terminal_panel::ToggleFocus";
          };
        }
        # Completion bindings (matching neovim)
        {
          context = "Editor && showing_completions";
          bindings = {
            "tab" = "editor::ConfirmCompletion";
            "enter" = "editor::ConfirmCompletion";
            "ctrl-y" = "editor::ConfirmCompletion";
            "ctrl-n" = "editor::SelectNextCompletion";
            "ctrl-p" = "editor::SelectPrevCompletion";
            "ctrl-e" = "editor::Cancel";
          };
        }
      ];
    };
}
