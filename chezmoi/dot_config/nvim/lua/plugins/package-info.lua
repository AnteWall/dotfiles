return {
	"vuki656/package-info.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{ "<leader>pi", "<cmd>lua require('package-info').toggle()<CR>", desc = "Show package info" },
	},
	config = function()
		require("package-info").setup()
	end,
}
