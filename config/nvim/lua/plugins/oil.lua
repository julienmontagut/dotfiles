return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    default_file_explorer = true,
    show_hidden = true,
    keymaps = {
      ["<CR>"] = function()
        local oil = require("oil")
        local entry = oil.get_cursor_entry()
        if entry and entry.type == "file" then
          oil.select({ vertical = true })
        else
          oil.select()
        end
      end,
    },
  },
  keys = {
    { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
  },
  dependencies = { "nvim-mini/mini.icons" },
  lazy = false,
}
