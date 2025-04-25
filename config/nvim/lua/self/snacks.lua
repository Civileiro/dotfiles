-- snacks.lua
require("snacks").setup({
  bigfile = { enabled = true },
  dashboard = {
    sections = {
      { section = "header" },
      { section = "keys", gap = 1 },
      { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = { 2, 2 } },
      { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
    },
  },
  image = { enabled = true },
  input = { enabled = true },
  scroll = { enabled = true },
})
