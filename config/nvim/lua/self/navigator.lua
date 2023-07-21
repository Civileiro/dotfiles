-- navigator.lua

vim.g.tmux_navigator_no_mappings = 1

vim.keymap.set({ "n", "t" }, "<C-Up>", "<Cmd>TmuxNavigateUp<CR>")
vim.keymap.set({ "n", "t" }, "<C-Down>", "<Cmd>TmuxNavigateDown<CR>")
vim.keymap.set({ "n", "t" }, "<C-Left>", "<Cmd>TmuxNavigateLeft<CR>")
vim.keymap.set({ "n", "t" }, "<C-Right>", "<Cmd>TmuxNavigateRight<CR>")
