-- neotree.lua
require("neo-tree").setup({
  close_if_last_window = true,
})
vim.keymap.set("n", "<Leader>e", "<Cmd>Neotree toggle<CR>", {
  desc = "Toggle [E]xplorer (neo-tree)"
})


