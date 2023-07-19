-- comment.lua
require("Comment").setup({
  -- Don't create default keymaps
  mappings = {
    basic = false,
    extra = false,
  },
})

local api = require("Comment.api")

vim.keymap.set("n", "<Leader>cc", "<Plug>(comment_toggle_linewise_current)", {
  desc = "[C]omment [C]urrent line",
})
vim.keymap.set("n", "<Leader>c", "<Plug>(comment_toggle_linewise)", {
  desc = "[C]omment line",
})
vim.keymap.set("n", "<Leader>cb", "<Plug>(comment_toggle_blockwise)", {
  desc = "[C]omment [B]lock",
})
vim.keymap.set("x", "<Leader>cc", "<Plug>(comment_toggle_linewise_visual)", {
  desc = "[C]omment [C]urrent lines",
})
vim.keymap.set("x", "<Leader>cb", "<Plug>(comment_toggle_blockwise_visual)", {
  desc = "[C]omment [B]lock",
})
vim.keymap.set("n", "<Leader>co", api.insert.linewise.below, {
  desc = "[C]omment insert bel[O]w",
})
vim.keymap.set("n", "<Leader>cO", api.insert.linewise.above, {
  desc = "[C]omment insert ab[O]ve",
})
vim.keymap.set("n", "<Leader>cA", api.locked("insert.linewise.eol"), {
  desc = "[C]omment [A]ppend",
})
