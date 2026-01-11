{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;
    
    plugins = with pkgs.vimPlugins; [
      blink-cmp
      flash-nvim
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      oil-nvim
      oil-git-nvim
    ];

    extraPackages = with pkgs; [
      gopls
      
      rust-analyzer
      rustfmt
      # Roslyn requires compiling
      roslyn-ls
    ];

    extraLuaConfig = ''
      vim.opt.number = true
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
      vim.opt.tabstop = 2
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.termguicolors = true
      vim.opt.signcolumn = 'yes'
      vim.opt.updatetime = 250
      vim.opt.swapfile = false
      vim.opt.undofile = true
      vim.opt.scrolloff = 8
      vim.opt.wrap = false

      vim.g.mapleader = ' '
      vim.g.maplocalleader = ' '

      -- LSP servers
      vim.lsp.enable({
          'biome',
          'buf_ls',
          'clangd',
          'cssls',
          'gopls',
          'html',
          'htmx',
          'jsonls',
          'lua_ls',
          'marksman',
          'nickel_ls',
          'nil_ls',
          'nixd',
          'roslyn',
          'rust_analyzer',
          'tailwindcss',
          'taplo',
          'vtsls',
          })
    '';
  };

  # xdg.configFile."nvim" = {
  #   source = ../config/nvim;
  #   onChange = ''
  #     mkdir -p ${config.xdg.dataHome}/nvim
  #     cp -f ${config.xdg.configHome}/nvim/lazy-lock.json ${config.xdg.dataHome}/nvim/lazy-lock.json
  #     '';
  # };
}
