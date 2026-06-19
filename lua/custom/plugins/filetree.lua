-- File explorer. Plugin (+ nvim-web-devicons) installed in custom/package.lua.

-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

require('nvim-tree').setup {
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
