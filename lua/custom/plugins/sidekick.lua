-- Sidekick (AI/copilot helper). Plugin installed in custom/package.lua.
-- NOTE: under lazy.nvim this was lazy-loaded via `keys`. vim.pack has no
-- lazy-loading, so we set up eagerly and define the keymaps directly.
require('sidekick').setup {
  copilot = {
    enabled = true,
  },
  cli = {
    win = {
      layout = 'left', -- lateral derecha
      split = {
        width = 100, -- ancho de la ventana lateral
        height = 20, -- altura si el layout fuese horizontal
      },
      keys = {
        -- defaults: <c-p> prompt picker, <c-b> buffer picker, <c-f> file picker
        -- navegación de ventanas: la llevan los t-maps globales de smart-splits.lua
        -- (herdr-aware); los nav_* de sidekick harían wincmd a secas
        nav_left = false,
        nav_down = false,
        nav_up = false,
        nav_right = false,
      },
    },
  },
}

local map = vim.keymap.set

map('n', '<tab>', function()
  -- if there is a next edit, jump to it, otherwise apply it if any
  if not require('sidekick').nes_jump_or_apply() then
    return '<Tab>' -- fallback to normal tab
  end
end, { expr = true, desc = 'Goto/Apply Next Edit Suggestion' })

map({ 'n', 't', 'i', 'x' }, '<c-.>', function()
  require('sidekick.cli').toggle()
end, { desc = 'Sidekick Toggle' })

map('n', '<leader>aa', function()
  require('sidekick.cli').toggle()
end, { desc = 'Sidekick - toggle CLI' })

map('n', '<leader>as', function()
  require('sidekick.cli').select()
end, { desc = 'Sidekick - select CLI' })

map('n', '<leader>ad', function()
  require('sidekick.cli').close()
end, { desc = 'Sidekick - detach CLI Session' })

map({ 'x', 'n' }, '<leader>at', function()
  require('sidekick.cli').send { msg = '{this}' }
end, { desc = 'Sidekick - send This' })

map('n', '<leader>af', function()
  require('sidekick.cli').send { msg = '{file}' }
end, { desc = 'Sidekick - send File' })

map('x', '<leader>av', function()
  require('sidekick.cli').send { msg = '{selection}' }
end, { desc = 'Sidekick - send Visual Selection' })

map({ 'n', 'x' }, '<leader>ap', function()
  require('sidekick.cli').prompt()
end, { desc = 'Sidekick - select Prompt' })

map({ 'n', 'x' }, '<leader>aq', function()
  vim.ui.input({ prompt = 'Ask: ' }, function(input)
    if input and input ~= '' then
      require('sidekick.cli').send { msg = input }
    end
  end)
end, { desc = 'Sidekick - Ask question' })

map('n', '<leader>ar', function()
  require('sidekick.cli').focus()
end, { desc = 'Sidekick - focus CLI' })

-- Terminal-mode <C-hjkl> window navigation lives in custom/plugins/smart-splits.lua
-- (herdr-aware: delegates to herdr panes at edges).
