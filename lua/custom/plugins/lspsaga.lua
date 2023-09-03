return {
  'nvimdev/lspsaga.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter', -- optional
    'nvim-tree/nvim-web-devicons'      -- optional
  },
  config = function()
    require('lspsaga').setup({
      symbol_in_winbar = {
        enable = false
      },
    })

    vim.keymap.set('n', '<leader>E', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', { desc = "Go to previous diagnostic message" })
    vim.keymap.set('n', '<leader>e', '<Cmd>Lspsaga diagnostic_jump_next<CR>', { desc = "Go to next diagnostic message" })
  end,
}
