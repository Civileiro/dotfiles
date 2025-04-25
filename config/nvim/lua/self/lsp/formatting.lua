-- lsp/formatting.lua
local conform = require("conform")

local disabled_lsp_formatters = {
  pyright = true,
}

conform.setup({
  formatters_by_ft = {
    python = { "ruff_fix", "ruff_format" },
    json = { "jq" },
    ["_"] = { "trim_whitespace", lsp_format = "last" },
  },
  default_format_opts = {
    filter = function(client)
      vim.notify(client.name)
      return not disabled_lsp_formatters[client.name]
    end,
  },
})


vim.keymap.set("n", "<C-s>", function()
  conform.format()
  vim.cmd.write()
end, {
  desc = "Format & [S]ave",
})
