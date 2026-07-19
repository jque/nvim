-- Directional window navigation + resize. Plugins installed in custom/package.lua.
-- Inside herdr, herdr-splits.nvim provides the primitives so the same keys also
-- cross herdr panes (nvim delegates to herdr at edges, herdr forwards keys into
-- nvim); outside herdr, smart-splits.nvim covers plain nvim splits. Both expose
-- the same move_cursor_*/resize_* API. hydra wraps resize in a sticky mode,
-- mirroring herdr's prefix+r resize mode.
local in_herdr = vim.env.HERDR_ENV == '1'
local splits = in_herdr and require('herdr-splits') or require('smart-splits')

-- herdr-splits option: nvim resize step in cells (herdr side uses its ratio default)
splits.setup(in_herdr and { neovim_amount = 3 } or {})

-- Window navigation (replaces the raw <C-w>hjkl maps that lived in remap.lua).
vim.keymap.set('n', '<C-h>', splits.move_cursor_left, { desc = 'Move to left window' })
vim.keymap.set('n', '<C-j>', splits.move_cursor_down, { desc = 'Move to lower window' })
vim.keymap.set('n', '<C-k>', splits.move_cursor_up, { desc = 'Move to upper window' })
vim.keymap.set('n', '<C-l>', splits.move_cursor_right, { desc = 'Move to right window' })

-- Same navigation from terminal buffers (sidekick agent, :term): leave terminal
-- mode first so edge delegation to herdr also works from there.
local function term_move(move)
  return function()
    vim.cmd.stopinsert()
    move()
  end
end
vim.keymap.set('t', '<C-h>', term_move(splits.move_cursor_left), { desc = 'Window: move left (from terminal)' })
vim.keymap.set('t', '<C-j>', term_move(splits.move_cursor_down), { desc = 'Window: move down (from terminal)' })
vim.keymap.set('t', '<C-k>', term_move(splits.move_cursor_up), { desc = 'Window: move up (from terminal)' })
vim.keymap.set('t', '<C-l>', term_move(splits.move_cursor_right), { desc = 'Window: move right (from terminal)' })

-- Resize mode: <C-w>r enters, h/j/k/l resize until Esc/q.
-- Note: this shadows the native <C-w>r (rotate windows).
-- Inside herdr the no-arg calls use herdr-splits defaults, which also resize
-- the herdr pane when the nvim window fills the terminal in that dimension.
local function resize(dir, amount)
  return function()
    splits['resize_' .. dir](in_herdr and nil or amount)
  end
end
require('hydra') {
  name = 'Resize',
  mode = 'n',
  body = '<C-w>r',
  hint = ' Resize: _h_ ← · _j_ ↓ · _k_ ↑ · _l_ → · _=_ equalize · _<Esc>_/_q_ exit ',
  config = {
    hint = { type = 'window', position = 'bottom' },
  },
  heads = {
    { 'h', resize('left', 3) },
    { 'j', resize('down', 2) },
    { 'k', resize('up', 2) },
    { 'l', resize('right', 3) },
    { '=', '<C-w>=', { desc = 'equalize' } },
    { '<Esc>', nil, { exit = true, desc = false } },
    { 'q', nil, { exit = true, desc = false } },
  },
}
