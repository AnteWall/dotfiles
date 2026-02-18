return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"fredrikaverpil/neotest-golang",
		"leoluz/nvim-dap-go",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-golang")({
					dap = {
						justMyCode = false,
					},
				}),
				require("rustaceanvim.neotest"),
			},
		})
		vim.keymap.set("n", "<leader>tr", function()
			require("neotest").run.run({
				suite = false,
				testify = true,
			})
		end, { desc = "Debug: Run nearest test" })

		vim.keymap.set("n", "<leader>tv", function()
			require("neotest").summary.toggle()
		end, { desc = "Debug: Summary toggle" })

		vim.keymap.set("n", "<leader>ts", function()
			require("neotest").run.run({
				suite = true,
				testify = true,
			})
		end, { desc = "Debug: Run test suite" })

		vim.keymap.set("n", "<leader>td", function()
			require("neotest").run.run({
				suite = false,
				testify = true,
				strategy = "dap",
			})
		end, { desc = "Debug: Debug nearest test" })

		vim.keymap.set("n", "<leader>to", function()
			require("neotest").output.open()
		end, { desc = "Debug: Open test output" })

		vim.keymap.set("n", "<leader>ta", function()
			require("neotest").run.run(vim.fn.getcwd())
		end, { desc = "Debug: Run all tests in cwd" })

		vim.keymap.set("n", "<leader>tl", function()
			require("neotest").run.run_last()
		end, { desc = "Debug: Run last test" })

		vim.keymap.set("n", "<leader>tO", function()
			require("neotest").output_panel.toggle()
		end, { desc = "Debug: Toggle output panel" })
	end,
}
