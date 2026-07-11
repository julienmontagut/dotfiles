# JetBrains keymap setup (Rider / RustRover)

`ideavimrc` covers the modal `<space>` leader and `g`-family inside the editor.
The GUI fallback layer (`Cmd` on macOS / `Alt` on Linux) reaches tool windows,
where IdeaVim is inert. It lives in each IDE's own keymap and is **not**
symlinkable from this repo, so set it once per IDE under **Settings → Keymap**.

## Bindings to add

macOS uses the *macOS* keymap (`Cmd`); Linux uses the default keymap (`Alt`) -
same physical thumb key.

| Action ID                         | macOS   | Linux   | Leader twin  |
| --------------------------------- | ------- | ------- | ------------ |
| `GotoFile`                        | `Cmd+P` | `Alt+P` | `<leader>f`  |
| `SelectInProjectView`             | `Cmd+E` | `Alt+E` | `<leader>e`  |
| `GotoSymbol`                      | `Cmd+S` | `Alt+S` | `<leader>s`  |
| `GotoAction`                      | `Cmd+A` | `Alt+A` | -            |
| `ActivateProblemsViewToolWindow`  | `Cmd+D` | `Alt+D` | `<leader>x`  |
| `ActivateTerminalToolWindow`      | `Cmd+T` | `Alt+T` | `<leader>t`  |

macOS: unbind the native holders first (`Cmd+S` save, `Cmd+A` select-all,
`Cmd+E` recent files) or pick the next free letter and note the substitution.

Linux: uncheck **Appearance & Behavior → Appearance → "Enable mnemonics in
menu"** and **"mnemonics in controls"**, otherwise the menu bar swallows
`Alt+<letter>`. (Sway now uses Super as `$mod`, so the Alt layer is free.)

Tool-window focus stays native: `Alt+1..9` activate, `Escape` / `Shift+Escape`
back to editor, `Ctrl+Tab` switcher. `<C-w>hjkl` navigates editor splits only -
it cannot reach tool windows; that is a platform limit.
