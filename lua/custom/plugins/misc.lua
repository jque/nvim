-- Small setup-only plugins. (Plugins are installed in custom/package.lua via vim.pack.)
-- Commenting ("gc"/"gcc") is built into Neovim >= 0.10, so no plugin is needed.

-- Shows pending keybinds; group labels so <leader> popups read nicely.
local wk = require('which-key')
wk.setup {
  -- every herdr-nvim map is described "Herdr - ...": give them the bot icon
  -- sidekick used to register for <leader>a
  icons = { rules = { { pattern = 'herdr', icon = '󰚩 ', color = 'green' } } },
}
wk.add {
  { '<leader>a', group = 'herdr (agent comments)', icon = { icon = '󰚩 ', color = 'green' } }, -- sidekick disabled
  { '<leader>d', group = 'diagnostics' },
  { '<leader>g', group = 'git hunks (gitsigns)' },
  { '<leader>l', group = 'lsp' },
  { '<leader>lw', group = 'lsp workspace folders' },
  { '<leader>m', group = 'markdown' },
  { '<leader>s', group = 'search (telescope)' },
}
