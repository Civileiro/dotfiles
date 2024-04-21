-- enable faster experimental loader
vim.loader.enable()

-- optimize `runtimepath` when running from Nix
for _, dir in ipairs(vim.opt.runtimepath:get()) do
  if vim.endswith(dir, "vim-pack-dir") then
    local config_home = vim.fn.stdpath("config")
    vim.opt.runtimepath = {
      config_home,
      dir,
      vim.env.VIMRUNTIME,
      config_home .. "/after",
    }
    vim.opt.packpath = {
      dir,
      vim.env.VIMRUNTIME,
    }
    break
  end
end

require("settings")
require("self")
