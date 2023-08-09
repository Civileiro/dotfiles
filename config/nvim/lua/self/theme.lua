-- theme.lua

if vim.g.theme == "catppuccin" then
  require("catppuccin").setup({
    flavour = vim.g.catppuccin_flavour or "mocha",
    integrations = {
      harpoon = true,
    },
  })

  vim.cmd.colorscheme("catppuccin")
end
