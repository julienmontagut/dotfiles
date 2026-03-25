return {
    {
        dir = vim.fn.stdpath("config") .. "/colors",
        name = "basalt",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme basalt]])
        end,
    },
}
