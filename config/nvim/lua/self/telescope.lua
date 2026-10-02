-- telescope.lua
local builtin = require("telescope.builtin")

local function leave_neotree_then(callback)
  return function()
    if vim.bo.filetype == "neo-tree" then
      vim.cmd.wincmd("p")
    end
    callback()
  end
end

vim.keymap.set("n", "<Leader>ff", builtin.find_files, {
  desc = "[F]ind [F]iles",
})
vim.keymap.set("n", "<Leader>fg", leave_neotree_then(builtin.live_grep), {
  desc = "[F]ind contents with [G]rep",
})
vim.keymap.set("n", "<Leader>gf", leave_neotree_then(builtin.git_files), {
  desc = "With only [G]it files, [F]ind contents with grep",
})
