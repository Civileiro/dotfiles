-- aerial.lua
require("aerial").setup({
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set("n", "{", function()
      local count = vim.v.count1
      vim.cmd(count .. "AerialPrev")
    end, { buffer = bufnr })
    vim.keymap.set("n", "}", function()
      local count = vim.v.count1
      vim.cmd(count .. "AerialNext")
    end, { buffer = bufnr })
  end,
  autojump = true,
})

vim.keymap.set("n", "<Leader>a", "<cmd>AerialToggle!<CR>")
