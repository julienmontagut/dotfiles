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
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      oil-nvim
      oil-git-nvim
      plenary-nvim
      snacks-nvim
      telescope-nvim
      trouble-nvim
      tokyonight-nvim
    ];

    extraPackages = with pkgs; [
      # Go
      gopls

      # Rust
      rust-analyzer
      rustfmt

      # .NET
      roslyn-ls

      # Nix
      nixd
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
      marksman

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

    extraLuaConfig = ''
      -- Space as leader
      vim.g.mapleader = ' '
      vim.g.maplocalleader = ' '

      -- General options
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

      -- Colorscheme
      require('tokyonight').setup({ style = 'storm' })
      vim.cmd.colorscheme('tokyonight')

      -- Treesitter (built-in in Neovim 0.10+)
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })

      -- Snacks
      require('snacks').setup({
        dashboard = {
          enabled = true,
          sections = {
            { section = 'header' },
            { section = 'keys', gap = 1, padding = 1 },
            { section = 'recent_files', icon = ' ', title = 'Recent Files', padding = 1 },
            { section = 'projects', icon = ' ', title = 'Projects', padding = 1 },
          },
        },
        dim = { enabled = false },
        explorer = { enabled = true, replace_netrw = false },
        indent = { enabled = true },
        input = { enabled = true },
        lazygit = { enabled = true },
        picker = { enabled = true },
        quickfile = { enabled = true },
        terminal =  { enabled = true },
      })

      -- File explorer
      require('oil').setup()
      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

      -- Flash (motion)
      require('flash').setup({
        modes = {
          search = {
            enabled = true,
          },
          char = {
            jump_labels = true,
          },
        }
      })

      -- Telescope
      local telescope = require('telescope.builtin')
      vim.keymap.set('n', '<leader>sf', telescope.find_files, { desc = 'Search files' })
      vim.keymap.set('n', '<leader>sg', telescope.live_grep, { desc = 'Search grep' })
      vim.keymap.set('n', '<leader>sb', telescope.buffers, { desc = 'Search buffers' })
      vim.keymap.set('n', '<leader>sh', telescope.help_tags, { desc = 'Search help' })
      vim.keymap.set('n', '<leader>sr', telescope.lsp_references, { desc = 'Search references' })
      vim.keymap.set('n', '<leader>ss', telescope.lsp_document_symbols, { desc = 'Search symbols' })
      vim.keymap.set('n', '<leader>sd', telescope.diagnostics, { desc = 'Search diagnostics' })

      -- Trouble
      require('trouble').setup()

      -- Completion
      local blink = require('blink-cmp')
      blink.setup({
        keymap = { preset = 'default' },
        completion = {
          documentation = { auto_show = true },
        },
        sources = {
          default = { 'lsp', 'snippets', 'path', 'buffer' },
        },
      })

      -- Pass blink-cmp capabilities to all LSP servers
      vim.lsp.config('*', {
        capabilities = blink.get_lsp_capabilities(),
      })

      -- Formatting (conform → LSP fallback, silent on failure)
      require('conform').setup({
        formatters_by_ft = {
          bash = { 'shfmt' },
          go = { 'gofmt' },
          lua = { 'stylua' },
          nix = { 'nixfmt' },
          rust = { 'rustfmt' },
          sh = { 'shfmt' },
        },
        default_format_opts = {
          lsp_format = 'fallback',
          quiet = true,
        },
        format_on_save = function(bufnr)
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
            quiet = true,
          }
        end,
      })


      -- LSP keybindings
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local opts = { buffer = args.buf }
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '<leader>cf', function() require('conform').format({ async = true, lsp_format = 'fallback', quiet = true }) end, opts)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        end,
      })

      -- LSP servers
      vim.lsp.enable({
        'bashls',
        'biome',
        'buf_ls',
        'clangd',
        'cssls',
        'dockerls',
        'gopls',
        'helm_ls',
        'html',
        'htmx',
        'jsonls',
        'lua_ls',
        'marksman',
        'nickel_ls',
        'nixd',
        'postgres_lsp',
        'roslyn_ls',
        'rust_analyzer',
        'tailwindcss',
        'taplo',
        'terraformls',
        'vtsls',
        'yamlls',
      })
    '';
  };
}
