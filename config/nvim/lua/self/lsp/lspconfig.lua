-- lsp/lspconfig.lua

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")

-- LUA
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

-- PYTHON
lspconfig["pyright"].setup({
  capabilities = capabilities,
})
lspconfig["ruff_lsp"].setup({
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
  capabilities = capabilities,
})

-- C/C++
lspconfig["clangd"].setup({
  capabilities = capabilities,
  cmd = {
    "clangd",
    "--clang-tidy",
  },
})

-- JAVA
lspconfig["jdtls"].setup({
  capabilities = capabilities,
  -- nix calls it "jdt-language-server" instead of "jdtls"
  cmd = {
    "jdt-language-server",
    "-configuration", "/home/user/.cache/jdtls/config",
    "-data", "/home/user/.cache/jdtls/workspace"
  },
})

-- NIX
local nix_format_cmd
if vim.fn.executable("nixfmt") then
  nix_format_cmd = { "nixfmt" }
else
  nix_format_cmd = nil
end
lspconfig["nil_ls"].setup({
  capabilities = capabilities,
  settings = {
    ["nil"] = {
      formatting = { command = nix_format_cmd },
    },
  },
})

-- RUST
local has_rust, rt = pcall(require, "rust-tools")
if has_rust then
  local check_cmd
  if vim.fn.executable("clippy-driver") then
    check_cmd = "clippy"
  else
    check_cmd = "check"
  end
  rt.setup({
    server = {
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          check = { command = check_cmd, },
        },
      },
    }
  })
end
