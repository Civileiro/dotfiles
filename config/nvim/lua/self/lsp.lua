-- lsp.lua

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
    map("n", "<Leader><Space>", vim.lsp.buf.hover)
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
      scope = "cursor",
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

-- CMP setup
local cmp = require("cmp")
local cmp_select_opts = { behavior = cmp.SelectBehavior.Select }
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  view = {
    entries = {
      name = "custom",
    }
  },
  mapping = {
    ["<C-Up>"] = cmp.mapping(
      cmp.mapping.select_prev_item(cmp_select_opts),
      { "i", "c" }
    ),
    ["<C-Down>"] = cmp.mapping(
      cmp.mapping.select_next_item(cmp_select_opts),
      { "i", "c" }
    ),
    ["<CR>"] = cmp.mapping(cmp.mapping.confirm(), { "i", "c" }),
    ["<PageUp>"] = cmp.mapping.scroll_docs(-4),
    ["<PageDown>"] = cmp.mapping.scroll_docs(4),
    ["<Tab>"] = cmp.mapping(function(fallback)
      local col = vim.fn.col(".") - 1
        -- if completion is available, select the first one
      if cmp.visible() then
        cmp.confirm({ select = true })
        -- else if able to navigate snippet, do so
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
        -- else if there nothing to complete, fallback
      elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
        fallback()
      else -- else complete
        cmp.complete()
      end
    end, {"i", "c", "s"}),
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "nvim_lsp_signature_help" },
    { name = "nvim_lua" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
  }),
  enabled = function()
    -- disable completion in comments
    if vim.api.nvim_get_mode().mode == "c" then
      return true
    else
      local context = require("cmp.config.context")
      return not context.in_treesitter_capture("comment")
        and not context.in_syntax_group("Comment")
    end
  end,
})

cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "git" },
  }, {
    { name = "buffer" },
  })
})
cmp.setup.cmdline({ '/', '?' }, {
  sources = {
    { name = 'buffer' }
  }
})
cmp.setup.cmdline(":", {
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  })
})


-- LSPCONFIG setup
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")

lspconfig["lua_ls"].setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT", },
      diagnostics = { globals = { "vim" }, },
      telemetry = { enable = false, },
    },
  },
})
lspconfig["pyright"].setup({
  capabilities = capabilities,
})
lspconfig["clangd"].setup({
  capabilities = capabilities,
})
lspconfig["jdtls"].setup({
  capabilities = capabilities,
  -- nix calls it "jdt-language-server" instead of "jdtls"
  cmd = {
    "jdt-language-server",
    "-configuration", "/home/user/.cache/jdtls/config",
    "-data", "/home/user/.cache/jdtls/workspace"
  },
})
lspconfig["nil_ls"].setup({
  capabilities = capabilities,
})

local has_rust, rt = pcall(require, "rust-tools")
if has_rust then
  rt.setup({
    server = {
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          check = { command = "clippy", },
        },
      },
    }
  })
end
