-- Adds git related signs to the gutter, as well as utilities for managing changes
-- See `:help gitsigns.txt`. Plugin installed in custom/package.lua.
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  on_attach = function(bufnr)
    local gs = require('gitsigns')
    local map = function(mode, keys, func, desc)
      vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'Git: ' .. desc })
    end

    -- ]c / [c: next/prev hunk. In diff mode (:diffthis, vimdiff) keep the
    -- built-in ]c/[c that jumps between diff changes.
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gs.nav_hunk('next')
      end
    end, 'next hunk')
    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gs.nav_hunk('prev')
      end
    end, 'prev hunk')

    -- <leader>g: [g]it group (see which-key groups in plugins/misc.lua)
    map('n', '<leader>gp', gs.preview_hunk, '[P]review hunk (diff of the change under cursor)')
    map('n', '<leader>gd', gs.diffthis, '[D]iff this file vs index')
    map('n', '<leader>gt', gs.toggle_deleted, '[T]oggle deleted lines')
    map('n', '<leader>gj', function() gs.nav_hunk('next') end, 'next hunk ([j] down)')
    map('n', '<leader>gk', function() gs.nav_hunk('prev') end, 'prev hunk ([k] up)')
  end,
}
