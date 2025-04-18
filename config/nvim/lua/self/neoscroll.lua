-- neoscroll.lua
local ns = require("neoscroll")
ns.setup({
  mappings = { "zz" }
})

vim.keymap.set({ "n", "v" }, "<PageUp>", function()
  local h = vim.api.nvim_win_get_height(0)
  ns.scroll(-h, { duration = 200 })
end)
vim.keymap.set({ "n", "v" }, "<PageDown>", function()
  local h = vim.api.nvim_win_get_height(0)
  ns.scroll(h, { duration = 200 })
end)
