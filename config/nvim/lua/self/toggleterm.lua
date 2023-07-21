-- toggleterm.lua
require("toggleterm").setup({})

vim.keymap.set({ "n", "t" }, "<C-t>", "<Cmd>:ToggleTerm direction=float<CR>", {
  desc = "Toggle [T]erminal",
})
