-- lsp/init.lua

vim.diagnostic.config({
  virtual_text = true,
  signs = false,
  update_in_insert = true,
  underline = true,
  severity_sort = false,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

vim.opt.completeopt = "menu,menuone,preview,noselect"

require("self.lsp.autocmd")
require("self.lsp.blink")
require("self.lsp.lspconfig")
require("self.lsp.linting")
require("self.lsp.formatting")
