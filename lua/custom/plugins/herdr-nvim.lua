-- herdr-nvim: code annotations you send to the agent in your herdr workspace.
-- Plugin installed in custom/package.lua. The herdr half (sidebar + file
-- picker) is installed with `herdr plugin install ChmaraX/herdr-nvim` and
-- bound in ~/.config/herdr/config.toml (prefix+n sidebar, prefix+f picker).
--
-- The plugin's default prefix is <leader>a, which used to collide with sidekick
-- (<leader>as = "select CLI" there vs "send comments" here). We disable its
-- keymaps (sidekick is disabled now) and bind our own under <leader>a, mirroring the
-- sidekick layout: <leader>a + t/v/s for this/visual/send.
local herdr = require 'herdr-nvim'

herdr.setup {
  keymaps = false,
  clear_after_send = true, -- comments are ephemeral: cleared once sent
}

local map = vim.keymap.set

-- plain comment: current line in normal mode, selection in visual mode
map('n', '<leader>ac', herdr.comment_line, { desc = 'Herdr - comment line' })
map('x', '<leader>ac', herdr.comment_selection, { desc = 'Herdr - comment selection' })

-- visual selection only (mirrors sidekick <leader>av)
map('x', '<leader>av', herdr.comment_selection, { desc = 'Herdr - comment Visual selection' })

-- list pending comments (float): hover to jump, <CR> edit, d delete
map('n', '<leader>al', herdr.list_comments, { desc = 'Herdr - List comments' })

-- send: paste into the agent input (like sidekick send), or submit right away
map('n', '<leader>as', function()
  herdr.send_all { submit = false }
end, { desc = 'Herdr - Send comments to agent (paste)' })
map('n', '<leader>aS', function()
  herdr.send_all { submit = true }
end, { desc = 'Herdr - Send and submit comments to agent' })

-- <leader>at mirrors sidekick <leader>at ("send this"): comment + send in one go.
-- Prompts for the text, adds the annotation and sends everything pending to the
-- agent right away (cancelling the prompt does nothing). `submit` decides whether
-- the agent runs it (ht) or it just lands in its input for you to finish (hT).
-- Same internals as herdr.comment_range, plus send_all on the callback.
local function comment_and_send(start_line, end_line, submit)
  local bufnr = vim.api.nvim_get_current_buf()
  require('herdr-nvim.ui').input_comment(function(text)
    local id = require('herdr-nvim.comments').add(bufnr, start_line, end_line, text)
    require('herdr-nvim.ui').decorate(id)
    herdr.send_all { submit = submit }
  end)
end

-- "this" = the visual selection when there is one, else the cursor line
local function send_this(submit)
  return function()
    local in_visual = vim.fn.mode():match '^[vV\22]' ~= nil
    if in_visual then
      vim.cmd [[execute "normal! \<esc>"]] -- materialize the visual marks
      local s, e = require('herdr-nvim.ui').visual_range()
      comment_and_send(s, e, submit)
    else
      local l = vim.api.nvim_win_get_cursor(0)[1]
      comment_and_send(l, l, submit)
    end
  end
end
map({ 'n', 'x' }, '<leader>at', send_this(true), { desc = 'Herdr - comment This (line or selection) and submit' })
map({ 'n', 'x' }, '<leader>aT', send_this(false), { desc = 'Herdr - comment This (line or selection), paste to agent without submitting' })
