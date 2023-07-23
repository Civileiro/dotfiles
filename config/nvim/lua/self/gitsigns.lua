-- gitsigns.lua
local gs = require("gitsigns")
gs.setup({
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
  },
  current_line_blame_opts = {
    delay = 300,
  },
  on_attach = function(bufnr)
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map('n', ']h', function()
      if vim.wo.diff then return ']h' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr=true, desc = "Next [H]unk" })

    map('n', '[h', function()
      if vim.wo.diff then return '[h' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr=true, desc = "Previous [H]unk" })

    map("n", "<Leader>hs", gs.stage_hunk, { desc = "[H]unk [S]tage" })
    map('n', '<Leader>hr', gs.reset_hunk, { desc = "[H]unk [R]eset" })
    map('v', '<Leader>hs', function()
      gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') }
    end, { desc = "[H]unk [S]tage" })
    map('v', '<Leader>hr', function()
      gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') }
    end, { desc = "[H]unk [R]eset" })
    map('n', '<Leader>hS', gs.stage_buffer, { desc = "[H]unk [S]tage all" })
    map('n', '<Leader>hu', gs.undo_stage_hunk, { desc = "[H]unk [U]ndo stage" })
    map('n', '<Leader>hR', gs.reset_buffer, { desc = "[H]unk [R]eset all" })
    map('n', '<Leader>hp', gs.preview_hunk, { desc = "[H]unk [P]review" })
    map('n', '<Leader>hb', function()
      gs.blame_line{ full=true }
    end, { desc = "[H]? [B]lame" })
    map('n', '<Leader>tb', gs.toggle_current_line_blame, {
      desc = "[T]oggle [B]lame",
    })
    map('n', '<Leader>hd', gs.diffthis, { desc = "[H]unk [D]iff" })
    map('n', '<Leader>hD', function()
      gs.diffthis('~')
    end, { desc = "[H]unk [D]iff editable" })
    map('n', '<Leader>td', gs.toggle_deleted, { desc = "[T]oggle [D]eleted" })
  end
})

