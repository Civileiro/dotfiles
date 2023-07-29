-- lsp/formatting.lua

require("formatter").setup({
  filetype = {
    python = {
      require("formatter.filetypes.python").black
    },
    nix = {
      require("formatter.filetypes.nix").nixfmt
    },
    ["*"] = {
      require("formatter.filetypes.any").remove_trailing_whitespace
    }
  }
})

vim.keymap.set("n", "<C-s>", function()
  -- format with lsp if there's one capable
  local lsp_format = false
  for _, client in pairs(vim.lsp.buf_get_clients()) do
    if client.supports_method("textDocument/formatting") then
      vim.lsp.buf.format()
      lsp_format = true
      break
    end
  end
  -- fallback to external formatter
  if not lsp_format then
    vim.cmd("Format")
  end
  vim.cmd.write()
end, {
  desc = "Format & [S]ave",
})
