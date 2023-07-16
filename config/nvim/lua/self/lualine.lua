-- lualine.lua
require("lualine").setup({
  options = {
    theme = "catppuccin",
  },
  sections = {
    lualine_c = { "filename", "lsp_progress" },
  },
})
