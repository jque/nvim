-- statusline plugin
-- See `:help lualine.txt`. Plugin (+ nvim-web-devicons) installed in custom/package.lua.
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'auto', -- follows the colorscheme set in custom/themes/init.lua
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_b = { 'branch' },
    lualine_c = {
      'diff',
      'diagnostics',
      {
        'filename',
        file_status = true,     -- Displays file status (readonly status, modified status)
        newfile_status = false, -- Display new file status (new file means no write after created)
        path = 1,               -- 0: Just the filename
        -- 1: Relative path
        -- 2: Absolute path
        -- 3: Absolute path, with tilde as the home directory
      },
    },
    lualine_x = {
      -- herdr-nvim pending annotations (empty when there are none)
      function()
        local ok, herdr = pcall(require, 'herdr-nvim')
        return ok and herdr.statusline() or ''
      end,
      'encoding',
      'fileformat',
      'filetype',
    },
  },
}
