-- lsp/lint.lua

local lint = require("lint")

lint.linters_by_ft = {
  python = { "mypy" },
}

table.insert(lint.linters.mypy.args, "--cache-dir=.mypy_cache/.lint")
