-- tvim - Testable Neovim configuration
-- This config uses lazy.nvim for plugin management
-- Edit this file directly at ~/.config/tvim/init.lua

-- Space as leader (must be set before lazy)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specs
local plugins = {
  -- Colorscheme
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('tokyonight').setup({
        style = 'storm',
        transparent = true,
        styles = {
          sidebars = 'transparent',
          floats = 'transparent',
        },
      })
      vim.cmd.colorscheme('tokyonight')
    end,
  },

  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = { theme = 'tokyonight' },
      })
    end,
  },

  -- Which-key (keybindings popup)
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require('which-key').setup({ delay = 300 })
    end,
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          'bash', 'c', 'c_sharp', 'cmake', 'comment', 'cpp', 'css', 'csv',
          'diff', 'dockerfile', 'editorconfig', 'gitcommit', 'git_config',
          'git_rebase', 'gitattributes', 'gitignore', 'go', 'gomod', 'gosum',
          'gotmpl', 'gpg', 'graphql', 'hcl', 'html', 'http', 'hyprlang', 'ini',
          'javascript', 'jsdoc', 'json', 'json5', 'just', 'lua', 'luadoc',
          'make', 'markdown', 'markdown_inline', 'mermaid', 'meson', 'nickel',
          'ninja', 'nix', 'pkl', 'printf', 'properties', 'proto', 'python',
          'query', 'regex', 'ron', 'rust', 'scss', 'slint', 'sql', 'ssh_config',
          'svelte', 'terraform', 'toml', 'tsx', 'typescript', 'vim', 'vimdoc',
          'xml', 'yaml', 'zig',
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  { 'nvim-treesitter/nvim-treesitter-textobjects', dependencies = { 'nvim-treesitter/nvim-treesitter' } },

  -- File explorer (Oil)
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('oil').setup()
      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
    end,
  },

  -- Git integration for Oil
  {
    'refractalize/oil-git-status.nvim',
    dependencies = { 'stevearc/oil.nvim' },
    config = true,
  },

  -- Snacks (dashboard, picker, terminal, etc.)
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    config = function()
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
        terminal = { enabled = true },
      })

      -- Search/Picker
      vim.keymap.set('n', '<leader>sf', function() Snacks.picker.files() end, { desc = 'Search files' })
      vim.keymap.set('n', '<leader>sg', function() Snacks.picker.grep() end, { desc = 'Search grep' })
      vim.keymap.set('n', '<leader>sw', function() Snacks.picker.grep_word() end, { desc = 'Search word under cursor' })
      vim.keymap.set('n', '<leader>sb', function() Snacks.picker.buffers() end, { desc = 'Search buffers' })
      vim.keymap.set('n', '<leader>sh', function() Snacks.picker.help() end, { desc = 'Search help' })
      vim.keymap.set('n', '<leader>ss', function() Snacks.picker.lsp_symbols() end, { desc = 'Search symbols (buffer)' })
      vim.keymap.set('n', '<leader>sa', function() Snacks.picker.lsp_workspace_symbols() end, { desc = 'Search symbols (all)' })
      vim.keymap.set('n', '<leader>st', function() Snacks.picker.lsp_type_definitions() end, { desc = 'Search type definitions' })
      vim.keymap.set('n', '<leader>sp', function() Snacks.picker.diagnostics() end, { desc = 'Search problems' })
      vim.keymap.set('n', '<leader>sc', function() Snacks.picker.commands() end, { desc = 'Search commands' })
      vim.keymap.set('n', '<leader>sk', function() Snacks.picker.keymaps() end, { desc = 'Search keymaps' })
      vim.keymap.set('n', '<leader>sl', function() Snacks.picker.lines() end, { desc = 'Search lines in buffer' })
      vim.keymap.set('n', '<leader>sm', function() Snacks.picker.marks() end, { desc = 'Search marks' })
      vim.keymap.set('n', '<leader>sj', function() Snacks.picker.jumps() end, { desc = 'Search jumplist' })
      vim.keymap.set('n', '<leader>s/', function() Snacks.picker.grep_buffers() end, { desc = 'Search in open buffers' })

      -- Git
      vim.keymap.set('n', '<leader>gg', function() Snacks.lazygit() end, { desc = 'Git lazygit' })
      vim.keymap.set('n', '<leader>gl', function() Snacks.lazygit.log() end, { desc = 'Git log (file)' })
      vim.keymap.set('n', '<leader>gf', function() Snacks.picker.git_files() end, { desc = 'Git files' })
      vim.keymap.set('n', '<leader>gs', function() Snacks.picker.git_status() end, { desc = 'Git status' })
      vim.keymap.set('n', '<leader>gb', function() Snacks.picker.git_branches() end, { desc = 'Git branches' })
      vim.keymap.set('n', '<leader>gc', function() Snacks.picker.git_log() end, { desc = 'Git commits' })

      -- Tools
      vim.keymap.set('n', '<C-w>e', function() Snacks.explorer() end, { desc = 'Toggle explorer' })
      vim.keymap.set('n', '<C-`>', function() Snacks.terminal.toggle() end, { desc = 'Toggle terminal' })
      vim.keymap.set('t', '<C-`>', function() Snacks.terminal.toggle() end, { desc = 'Toggle terminal' })
      vim.keymap.set('n', '<C-w>t', function() Snacks.terminal.toggle() end, { desc = 'Toggle terminal' })
      vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
    end,
  },

  -- Flash (motion)
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    config = function()
      require('flash').setup({
        modes = { search = { enabled = true } },
      })
    end,
  },

  -- Trouble (diagnostics panel)
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
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
      vim.keymap.set('n', '<leader>pp', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Problems (all)' })
      vim.keymap.set('n', '<leader>pb', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Problems (buffer)' })
      vim.keymap.set('n', '<leader>ps', '<cmd>Trouble symbols toggle<cr>', { desc = 'Problems symbols' })
      vim.keymap.set('n', '<leader>pq', '<cmd>Trouble qflist toggle<cr>', { desc = 'Problems quickfix' })
      vim.keymap.set('n', '<leader>pl', '<cmd>Trouble loclist toggle<cr>', { desc = 'Problems loclist' })
    end,
  },

  -- Completion (blink.cmp)
  {
    'saghen/blink.cmp',
    version = '*',
    config = function()
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
    end,
  },

  -- Formatting (conform)
  {
    'stevearc/conform.nvim',
    config = function()
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
    end,
  },

  -- LSP config
  {
    'neovim/nvim-lspconfig',
    config = function()
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
          vim.keymap.set(
            'n',
            '<leader>cf',
            function() require('conform').format({ async = true, lsp_format = 'fallback', quiet = true }) end,
            opts
          )
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        end,
      })

      -- Enable LSP servers (they must be installed on your system)
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
        'nil_ls',
        'postgres_lsp',
        'roslyn_ls',
        'rust_analyzer',
        'tailwindcss',
        'taplo',
        'terraformls',
        'vtsls',
        'yamlls',
      })
    end,
  },
}

-- Load plugins
require('lazy').setup(plugins, {
  defaults = { lazy = false },
  install = { colorscheme = { 'tokyonight' } },
  checker = { enabled = false },
  change_detection = { enabled = true, notify = false },
})

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

-- Window resize mode (sticky)
local resize_mode = false
local resize_amount = 2

local function exit_resize_mode()
  resize_mode = false
  vim.api.nvim_echo({ { '', '' } }, false, {})
end

local function enter_resize_mode()
  resize_mode = true
  vim.api.nvim_echo({ { '-- RESIZE MODE (h/j/k/l to resize, Esc to exit) --', 'ModeMsg' } }, false, {})
end

local function resize_if_active(direction)
  return function()
    if not resize_mode then return end
    if direction == 'h' then
      vim.cmd('vertical resize -' .. resize_amount)
    elseif direction == 'l' then
      vim.cmd('vertical resize +' .. resize_amount)
    elseif direction == 'j' then
      vim.cmd('resize -' .. resize_amount)
    elseif direction == 'k' then
      vim.cmd('resize +' .. resize_amount)
    end
  end
end

vim.keymap.set('n', '<C-w>r', enter_resize_mode, { desc = 'Enter resize mode' })
vim.keymap.set('n', '<Esc>', function()
  if resize_mode then
    exit_resize_mode()
  else
    vim.cmd('nohlsearch')
  end
end, { desc = 'Exit resize mode / Clear search' })
vim.keymap.set('n', '<C-c>', function()
  if resize_mode then exit_resize_mode() end
end, { desc = 'Exit resize mode' })

-- Resize mode mappings (only active in resize mode)
for _, key in ipairs({ 'h', 'j', 'k', 'l' }) do
  vim.keymap.set('n', key, function()
    if resize_mode then
      resize_if_active(key)()
    else
      vim.cmd('normal! ' .. key)
    end
  end, { desc = 'Resize or move' })
end

-- Underline diagnostics
vim.diagnostic.config({
  underline = true,
  virtual_text = { spacing = 4, prefix = '●' },
  signs = true,
  update_in_insert = false,
})

-- Quickfix navigation
vim.keymap.set('n', '<leader>qo', '<cmd>copen<cr>', { desc = 'Open quickfix' })
vim.keymap.set('n', '<leader>qc', '<cmd>cclose<cr>', { desc = 'Close quickfix' })
vim.keymap.set('n', '[q', '<cmd>cprev<cr>', { desc = 'Previous quickfix item' })
vim.keymap.set('n', ']q', '<cmd>cnext<cr>', { desc = 'Next quickfix item' })
