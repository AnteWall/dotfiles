-- vim cursor
vim.opt.guicursor = {
	"n-v-c:block",
	"i-ci-ve:ver25",
	"r-cr:hor20",
}
-- Auto read files when changed outside of vim
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	pattern = "*",
	callback = function()
		if vim.fn.mode() ~= "c" then
			vim.cmd("checktime")
		end
	end,
})
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	pattern = "*.json.tmpl",
	callback = function()
		vim.bo.filetype = "json"
	end,
})

-- Fix line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Tabs/Indent
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Auto indent smart like if we write a if statement it will jump etc
vim.opt.smartindent = true

-- No annoying files
vim.opt.swapfile = false
vim.opt.backup = false
-- Instead perstistent undo!
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Match as we type
vim.opt.hlsearch = false
-- dont keep highlighting afterwards
vim.opt.incsearch = false

-- Fancy colors!
vim.opt.termguicolors = true

-- Keep context when scrolling
vim.opt.scrolloff = 8

vim.opt.signcolumn = "yes"

-- Allow @ in file names
vim.opt.isfname:append("@-@")

-- Lets update fast!
vim.opt.updatetime = 50

-- Max 80 chars
vim.opt.colorcolumn = "80"

-- Space is leader!
vim.g.mapleader = " "

vim.o.winborder = "rounded"

vim.cmd("filetype plugin indent on")
vim.opt.autoindent = true
