-- lsp/blink.lua
require("blink.cmp").setup({
  keymap = {
    preset = "enter",
    ["<C-Up>"] = { "select_prev", "fallback" },
    ["<Up>"] = { "fallback" },
    ["<C-Down>"] = { "select_next", "fallback" },
    ["<Down>"] = { "fallback" },
    ["<PageUp>"] = { "scroll_documentation_up", "fallback" },
    ["<PageDown>"] = { "scroll_documentation_down", "fallback" },
    ['<Tab>'] = {
      function(cmp)
        if cmp.snippet_active() then
          return cmp.accept()
        else
          return cmp.select_and_accept()
        end
      end,
      'snippet_forward',
      'fallback'
    },
    ["<S-Tab>"] = { "snippet_backward" },
  },
  completion = {
    menu = { auto_show = true },
    documentation = { auto_show = true },
    list = { selection = { preselect = true, auto_insert = false, } },
  },
  snippets = { preset = "luasnip" },
  signature = { enabled = true },
  cmdline = {
    enabled = true,
    completion = {
      menu = { auto_show = true },
      list = { selection = { preselect = false, auto_insert = false, } },
    },
    keymap = { preset = "inherit" },
    sources = function()
      local type = vim.fn.getcmdtype()
      -- Search forward and backward
      if type == '/' or type == '?' then return { 'buffer' } end
      -- Commands
      if type == ':' or type == '@' then return { 'cmdline' } end
      return {}
    end,
  },
})
