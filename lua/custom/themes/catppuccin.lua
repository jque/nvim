return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,    -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    vim.cmd([[colorscheme catppuccin]])

    require('catppuccin').setup({
      -- flavour = "macchiato", -- latte, frappe, macchiato, mocha
      -- color_overrides = {
      --   latte = {
      --     base = "#ff0000",
      --     mantle = "#242424",
      --     crust = "#474747",
      --   },
      --   frappe = {},
      --   macchiato = {},
      --   mocha = {},
      -- }
    })
  end,
}
