-- remap.lua
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "<C-s>", ":w<CR>")
vim.keymap.set("n", "<C-r>", ":so<CR>")

-- disable space, its our leader key
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

