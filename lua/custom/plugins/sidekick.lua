return {
  'folke/sidekick.nvim',
  opts = {
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
      },
    },
  },
  keys = {
    {
      '<tab>',
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not require('sidekick').nes_jump_or_apply() then
          return '<Tab>' -- fallback to normal tab
        end
      end,
      expr = true,
      desc = 'Goto/Apply Next Edit Suggestion',
    },
    {
      '<c-.>',
      function()
        require('sidekick.cli').toggle()
      end,
      desc = 'Sidekick Toggle',
      mode = { 'n', 't', 'i', 'x' },
    },
    {
      '<leader>aa',
      function()
        require('sidekick.cli').toggle()
      end,
      desc = 'Sidekick - toggle CLI',
    },
    {
      '<leader>as',
      function()
        require('sidekick.cli').select()
      end,
      -- Or to select only installed tools:
      -- require("sidekick.cli").select({ filter = { installed = true } })
      desc = 'Sidekick - select CLI',
    },
    {
      '<leader>ad',
      function()
        require('sidekick.cli').close()
      end,
      desc = 'Sidekick - detach CLI Session',
    },
    {
      '<leader>at',
      function()
        require('sidekick.cli').send { msg = '{this}' }
      end,
      mode = { 'x', 'n' },
      desc = 'Sidekick - send This',
    },
    {
      '<leader>af',
      function()
        require('sidekick.cli').send { msg = '{file}' }
      end,
      desc = 'Sidekick - send File',
    },
    {
      '<leader>av',
      function()
        require('sidekick.cli').send { msg = '{selection}' }
      end,
      mode = { 'x' },
      desc = 'Sidekick - send Visual Selection',
    },
    {
      '<leader>ap',
      function()
        require('sidekick.cli').prompt()
      end,
      mode = { 'n', 'x' },
      desc = 'Sidekick - select Prompt',
    },
    {
      '<leader>aq',
      function()
        vim.ui.input({ prompt = 'Ask: ' }, function(input)
          if input and input ~= '' then
            require('sidekick.cli').send { msg = input }
          end
        end)
      end,
      mode = { 'n', 'x' },
      desc = 'Sidekick - Ask question',
    },
    {
      '<leader>ar',
      function()
        require('sidekick.cli').focus()
      end,
      desc = 'Sidekick - focus CLI',
    },
    {
      '<C-h>',
      '<C-\\><C-n><C-w>h',
      mode = 't',
      desc = 'Window: move left (from terminal)',
    },
    {
      '<C-j>',
      '<C-\\><C-n><C-w>j',
      mode = 't',
      desc = 'Window: move down (from terminal)',
    },
    {
      '<C-k>',
      '<C-\\><C-n><C-w>k',
      mode = 't',
      desc = 'Window: move up (from terminal)',
    },
    {
      '<C-l>',
      '<C-\\><C-n><C-w>l',
      mode = 't',
      desc = 'Window: move right (from terminal)',
    },
  },
}
