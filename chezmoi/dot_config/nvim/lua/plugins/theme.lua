return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false,
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			term_colors = true,
			styles = {
				comments = { "italic" },
				keywords = { "italic" },
				functions = {},
				variables = {},
			},
			default_integrations = true,
			auto_integrations = true,
			integrations = {
				cmp = true,
				gitsigns = true,
				mini = { enabled = true },
				neotree = true,
				snacks = true,
				treesitter = true,
				treesitter_context = true,
				which_key = true,
			},
		})
		vim.cmd("colorscheme catppuccin-mocha")
	end,
}
