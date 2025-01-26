{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      # copilot-vim
      mini-nvim
      nvim-lspconfig
      nvim-treesitter
      nvim-treesitter-parsers.bash
      nvim-treesitter-parsers.c_sharp
      nvim-treesitter-parsers.css
      nvim-treesitter-parsers.dockerfile
      nvim-treesitter-parsers.editorconfig
      nvim-treesitter-parsers.gitignore
      nvim-treesitter-parsers.gitcommit
      nvim-treesitter-parsers.gitattributes
      nvim-treesitter-parsers.git_config
      nvim-treesitter-parsers.git_rebase
      nvim-treesitter-parsers.gleam
      nvim-treesitter-parsers.html
      nvim-treesitter-parsers.json
      nvim-treesitter-parsers.jsonc
      nvim-treesitter-parsers.just
      nvim-treesitter-parsers.nix
      nvim-treesitter-parsers.proto
      nvim-treesitter-parsers.rust
      nvim-treesitter-parsers.scss
      nvim-treesitter-parsers.swift
      nvim-treesitter-parsers.toml
      nvim-treesitter-parsers.yaml
      nvim-treesitter-parsers.zig
      nvim-treesitter-textobjects
      oil-nvim
      plenary-nvim
      telescope-nvim
    ];
  };
}
