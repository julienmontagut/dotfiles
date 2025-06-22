return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>f",
            function()
                require("conform").format({ async = true, lsp_fallback = true })
            end,
            mode = "",
            desc = "Format buffer",
        },
    },
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "isort", "black" },
            javascript = { { "prettierd", "prettier" } },
            typescript = { { "prettierd", "prettier" } },
            javascriptreact = { { "prettierd", "prettier" } },
            typescriptreact = { { "prettierd", "prettier" } },
            json = { { "prettierd", "prettier" } },
            yaml = { { "prettierd", "prettier" } },
            markdown = { { "prettierd", "prettier" } },
            html = { { "prettierd", "prettier" } },
            css = { { "prettierd", "prettier" } },
            rust = { "rustfmt" },
        },
        format_on_save = { timeout_ms = 500, lsp_fallback = true },
    },
}
