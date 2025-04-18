-- lsp/formatting.lua

require("formatter").setup({
  filetype = {
    python = {
      require("formatter.filetypes.python").black
    },
    nix = {
      require("formatter.filetypes.nix").nixfmt
    },
    json = {
      require("formatter.filetypes.json").jq
    },
    ["*"] = {
      require("formatter.filetypes.any").remove_trailing_whitespace
    }
  }
})

local disabled_lsp_formatters = {
  pyright = true,
  ruff_lsp = true,
}

vim.keymap.set("n", "<C-s>", function()
  -- format with lsp if there's one capable
  local lsp_format = false
  for _, client in pairs(vim.lsp.buf_get_clients()) do
    if disabled_lsp_formatters[client.name] then
      goto continue
    end
    if client.supports_method("textDocument/formatting") then
      vim.lsp.buf.format()
      lsp_format = true
      break
    end
    ::continue::
  end
  vim.cmd.write()
  -- fallback to external formatter
  if not lsp_format then
    vim.cmd("FormatWrite")
  end
end, {
  desc = "Format & [S]ave",
})
