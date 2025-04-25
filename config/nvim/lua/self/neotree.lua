-- neotree.lua
local function on_move(data)
  Snacks.rename.on_rename_file(data.source, data.destination)
end

local events = require("neo-tree.events")
require("neo-tree").setup({
  close_if_last_window = true,
  filesystem = {
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignore = true,
    },
  },
  event_handlers = {
    { event = events.FILE_MOVED,   handler = on_move },
    { event = events.FILE_RENAMED, handler = on_move },
  },
})
vim.keymap.set("n", "<Leader>e", "<Cmd>Neotree toggle<CR>", {
  desc = "Toggle [E]xplorer (neo-tree)"
})
