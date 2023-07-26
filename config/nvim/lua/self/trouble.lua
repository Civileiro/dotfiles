-- trouble.lua
local trb = require("trouble")

vim.keymap.set({ "n", "v" }, "<Leader>tt", trb.open, {
  desc = "[T]oggle [T]rouble",
})
