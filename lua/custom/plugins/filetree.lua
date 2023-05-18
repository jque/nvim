-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
  },
  config = function()
    require('nvim-tree').setup {
      view = {
        width = 40,
      },
      renderer = {
        group_empty = false,
      },
      filters = {
        dotfiles = true,
      },
    }

    vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<CR>', { desc = "[T]ree toogle" })
  end,
}
