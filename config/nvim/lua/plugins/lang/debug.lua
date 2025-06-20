return {
    {
        "mfussenegger/nvim-dap",
        lazy = true,
        keys = {
            { "<F5>", desc = "Start debugging" },
            { "<leader>bp", desc = "Toggle breakpoint" },
            { "<leader>dt", desc = "Toggle debug UI" },
        },
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            -- Setup DAP UI
            dapui.setup({
                layouts = {
                    {
                        elements = {
                            { id = "scopes", size = 0.33 },
                            { id = "breakpoints", size = 0.17 },
                            { id = "stacks", size = 0.25 },
                            { id = "watches", size = 0.25 },
                        },
                        size = 0.33,
                        position = "right",
                    },
                    {
                        elements = {
                            { id = "repl", size = 0.45 },
                            { id = "console", size = 0.55 },
                        },
                        size = 0.27,
                        position = "bottom",
                    },
                },
                floating = {
                    max_height = 0.9,
                    max_width = 0.5,
                    border = "rounded",
                    mappings = {
                        close = { "q", "<Esc>" },
                    },
                },
            })

            -- Setup virtual text
            require("nvim-dap-virtual-text").setup({
                enabled = true,
                enabled_commands = true,
                highlight_changed_variables = true,
                highlight_new_as_changed = false,
                show_stop_reason = true,
                commented = false,
                only_first_definition = true,
                all_references = false,
                display_callback = function(variable, buf, stackframe, node, options)
                    if options.virt_text_pos == "inline" then
                        return " = " .. variable.value
                    else
                        return variable.name .. " = " .. variable.value
                    end
                end,
            })

            -- Rust debugger configuration
            dap.adapters.lldb = {
                type = "executable",
                command = "/usr/bin/lldb-vscode", -- Adjust path as needed
                name = "lldb",
            }

            dap.configurations.rust = {
                {
                    name = "Launch",
                    type = "lldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input(
                            "Path to executable: ",
                            vim.fn.getcwd() .. "/target/debug/",
                            "file"
                        )
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    args = {},
                    runInTerminal = false,
                },
                {
                    name = "Launch (with args)",
                    type = "lldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input(
                            "Path to executable: ",
                            vim.fn.getcwd() .. "/target/debug/",
                            "file"
                        )
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    args = function()
                        local args_string = vim.fn.input("Arguments: ")
                        return vim.split(args_string, " ")
                    end,
                    runInTerminal = false,
                },
                {
                    name = "Attach to process",
                    type = "lldb",
                    request = "attach",
                    pid = function()
                        return tonumber(vim.fn.input("Process ID: "))
                    end,
                    cwd = "${workspaceFolder}",
                },
            }

            -- Auto open/close DAP UI
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            -- Debug keybindings with semantic prefixes
            local opts = { noremap = true, silent = true }

            -- Debug session control (d = debug)
            vim.keymap.set(
                "n",
                "<F5>",
                dap.continue,
                vim.tbl_extend("force", opts, { desc = "Continue" })
            )
            vim.keymap.set(
                "n",
                "<F10>",
                dap.step_over,
                vim.tbl_extend("force", opts, { desc = "Step Over" })
            )
            vim.keymap.set(
                "n",
                "<F11>",
                dap.step_into,
                vim.tbl_extend("force", opts, { desc = "Step Into" })
            )
            vim.keymap.set(
                "n",
                "<F12>",
                dap.step_out,
                vim.tbl_extend("force", opts, { desc = "Step Out" })
            )

            -- Breakpoints (b = breakpoint)
            vim.keymap.set(
                "n",
                "<leader>bp",
                dap.toggle_breakpoint,
                vim.tbl_extend("force", opts, { desc = "Toggle breakpoint" })
            )
            vim.keymap.set("n", "<leader>bc", function()
                dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end, vim.tbl_extend("force", opts, { desc = "Conditional breakpoint" }))
            vim.keymap.set("n", "<leader>bl", function()
                dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
            end, vim.tbl_extend("force", opts, { desc = "Log point" }))

            -- Debug UI (du = debug ui)
            vim.keymap.set(
                "n",
                "<leader>du",
                dapui.toggle,
                vim.tbl_extend("force", opts, { desc = "Toggle debug UI" })
            )
            vim.keymap.set(
                "n",
                "<leader>do",
                dap.repl.open,
                vim.tbl_extend("force", opts, { desc = "Open REPL" })
            )
            vim.keymap.set(
                "n",
                "<leader>dl",
                dap.run_last,
                vim.tbl_extend("force", opts, { desc = "Run last" })
            )
            vim.keymap.set(
                "n",
                "<leader>dx",
                dap.terminate,
                vim.tbl_extend("force", opts, { desc = "Terminate session" })
            )

            -- Debug evaluation (de = debug evaluate)
            vim.keymap.set({ "n", "v" }, "<leader>dh", function()
                require("dap.ui.widgets").hover()
            end, vim.tbl_extend("force", opts, { desc = "Hover variables" }))
            vim.keymap.set("n", "<leader>df", function()
                local widgets = require("dap.ui.widgets")
                widgets.centered_float(widgets.frames)
            end, vim.tbl_extend("force", opts, { desc = "Show frames" }))
            vim.keymap.set("n", "<leader>ds", function()
                local widgets = require("dap.ui.widgets")
                widgets.centered_float(widgets.scopes)
            end, vim.tbl_extend("force", opts, { desc = "Show scopes" }))

            -- Language-specific debugging (only when debugging is active)
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "rust",
                callback = function(event)
                    local rust_opts = { buffer = event.buf, noremap = true, silent = true }

                    -- Debug run (dr = debug run)
                    vim.keymap.set("n", "<leader>dr", function()
                        vim.fn.system("cargo build")
                        if vim.v.shell_error == 0 then
                            dap.continue()
                        else
                            vim.notify("Build failed, cannot start debugging", vim.log.levels.ERROR)
                        end
                    end, vim.tbl_extend(
                        "force",
                        rust_opts,
                        { desc = "Debug run" }
                    ))

                    -- Debug test (dt = debug test)
                    vim.keymap.set("n", "<leader>dt", function()
                        local current_line = vim.api.nvim_get_current_line()
                        local test_name = current_line:match("fn%s+([%w_]+)")
                        if test_name then
                            vim.fn.system("cargo build --tests")
                            if vim.v.shell_error == 0 then
                                dap.run({
                                    name = "Debug Test: " .. test_name,
                                    type = "lldb",
                                    request = "launch",
                                    program = vim.fn.getcwd()
                                        .. "/target/debug/deps/"
                                        .. vim.fn.fnamemodify(vim.fn.expand("%"), ":t:r"),
                                    args = { "--exact", test_name, "--nocapture" },
                                    cwd = "${workspaceFolder}",
                                    stopOnEntry = false,
                                })
                            else
                                vim.notify("Test build failed", vim.log.levels.ERROR)
                            end
                        else
                            vim.notify(
                                "No test function found on current line",
                                vim.log.levels.WARN
                            )
                        end
                    end, vim.tbl_extend(
                        "force",
                        rust_opts,
                        { desc = "Debug test" }
                    ))
                end,
            })
        end,
    },
}
