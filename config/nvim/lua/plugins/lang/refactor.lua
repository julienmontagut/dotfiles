return {
    {
        "ThePrimeagen/refactoring.nvim",
        lazy = true,
        keys = {
            { "<leader>xf", mode = "x", desc = "Extract function" },
            { "<leader>xv", mode = "x", desc = "Extract variable" },
            { "<leader>xi", desc = "Inline variable" },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            local refactoring = require("refactoring")

            refactoring.setup({
                prompt_func_return_type = {
                    rust = true,
                },
                prompt_func_param_type = {
                    rust = true,
                },
                printf_statements = {
                    rust = {
                        'println!("%s", %s);',
                    },
                },
                print_var_statements = {
                    rust = {
                        'println!("{} = {:?}", "%s", %s);',
                    },
                },
            })

            -- Rust-specific refactoring keybindings
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "rust",
                callback = function(event)
                    local opts = { buffer = event.buf, noremap = true, silent = true }

                    -- Code extraction (x = extract/inline)
                    vim.keymap.set("x", "<leader>xf", function()
                        refactoring.refactor("Extract Function")
                    end, vim.tbl_extend(
                        "force",
                        opts,
                        { desc = "Extract function" }
                    ))

                    vim.keymap.set("x", "<leader>xv", function()
                        refactoring.refactor("Extract Variable")
                    end, vim.tbl_extend(
                        "force",
                        opts,
                        { desc = "Extract variable" }
                    ))

                    vim.keymap.set("x", "<leader>xb", function()
                        refactoring.refactor("Extract Block")
                    end, vim.tbl_extend(
                        "force",
                        opts,
                        { desc = "Extract block" }
                    ))

                    vim.keymap.set("n", "<leader>xi", function()
                        refactoring.refactor("Inline Variable")
                    end, vim.tbl_extend(
                        "force",
                        opts,
                        { desc = "Inline variable" }
                    ))

                    -- Debug print (use 'dd' prefix to avoid diagnostic collision)
                    vim.keymap.set("x", "<leader>dv", function()
                        refactoring.debug.print_var()
                    end, vim.tbl_extend(
                        "force",
                        opts,
                        { desc = "Debug print variable" }
                    ))

                    vim.keymap.set("n", "<leader>di", function()
                        refactoring.debug.printf({ below = false })
                    end, vim.tbl_extend(
                        "force",
                        opts,
                        { desc = "Debug insert print" }
                    ))

                    vim.keymap.set("n", "<leader>dc", function()
                        refactoring.debug.cleanup({})
                    end, vim.tbl_extend(
                        "force",
                        opts,
                        { desc = "Debug cleanup" }
                    ))

                    -- Code wrapping (xw = extract wrap) - language-specific wrapping
                    vim.keymap.set("n", "<leader>xm", function()
                        local word = vim.fn.expand("<cword>")
                        vim.cmd("normal! ciw")
                        vim.api.nvim_put(
                            { "Arc::new(Mutex::new(" .. word .. "))" },
                            "c",
                            true,
                            true
                        )
                    end, vim.tbl_extend(
                        "force",
                        opts,
                        { desc = "Wrap in Arc<Mutex<>>" }
                    ))

                    vim.keymap.set("n", "<leader>xa", function()
                        local word = vim.fn.expand("<cword>")
                        vim.cmd("normal! ciw")
                        vim.api.nvim_put({ "Arc::new(" .. word .. ")" }, "c", true, true)
                    end, vim.tbl_extend(
                        "force",
                        opts,
                        { desc = "Wrap in Arc<>" }
                    ))

                    vim.keymap.set("n", "<leader>xr", function()
                        local word = vim.fn.expand("<cword>")
                        vim.cmd("normal! ciw")
                        vim.api.nvim_put({ "Rc::new(" .. word .. ")" }, "c", true, true)
                    end, vim.tbl_extend(
                        "force",
                        opts,
                        { desc = "Wrap in Rc<>" }
                    ))

                    vim.keymap.set("n", "<leader>xo", function()
                        local word = vim.fn.expand("<cword>")
                        vim.cmd("normal! ciw")
                        vim.api.nvim_put({ "Box::new(" .. word .. ")" }, "c", true, true)
                    end, vim.tbl_extend(
                        "force",
                        opts,
                        { desc = "Wrap in Box<>" }
                    ))

                    -- Convert between different Rust patterns
                    vim.keymap.set("n", "<leader>rm", function()
                        -- Convert match to if let
                        local current_line = vim.fn.line(".")
                        local lines = vim.api.nvim_buf_get_lines(
                            0,
                            current_line - 1,
                            current_line + 10,
                            false
                        )
                        local match_line = ""
                        for i, line in ipairs(lines) do
                            if line:match("^%s*match%s+") then
                                match_line = line
                                break
                            end
                        end
                        if match_line ~= "" then
                            local var = match_line:match("match%s+([%w_]+)")
                            if var then
                                vim.notify(
                                    "Found match on " .. var .. " - manual conversion needed",
                                    vim.log.levels.INFO
                                )
                            end
                        end
                    end, vim.tbl_extend(
                        "force",
                        opts,
                        { desc = "Match to if let (hint)" }
                    ))
                end,
            })
        end,
    },
}
