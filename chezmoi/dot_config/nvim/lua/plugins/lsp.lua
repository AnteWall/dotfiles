return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	keys = {
		{
			"<leader>e",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "Open diagnostics",
		},
		{ "<leader>a", vim.lsp.buf.code_action, desc = "Code action" },
		{ "gD", vim.lsp.buf.declaration, desc = "Go to declaration" },
		{ "gd", vim.lsp.buf.definition, desc = "Go to definition" },
		{ "gi", vim.lsp.buf.implementation, desc = "Go to implementation" },
		{
			"<leader>th",
			function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
			end,
			desc = "Toggle inlay hints",
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
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"gopls",
				"rust_analyzer",
				"ty",
				"pyright",
				"buf_ls",
			},
			automatic_enable = false,
		})

		-- Enable inlay hints globally
		vim.lsp.inlay_hint.enable(true)

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
					hint = {
						enable = true,
						paramName = "All",
						paramType = true,
						setType = true,
						arrayIndex = "Enable",
					},
				},
			},
		})

		vim.lsp.config("gopls", {
			capabilities = capabilities,
			settings = {
				gopls = {
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						compositeLiteralTypes = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
				},
			},
		})
		vim.lsp.config("pyright", {
			capabilities = capabilities,
			settings = {
				pyright = {
					-- Let ty handle type checking, use pyright for completions/imports
					disableOrganizeImports = false,
				},
				python = {
					analysis = {
						-- Disable type checking since ty handles it
						typeCheckingMode = "off",
						autoImportCompletions = true,
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
					},
				},
			},
		})

		vim.lsp.config("ty", { capabilities = capabilities })

		vim.lsp.enable({ "lua_ls", "gopls" })
		vim.lsp.enable("rust_analyzer", false)
		vim.lsp.enable("ty")
		vim.lsp.enable("pyright")
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
