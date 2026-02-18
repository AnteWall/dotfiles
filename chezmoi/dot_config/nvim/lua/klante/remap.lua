vim.g.mapleader = " "

-- Replaced by Yazi
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Select code and then move up/down with J and K
vim.keymap.set("v", "K", ":m '<-2 <CR>gv=gv", { desc = "Move visual block up" })
vim.keymap.set("v", "J", ":m '>+1 <CR>gv=gv", { desc = "Move visual block down" })

-- fix J not moving your cursor wierd...
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join line below" })
-- Scroll but keep centered
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half-page down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half-page up and center" })

-- Screw p replacing clipboard, this fixes it
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without yanking replaced text" })

-- Copy to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })

-- Delte without destroying clipboard
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

-- Screw Ex Mode
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Ex mode" })

-- replace word under cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left><Left>]], { desc = "Substitute word under cursor" })
