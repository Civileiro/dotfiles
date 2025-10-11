-- lsp/lspconfig.lua

local capabilities = require("blink.cmp").get_lsp_capabilities()

capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

vim.lsp.config("*", {
  capabilities = capabilities,
})

-- LUA
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT", },
      diagnostics = { globals = { "vim" }, },
      telemetry = { enable = false, },
    },
  },
})

-- PYTHON
vim.lsp.config("pyright", {
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
vim.lsp.config("ruff", {
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
})

-- C/C++
vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--clang-tidy",
  },
})

-- JAVA
vim.lsp.config("jdtls", {
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
vim.lsp.config("nil_ls", {
  settings = {
    ["nil"] = {
      formatting = { command = nix_format_cmd },
    },
  },
})

-- RUST
local check_cmd
if vim.fn.executable("clippy-driver") then
  check_cmd = "clippy"
else
  check_cmd = "check"
end
vim.lsp.config("rust-analyser", {
  server = {
    settings = {
      ["rust-analyzer"] = {
        check = { command = check_cmd, },
      },
    },
  }
})

-- JS
vim.lsp.config("ts_ls", {
})
vim.lsp.config("jsonls", {
  cmd = { "vscode-json-languageserver", "--stdio" },
})

-- WGSL
vim.lsp.config("wgsl_analyzer", {})

for lsp, _ in pairs(vim.lsp.config._configs) do
  if lsp ~= "*" then
    vim.lsp.enable(lsp)
  end
end
