-- harpoon.lua
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<Leader>a", mark.add_file, {
  desc = "[A]dd File to Quick Menu",
})
vim.keymap.set("n", "<C-q>", ui.toggle_quick_menu, {
  desc = "Toggle [Q]uick Menu",
})

