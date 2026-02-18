vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Select code and then move up/down with J and K
vim.keymap.set("v", "K", ":m '<-2 <CR>gv=gv", { desc = "Move visuabl block up"})
vim.keymap.set("v", "J", ":m '>+1 <CR>gv=gv", { desc = "Move visual block down"})

-- fix J not moving your cursor wierd...
vim.keymap.set("n", "J", "mzJ`z")
-- Scroll but keep centered
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Screw p replacing clipboard, this fixes it
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Copy to system clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Delte without destroying clipboard
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- Screw Ex Mode
vim.keymap.set("n", "Q", "<nop")

-- Format code
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- replace word under cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left><Left>]])
