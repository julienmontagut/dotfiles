-- require('plugins')
require('settings')

-- Install lazy.nvim for plugin management
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Configure plugins using lazy 
require("lazy").setup({
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- Package manager for LSPs
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",

            -- Additional code completion
            "folke/neodev.nvim"
        }
    },
    
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-nvim-lsp-document-symbol",
            "hrsh7th/cmp-nvim-lua",
        }
    },
    
     "tiagovla/scope.nvim",

    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 
            'nvim-lua/plenary.nvim'
        }
    },
    
    'nvim-lualine/lualine.nvim',
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        lazy = false,
        priority = 1000
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate'
   },
   {
       'nvim-neo-tree/neo-tree.nvim',
       branch='v3.x',
       dependencies = {
           'nvim-lua/plenary.nvim',
           'MunifTanjim/nui.nvim',
        }
    }
},{})

-- Configure mason lsp
require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
	    "rust_analyzer"
    }
})

require('catppuccin').setup({
    flavour = 'latte',
    term_colors = true,
    dim_inactive = {
        enabled = true,
        shade = 'dark',
        percentage = 0.2,
    }
})

require("scope").setup({})

require("telescope").setup({
    extensions = {
        "scope"
    }
})

require('lualine').setup({
    options = {
        theme = 'catppuccin',
        icons_enabled = false,
    }
})

vim.cmd.colorscheme 'catppuccin'

