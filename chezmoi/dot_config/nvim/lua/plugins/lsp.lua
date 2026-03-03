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
		{ "<leader>a", vim.lsp.buf.code_action, desc = "Code action" },
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
				"buf_ls",
			},
			automatic_enable = false,
		})

		vim.lsp.config("buf_ls", {
			capabilities = capabilities,
			cmd = { "buf", "lsp", "serve" },
			filetypes = { "proto" },
			root_markers = { "buf.yaml", ".git" },
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
		vim.lsp.enable("ty")
		vim.lsp.enable("buf_ls")

		vim.diagnostic.config({
			virtual_lines = { current_line = true },
			virtual_text = false,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				header = "",
				prefix = "",
			},
		})
	end,
}
