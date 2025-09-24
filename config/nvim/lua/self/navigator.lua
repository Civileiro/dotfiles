-- navigator.lua

vim.g.tmux_navigator_no_mappings = 1
vim.g.kitty_navigator_no_mappings = 1

local prefix
if vim.env.TERM == "xterm-kitty" then
  prefix = "Kitty"
elseif vim.env.TMUX then
  prefix = "Tmux"
end

if prefix ~= nil then
  vim.keymap.set({ "n", "t" }, "<C-Up>", "<Cmd>" .. prefix .. "NavigateUp<CR>")
  vim.keymap.set({ "n", "t" }, "<C-Down>", "<Cmd>" .. prefix .. "NavigateDown<CR>")
  vim.keymap.set({ "n", "t" }, "<C-Left>", "<Cmd>" .. prefix .. "NavigateLeft<CR>")
  vim.keymap.set({ "n", "t" }, "<C-Right>", "<Cmd>" .. prefix .. "NavigateRight<CR>")
end
