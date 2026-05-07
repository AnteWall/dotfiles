return {
	"OXY2DEV/markview.nvim",
	lazy = false,
	keys = {
		{ "<leader>m", "<cmd>Markview toggle<CR>", desc = "Toggle Markdown preview" },
	},
	opts = {
		preview = {
			filetypes = { "markdown", "opencode_output" },
			icon_provider = "internal",
		},
	},
}
