return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"saghen/blink.cmp",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	keys = {
		{ "<leader>e", "<cmd>Telescope diagnostics<cr>", desc = "Open diagnostics" },
		{ "gD", vim.lsp.buf.declaration, desc = "Go to declaration" },
		{ "gd", vim.lsp.buf.definition, desc = "Go to definition" },
		{ "gi", vim.lsp.buf.implementation, desc = "Go to implementation" },
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
	config = function()
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"gopls",
				"vtsls",
				"ty",
			},
			automatic_enable = false,
		})

		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = { globals = { "vim" } },
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
					format = {
						enable = true,
						defaultConfig = {
							indent_style = "space",
							indent_size = "2",
						},
					},
				},
			},
		})

		vim.lsp.config("gopls", { capabilities = capabilities })
		vim.lsp.config("vtsls", { capabilities = capabilities })
		vim.lsp.config("ty", { capabilities = capabilities })

		vim.lsp.enable({ "lua_ls", "gopls", "vtsls" })
		vim.lsp.enable("rust_analyzer", false)

		vim.diagnostic.config({
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})
	end,
}
