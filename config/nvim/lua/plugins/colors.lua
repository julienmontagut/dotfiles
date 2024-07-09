return {
	"EdenEast/nightfox.nvim",
	priority = 1000,
	config = function()
		vim.cmd.colorscheme("carbonfox")
		-- You can configure highlights by doing something like:
		vim.cmd.hi("Comment gui=none")
	end,
}
