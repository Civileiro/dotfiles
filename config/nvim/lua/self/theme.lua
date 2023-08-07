-- theme.lua
require("catppuccin").setup({
  flavour = "mocha",
  -- transparent_background = true,
  integrations = {
    harpoon = true,
  },
})

vim.cmd.colorscheme("catppuccin")
