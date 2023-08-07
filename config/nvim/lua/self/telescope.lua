-- telescope.lua
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<Leader>ff", builtin.find_files, {
  desc = "[F]ind [F]iles",
})
vim.keymap.set("n", "<Leader>fg", builtin.live_grep, {
  desc = "[F]ind contents with [G]rep",
})
vim.keymap.set("n", "<Leader>gf", builtin.git_files, {
  desc = "With only [G]it files, [F]ind contents with grep",
})
