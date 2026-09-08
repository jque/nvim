-- Translate/fix comment drafts with a local ollama model (offline).
--
-- In guh.nvim comment/review draft buffers (`cc`, `cr` reply, `cC`, `cR`):
--   <C-t>  normal mode: rewrite the whole draft; visual mode: only the selection
-- Anywhere else: :[range]Translate (no range = whole buffer).
--
-- Config in vim.g.ollama_translate (all keys optional):
--   url     ollama server, default http://127.0.0.1:11434
--   model   default 'translategemma:4b'
--   prompt  %s-template wrapped around the text

local defaults = {
  url = 'http://127.0.0.1:11434',
  model = 'translategemma:4b',
  prompt = 'Translate the following text from Spanish into English. '
    .. 'If it is already in English, only fix grammar and spelling. '
    .. 'Keep markdown formatting, code and technical identifiers unchanged. '
    .. 'Reply with the resulting text only.\n\n%s',
}

local busy = false

local function rewrite(buf, line1, line2)
  if busy then
    return vim.notify('Translate: request already in flight', vim.log.levels.WARN)
  end
  local cfg = vim.tbl_extend('force', defaults, vim.g.ollama_translate or {})
  local text = table.concat(vim.api.nvim_buf_get_lines(buf, line1 - 1, line2, false), '\n')
  if vim.trim(text) == '' then
    return vim.notify('Translate: nothing to translate', vim.log.levels.WARN)
  end
  local body = vim.json.encode({
    model = cfg.model,
    prompt = cfg.prompt:format(text),
    stream = false,
    options = { temperature = 0 },
  })
  busy = true
  vim.notify(('Translate: asking %s…'):format(cfg.model))
  vim.system(
    { 'curl', '-sS', '--max-time', '120', '-X', 'POST', cfg.url .. '/api/generate', '-d', body },
    { text = true },
    vim.schedule_wrap(function(r)
      busy = false
      if r.code ~= 0 then
        local err = vim.trim(r.stderr or '')
        return vim.notify(
          ('Translate: curl failed (%s) — is `ollama serve` running?'):format(err),
          vim.log.levels.ERROR
        )
      end
      local ok, resp = pcall(vim.json.decode, r.stdout)
      if not ok or type(resp) ~= 'table' or type(resp.response) ~= 'string' then
        local err = ok and type(resp) == 'table' and resp.error or 'unexpected response from ollama'
        return vim.notify('Translate: ' .. err, vim.log.levels.ERROR)
      end
      if not (vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].modifiable) then
        return vim.notify('Translate: draft buffer is gone', vim.log.levels.WARN)
      end
      vim.api.nvim_buf_set_lines(buf, line1 - 1, line2, false, vim.split(vim.trim(resp.response), '\n'))
      vim.notify('Translate: done')
    end)
  )
end

vim.api.nvim_create_user_command('Translate', function(a)
  rewrite(vim.api.nvim_get_current_buf(), a.line1, a.line2)
end, { range = '%', desc = 'Translate/fix [range] with local ollama' })

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('custom-ollama-translate', {}),
  pattern = 'markdown',
  desc = '<C-t> translates guh comment/review drafts',
  callback = function(ev)
    local name = vim.api.nvim_buf_get_name(ev.buf)
    if not (name:match('^guh://.+/comment/') or name:match('^guh://.+/review/')) then
      return
    end
    vim.keymap.set('n', '<C-t>', '<Cmd>Translate<CR>', { buffer = ev.buf, desc = 'Translate draft (ollama)' })
    vim.keymap.set('x', '<C-t>', ':Translate<CR>', { buffer = ev.buf, desc = 'Translate selection (ollama)' })
  end,
})
