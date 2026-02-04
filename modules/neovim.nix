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
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      oil-nvim
      oil-git-nvim
      snacks-nvim
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

    initLua = ''
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
      vim.opt.sidescrolloff = 8
      vim.opt.clipboard = 'unnamedplus'
      vim.opt.wrap = false
      vim.opt.cursorline = true
      vim.opt.colorcolumn = '100'

      -- Paste in visual mode without yanking replaced text
      vim.keymap.set('x', 'p', '"_dP', { desc = 'Paste without yanking replaced text' })

      -- Colorscheme (transparent background)
      require('tokyonight').setup({
        style = 'storm',
        transparent = true,
        styles = {
          sidebars = 'transparent',
          floats = 'transparent',
        },
      })
      vim.cmd.colorscheme('tokyonight')

      -- Lualine statusline
      require('lualine').setup({
        options = {
          theme = 'tokyonight',
        },
      })

      -- Treesitter
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
          -- char = {
          --   jump_labels = true,
          -- },
        }
      })

      -- Search/Picker (snacks.nvim)
      vim.keymap.set('n', '<leader>sf', function() Snacks.picker.files() end, { desc = 'Search files' })
      vim.keymap.set('n', '<leader>sg', function() Snacks.picker.grep() end, { desc = 'Search grep' })
      vim.keymap.set('n', '<leader>sw', function() Snacks.picker.grep_word() end, { desc = 'Search word under cursor' })
      vim.keymap.set('n', '<leader>sb', function() Snacks.picker.buffers() end, { desc = 'Search buffers' })
      vim.keymap.set('n', '<leader>sh', function() Snacks.picker.help() end, { desc = 'Search help' })
      vim.keymap.set('n', '<leader>sr', function() Snacks.picker.lsp_references() end, { desc = 'Search references' })
      vim.keymap.set('n', '<leader>ss', function() Snacks.picker.lsp_symbols() end, { desc = 'Search symbols (buffer)' })
      vim.keymap.set('n', '<leader>sa', function() Snacks.picker.lsp_workspace_symbols() end, { desc = 'Search symbols (all)' })
      vim.keymap.set('n', '<leader>si', function() Snacks.picker.lsp_implementations() end, { desc = 'Search implementations' })
      vim.keymap.set('n', '<leader>st', function() Snacks.picker.lsp_type_definitions() end, { desc = 'Search type definitions' })
      vim.keymap.set('n', '<leader>sp', function() Snacks.picker.diagnostics() end, { desc = 'Search problems' })
      vim.keymap.set('n', '<leader>sc', function() Snacks.picker.commands() end, { desc = 'Search commands' })
      vim.keymap.set('n', '<leader>sk', function() Snacks.picker.keymaps() end, { desc = 'Search keymaps' })
      vim.keymap.set('n', '<leader>sl', function() Snacks.picker.lines() end, { desc = 'Search lines in buffer' })
      vim.keymap.set('n', '<leader>sm', function() Snacks.picker.marks() end, { desc = 'Search marks' })
      vim.keymap.set('n', '<leader>sj', function() Snacks.picker.jumps() end, { desc = 'Search jumplist' })
      vim.keymap.set('n', '<leader>s/', function() Snacks.picker.grep_buffers() end, { desc = 'Search in open buffers' })

      -- Git
      vim.keymap.set('n', '<leader>gg', function() Snacks.lazygit.open() end, { desc = 'Git lazygit' })
      vim.keymap.set('n', '<leader>gl', function() Snacks.lazygit.log() end, { desc = 'Git log (file)' })
      vim.keymap.set('n', '<leader>gf', function() Snacks.picker.git_files() end, { desc = 'Git files' })
      vim.keymap.set('n', '<leader>gs', function() Snacks.picker.git_status() end, { desc = 'Git status' })
      vim.keymap.set('n', '<leader>gb', function() Snacks.picker.git_branches() end, { desc = 'Git branches' })
      vim.keymap.set('n', '<leader>gc', function() Snacks.picker.git_log() end, { desc = 'Git commits' })

      -- Tools
      vim.keymap.set('n', '<leader>e', function() Snacks.explorer.toggle() end, { desc = 'Toggle explorer' })
      vim.keymap.set('n', '<C-`>', function() Snacks.terminal.toggle() end, { desc = 'Toggle terminal' })
      vim.keymap.set('t', '<C-`>', function() Snacks.terminal.toggle() end, { desc = 'Toggle terminal' })
      vim.keymap.set('n', '<leader>tt', function() Snacks.terminal.toggle() end, { desc = 'Toggle terminal' })
      vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

      -- Trouble
      require('trouble').setup({
        auto_preview = false,
        focus = true,
        modes = {
          diagnostics = {
            auto_open = false,
            auto_close = true,
            auto_preview = true,
            auto_refresh = true,
            focus = true,
            follow = true,
          },
        },
      })

      -- Underline diagnostics
      vim.diagnostic.config({
        underline = true,
        virtual_text = { spacing = 4, prefix = '●' },
        signs = true,
        update_in_insert = false,
      })

      -- Problems (Trouble)
      vim.keymap.set('n', '<leader>pp', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Problems (all)' })
      vim.keymap.set('n', '<leader>pb', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Problems (buffer)' })
      vim.keymap.set('n', '<leader>ps', '<cmd>Trouble symbols toggle<cr>', { desc = 'Problems symbols' })
      vim.keymap.set('n', '<leader>pq', '<cmd>Trouble qflist toggle<cr>', { desc = 'Problems quickfix' })
      vim.keymap.set('n', '<leader>pl', '<cmd>Trouble loclist toggle<cr>', { desc = 'Problems loclist' })

      -- Quickfix navigation
      vim.keymap.set('n', '<leader>qo', '<cmd>copen<cr>', { desc = 'Open quickfix' })
      vim.keymap.set('n', '<leader>qc', '<cmd>cclose<cr>', { desc = 'Close quickfix' })
      vim.keymap.set('n', '[q', '<cmd>cprev<cr>', { desc = 'Previous quickfix item' })
      vim.keymap.set('n', ']q', '<cmd>cnext<cr>', { desc = 'Next quickfix item' })

      -- Completion
      local blink = require('blink-cmp')
      blink.setup({
        keymap = {
          preset = 'default',
          ['<Tab>'] = { 'select_and_accept', 'fallback' },
          ['<CR>'] = { 'select_and_accept', 'fallback' },
        },
        completion = {
          documentation = { auto_show = true },
          trigger = {
            show_on_insert_on_trigger_character = true,
            show_on_keyword = true,
          },
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
