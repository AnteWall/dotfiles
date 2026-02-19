return {
	"neovim/nvim-lspconfig",
	dependencies = { "saghen/blink.cmp" },
	-- example using `opts` for defining servers
	opts = {
		servers = {
			lua_ls = {},
		},
	},
	keys = {
		{ "<leader>e", "<cmd>Telescope diagnostics<cr>", desc = "Open diagnostics" },
		{ "gD", vim.lsp.buf.declaration, desc = "Go to declaration" },
		{
			"gd",
			vim.lsp.buf.definition,
			desc = "Go to definition",
		},
		{
			"gi",
			vim.lsp.buf.implementation,
			desc = "Go to implementation",
		},
		{
			"K",
			function()
				vim.lsp.buf.hover({
					border = "single",
					max_height = 25,
					max_width = 120,
				})
			end,
			desc = "Hover documentation",
		},
	},
	config = function(_, opts)
		opts.presets = {
			blink = {
				auto_enable = true,
			},
			preset = {
				lsp_doc_border = true,
			},
		}
	end,
}
