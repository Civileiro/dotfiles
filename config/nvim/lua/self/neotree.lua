-- neotree.lua
require("neo-tree").setup({
  close_if_last_window = true,
  filesystem = {
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignore = true,
    },
  },
})
vim.keymap.set("n", "<Leader>e", "<Cmd>Neotree toggle<CR>", {
  desc = "Toggle [E]xplorer (neo-tree)"
})
