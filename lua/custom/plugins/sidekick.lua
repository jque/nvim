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

-- herdr ⇄ nvim agent bridge (see ~/.config/herdr/docs/nvim-agent-bridge.md).
-- Inside a herdr pane, report the agent as soon as its terminal opens and
-- release it when the terminal closes. Codex only fires its SessionStart hook
-- on the first prompt, and opencode has no shell hooks at all, so without this
-- they would show up late or stay listed after exiting. The script ignores
-- agents it does not know, so plain shells and other tools are harmless.
if vim.env.HERDR_ENV == '1' then
  local group = vim.api.nvim_create_augroup('herdr_nvim_agent_bridge', { clear = true })
  local script = vim.fn.expand('~/.config/herdr/hooks/herdr-nvim-agent-state.sh')

  local function report(action)
    return function(ev)
      local tool = vim.b[ev.buf].sidekick_cli
      local agent = tool and tool.name
      if agent == nil then
        -- plain :term <agent>: buffer name is term://<cwd>//<pid>:<cmd>
        agent = vim.api.nvim_buf_get_name(ev.buf):match('//%d+:(%S+)')
        if agent then
          agent = vim.fn.fnamemodify(agent, ':t')
        end
      end
      if agent == nil then
        return
      end
      vim.system({ script, agent, action }, { env = { NVIM = vim.v.servername }, stdin = false })
    end
  end

  vim.api.nvim_create_autocmd('TermOpen', { group = group, callback = report 'session' })
  vim.api.nvim_create_autocmd('TermClose', { group = group, callback = report 'end' })
end
