-- lsp/autocmd.lua

local grp = vim.api.nvim_create_augroup("UserLspConfig", {})
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP mappings",
  group = grp,
  callback = function(event)
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = event.buf
      vim.keymap.set(mode, l, r, opts)
    end

    local function buf_cmd(...)
      vim.api.nvim_buf_create_user_command(event.buf, ...)
    end

    buf_cmd("LspFormat", function()
      vim.lsp.buf.format()
    end, { desc = "Format buffer with language server" })

    map("n", "gd", vim.lsp.buf.definition)
    map("n", "gD", vim.lsp.buf.declaration)
    map("n", "gi", vim.lsp.buf.implementation)
    map('n', 'gr', vim.lsp.buf.references)
    map("n", "<F2>", vim.lsp.buf.rename)
    map({ "n", "v" }, "<F3>", function()
      vim.lsp.buf.format({ async = true })
    end)
    map({ "n", "v" }, "<F4>", vim.lsp.buf.code_action)
    map("n", "<Leader><Space>", function()
      local winid = require('ufo').peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end)
    map("n", "[d", vim.diagnostic.goto_prev)
    map("n", "]d", vim.diagnostic.goto_next)
  end
})

vim.api.nvim_create_autocmd("CursorHold", {
  desc = "Hover Diagnostics",
  group = grp,
  callback = function()
    -- Do nothing if there's a floating window open
    for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_config(winid).zindex then
        return
      end
    end
    vim.diagnostic.open_float(0, {
      focusable = false,
      close_events = {
        "CursorMoved",
        "CursorMovedI",
        "BufHidden",
        "InsertCharPre",
        "WinLeave",
      },
    })
  end
})

vim.api.nvim_create_autocmd({ "BufWritePost", "BufNew" }, {
  desc = "Lint on Write",
  group = grp,
  callback = function()
    require("lint").try_lint()
  end,
})
