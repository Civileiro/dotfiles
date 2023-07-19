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

