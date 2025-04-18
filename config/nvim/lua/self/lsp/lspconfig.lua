-- lsp/lspconfig.lua

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")

capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

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
  settings = {
    pyright = {
      disableOrganizeImports = true, -- Using Ruff
    },
    python = {
      analysis = {
        ignore = { '*' },         -- Using Ruff
        typeCheckingMode = 'off', -- Using mypy
      },
    },
  },
})
lspconfig["ruff"].setup({
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
  local function get_project_rustanalyzer_settings()
    local handle = io.open(vim.fn.resolve(vim.fn.getcwd() .. '/./.rust-analyzer.json'))
    if not handle then
      return {}
    end
    local out = handle:read("*a")
    handle:close()
    local config = vim.json.decode(out)
    if type(config) == "table" then
      return config
    end
    return {}
  end


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
        ["rust-analyzer"] = vim.tbl_deep_extend(
          "force",
          {
            -- Defaults
            check = { command = check_cmd, },
          },
          -- Project config
          get_project_rustanalyzer_settings(),
          {
            -- Overrides
          }),
      },
    }
  })
end

-- HASKELL
local has_haskell, ht = pcall(require, "haskell-tools.internal")
if has_haskell then
  vim.api.nvim_create_autocmd("FileType", {
    desc = "haskell-tools config",
    group = vim.api.nvim_create_augroup("HaskellToolsConfig", {}),
    pattern = { "haskell", "lhaskell", "cabal", "cabalproject" },
    callback = function(event)
      ht.start_or_attach()
      local opts = { noremap = true, buffer = event.buf }
      vim.keymap.set("n", "<Leader>cr", vim.lsp.codelens.run, opts)
    end
  })
end


-- JS
lspconfig["ts_ls"].setup({
  capabilities = capabilities,
})
lspconfig["jsonls"].setup({
  capabilities = capabilities,
  cmd = { "vscode-json-languageserver", "--stdio" },
})
