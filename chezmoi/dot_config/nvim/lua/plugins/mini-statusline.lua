return {
	"echasnovski/mini.statusline",
	version = "*",
	lazy = false,
	config = function()
		local statusline = require("mini.statusline")
		statusline.setup({
			use_icons = true,
		})

		-- Show line:col in the cursor section instead of just line
		---@diagnostic disable-next-line: duplicate-set-field
		MiniStatusline.section_location = function()
			return "%2l:%-2v"
		end
	end,
}
