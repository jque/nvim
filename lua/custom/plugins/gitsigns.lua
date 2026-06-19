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
}
