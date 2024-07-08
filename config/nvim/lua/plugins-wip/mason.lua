return {
    {
        "williamboman/mason.nvim",
        opts = {}
    },
    {
        "williamboman/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {
                "lua_rs",
                "rust_analyzer"
            }
        }
    },
    {
        "neovim/nvim-lspconfig"
    }
}
