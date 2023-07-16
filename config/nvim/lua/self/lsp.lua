-- lsp.lua

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
      selection_order = "near_cursor",
    }
  },
  mapping = {
    ["<C-Up>"] = cmp.mapping.select_prev_item(cmp_select_opts),
    ["<C-Down>"] = cmp.mapping.select_next_item(cmp_select_opts),
    ["<CR>"] = cmp.mapping.confirm(),
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
    end, {"i", "s"}),
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
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
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  })
})

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
lspconfig["rust_analyzer"].setup({
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      check = { command = "clippy", },
    },
  },
})
