-- A tree like view for symbols in Neovim using the Language Server Protocol 
return {
  'ThePrimeagen/harpoon',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    local telescope = require("telescope")
    local harpoon = require("harpoon")
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")

    harpoon.setup({
      menu = {
        width = vim.api.nvim_win_get_width(0) - 100,
      },
      global_settings = {
        mark_branch = true;
      }
    })

    vim.keymap.set("n", "<leader>ha", mark.add_file, { desc = '[H]arpoon [A]dd file' })
    vim.keymap.set("n", "<leader>hm", ui.toggle_quick_menu, { desc = '[H]arpoon [M]enu' })
    vim.keymap.set("n", "<leader>hp", ui.nav_prev, { desc = '[H]arpoon nav [P]rev' })
    vim.keymap.set("n", "<leader>hn", ui.nav_next, { desc = '[H]arpoon nav [N]ext' })
    vim.keymap.set('n', '<leader><space>', ui.toggle_quick_menu)

    telescope.load_extension('harpoon')
    vim.keymap.set("n", "<leader>sm", ":Telescope harpoon marks<CR>", { desc = '[S]earch [M]arks' })
  end,
}
