return {
    {
        "EdenEast/nightfox.nvim",
        opts = {},
        config = function(_, opts)
            require("nightfox").setup({ options = opts })
            vim.cmd("colorscheme carbonfox")
        end,
    },
}
