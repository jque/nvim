-- statusline plugin
-- See `:help lualine.txt`
return {
  'nvim-lualine/lualine.nvim',
  opts = {
    options = {
      icons_enabled = false,
      theme = 'tokyonight',
      component_separators = '|',
      section_separators = '',
    },
    sections = {
      lualine_b = {'branch'},
      lualine_c = {
        'diff',
        'diagnostics',
        {
          'filename',
          file_status = true,      -- Displays file status (readonly status, modified status)
          newfile_status = false,  -- Display new file status (new file means no write after created)
          path = 1,                -- 0: Just the filename
          -- 1: Relative path
          -- 2: Absolute path
          -- 3: Absolute path, with tilde as the home directory
        }
      }
    }
  },
}
