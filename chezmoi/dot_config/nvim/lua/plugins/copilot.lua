return {
	"github/copilot.vim",
	config = function()
		vim.keymap.set("i", "`", "<Plug>(copilot-dismiss)", { desc = "Dismiss copilot suggestion" })
	end,
}
