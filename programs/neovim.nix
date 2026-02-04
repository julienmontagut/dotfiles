{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      blink-cmp
      conform-nvim
      flash-nvim
      lualine-nvim
      nvim-lspconfig
      (nvim-treesitter.withPlugins (
        grammars: with grammars; [
          bash
          c
          c_sharp
          cmake
          comment
          cpp
          css
          csv
          diff
          dockerfile
          editorconfig
          gitcommit
          git_config
          git_rebase
          gitattributes
          gitignore
          go
          gomod
          gosum
          gotmpl
          gpg
          graphql
          hcl
          html
          http
          hyprlang
          ini
          javascript
          jsdoc
          json
          json5
          just
          lua
          luadoc
          make
          markdown
          markdown_inline
          mermaid
          meson
          nickel
          ninja
          nix
          pkl
          printf
          properties
          proto
          python
          query
          regex
          ron
          rust
          scss
          slint
          sql
          ssh_config
          svelte
          terraform
          toml
          tsx
          typescript
          vim
          vimdoc
          xml
          yaml
          zig
        ]
      ))
      nvim-treesitter-textobjects
      oil-nvim
      oil-git-nvim
      snacks-nvim
      trouble-nvim
      tokyonight-nvim
      which-key-nvim
    ];

    extraPackages = with pkgs; [
      # Go
      gopls

      # Rust
      rust-analyzer
      rustfmt

      # .NET
      # roslyn-ls

      # Nix
      nil
      nixfmt

      # Lua
      lua-language-server
      stylua

      # Bash
      bash-language-server
      shfmt

      # Web (HTML, CSS, JSON)
      vscode-langservers-extracted
      htmx-lsp

      # Markdown
      # marksman

      # Nickel
      nls

      # Terraform
      terraform-ls

      # Docker/Kubernetes/Helm
      dockerfile-language-server
      yaml-language-server
      helm-ls

      # PostgreSQL
      postgres-language-server
    ];

    initLua = builtins.readFile ../config/nvim-hm/init.lua;
  };
}
