-- lualine.lua
require("lualine").setup({
  options = {
    theme = "catppuccin",
    disabled_filetypes = { "neo-tree" },
    globalstatus = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "filename" },
    lualine_c = { "diff", "diagnostics", "lsp_progress" },
    lualine_x = {
      {
        "encoding",
        cond = function()
          local enconding = vim.opt.fileencoding:get()
          if enconding == "utf-8" then return false end
          return true
        end
      },
      "filetype",
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})
