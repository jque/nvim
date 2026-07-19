-- File explorer. Plugin (+ nvim-web-devicons) installed in custom/package.lua.

-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

-- <C-k> is reserved for window/herdr navigation (see plugins/smart-splits.lua);
-- nvim-tree binds it to "file info" by default, so rebind that to `gi`.
local function on_attach(bufnr)
  local api = require('nvim-tree.api')
  api.config.mappings.default_on_attach(bufnr)
  vim.keymap.del('n', '<C-k>', { buffer = bufnr })
  vim.keymap.set('n', 'gi', api.node.show_info_popup, { buffer = bufnr, desc = 'nvim-tree: Info' })
end

require('nvim-tree').setup {
  on_attach = on_attach,
  view = {
    width = 60,
    side = "right",
  },
  renderer = {
    group_empty = false,
  },
  filters = {
    dotfiles = true,
  },
  update_focused_file = {
    enable = true,
    update_root = true,
  },
}

vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<CR>', { desc = "[T]ree toogle" })
