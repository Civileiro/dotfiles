-- treesitter.lua
require("nvim-treesitter.configs").setup({
  incremental_selection = {
    enable = true,
    keymaps = {
      node_incremental = "<C-Up>",
      node_decremental = "<C-Down>",
    },
  },
})
