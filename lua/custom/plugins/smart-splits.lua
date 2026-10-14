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

-- herdr-nvim sidebar: the pane runs a thin `nvim --remote-ui` client attached to
-- a per-tab headless daemon (where this config runs). The daemon inherits
-- HERDR_PANE_ID from whichever pane spawned it first and outlives toggles, so
-- herdr-splits ends up calling `herdr pane ... --current` with a dead pane id
-- and edge delegation silently fails. On every UI attach, find the pane whose
-- foreground process is the remote-ui client of *this* server and adopt its id.
-- No-op for a regular nvim (no pane matches its servername).
if in_herdr then
  local function adopt_sidebar_pane_id()
    local herdr = vim.env.HERDR_BIN_PATH or 'herdr'
    local server = vim.v.servername
    local tab = vim.env.HERDR_TAB_ID
    if not server or server == '' or not tab then
      return
    end
    -- vim.system callbacks run in a fast context (no vim.env / vimscript
    -- there), so every callback defers its real work with vim.schedule.
    local function decoded(out)
      local ok, data = pcall(vim.json.decode, out.stdout or '')
      return ok and type(data) == 'table' and data.result or nil
    end
    vim.system({ herdr, 'pane', 'list' }, { text = true }, function(list)
      vim.schedule(function()
        local result = decoded(list)
        for _, pane in ipairs(result and result.panes or {}) do
          if pane.tab_id == tab and pane.label == 'nvim sidebar' then
            vim.system({ herdr, 'pane', 'process-info', '--pane', pane.pane_id }, { text = true }, function(info)
              vim.schedule(function()
                local iresult = decoded(info)
                local procs = iresult and iresult.process_info and iresult.process_info.foreground_processes or {}
                for _, proc in ipairs(procs) do
                  if (proc.cmdline or ''):find(server, 1, true) then
                    vim.env.HERDR_PANE_ID = pane.pane_id
                    return
                  end
                end
              end)
            end)
          end
        end
      end)
    end)
  end
  vim.api.nvim_create_autocmd('UIEnter', {
    group = vim.api.nvim_create_augroup('custom_herdr_sidebar_pane', { clear = true }),
    callback = adopt_sidebar_pane_id,
  })
end

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
