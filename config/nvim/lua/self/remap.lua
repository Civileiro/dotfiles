-- remap.lua
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, {
  desc = "[P]re[V]ious (Opens netrw)"
})

vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Pleb [S]ave" })
vim.keymap.set("n", "<C-r>", ":so<CR>", { desc = "[R]eload" })

-- disable space, its our leader key
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", {
  desc = "<Nop>",
  silent = true,
})

-- move text like vscode
vim.keymap.set("v", "<M-Up>", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<M-Down>", ":m '>+1<CR>gv=gv")

-- centralize cursor when jumping
vim.keymap.set("n", "<PageUp>", "<C-u>zz")
vim.keymap.set("n", "<PageDown>", "<C-d>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- do actions without copying
vim.keymap.set("v", "<Leader>p", "\"_dP")
vim.keymap.set({ "n", "v" }, "<Leader>d", "\"_d")
