return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		bigfile = { enabled = true },
		dashboard = {
			enabled = true,
			on_open = function(buf)
				vim.opt_local.number = false
				vim.opt_local.relativenumber = false
			end,
		},
		explorer = { enabled = false },
		indent = { enabled = true },
		input = { enabled = true },
		picker = { enabled = true },
		notifier = {
			enabled = true,
			top_down = false,
			position = "bottom_left",
		},
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = true },
		terminal = { enabled = true },
		statuscolumn = { enabled = false },
		words = { enabled = false },
		lazygit = {
			enabled = true,
			configure = true,
			config = {
				os = { editPreset = "nvim-remote" },
				gui = { nerdFontsVersion = "3" },
				git = {
					paging = {
						colorArg = "always",
						pager = 'delta --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format="lazygit-edit://{path}:{line}"',
						useConfig = false,
					},
				},
			},
		},
	},
	keys = {
		{ "<leader>pf", function() Snacks.picker.files() end, desc = "Find files" },
		{ "<C-p>", function() Snacks.picker.git_files() end, desc = "Find git files" },
		{ "<leader>pws", function() Snacks.picker.grep_word() end, desc = "Grep current word" },
		{
			"<leader>pWs",
			function()
				Snacks.picker.grep_word({ word = vim.fn.expand("<cWORD>") })
			end,
			desc = "Grep current WORD",
		},
		{ "<leader>ps", function() Snacks.picker.grep() end, desc = "Grep with prompt" },
		{ "<leader>vh", function() Snacks.picker.help() end, desc = "Search help tags" },
		{
			"<C-_>",
			function() Snacks.lazygit({ env = { NVIM = vim.v.servername } }) end,
			desc = "Lazygit",
		},
		{
			"<C-/>",
			function() Snacks.lazygit({ env = { NVIM = vim.v.servername } }) end,
			desc = "Lazygit",
		},
		{
			"<leader>gd",
			function() Snacks.lazygit({ env = { NVIM = vim.v.servername } }) end,
			desc = "Lazygit",
		},
		{
			"<leader>;",
			mode = { "n", "t" },
			function()
				Snacks.terminal("zsh", {
					win = {
						position = "float",
						border = "rounded",
						width = 0.8,
						height = 0.8,
					},
					start_insert = true,
				})
			end,
			desc = "Floating terminal",
		},
	},
}
