-- Fuzzy Finder (files, lsp, etc)
-- See `:help telescope` and `:help telescope.setup()
return {
  'nvim-telescope/telescope.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      -- NOTE: If you are having trouble with this installation,
      --       refer to the README for telescope-fzf-native for more instructions.
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    }
  },
  config = function()
    local previewers = require 'telescope.previewers'

    -- delta-powered previewers for git pickers: syntax highlighting,
    -- word-level diff and line numbers inside the floating preview.
    -- Colors tuned to the tokyonight-night palette so the diff blends with
    -- the editor instead of using delta's default saturated red/green.
    local delta_args = {
      '-c', 'core.pager=delta',
      '-c', 'delta.paging=never',
      '-c', 'delta.navigate=false',
      '-c', 'delta.line-numbers=true',
      '-c', 'delta.true-color=always',
      '-c', 'delta.syntax-theme=tokyonight_night',
      '-c', 'delta.minus-style=syntax #37222c',
      '-c', 'delta.minus-emph-style=syntax #713137',
      '-c', 'delta.plus-style=syntax #20303b',
      '-c', 'delta.plus-emph-style=syntax #2c5a66',
      '-c', 'delta.zero-style=syntax',
      '-c', 'delta.line-numbers-minus-style=#f7768e',
      '-c', 'delta.line-numbers-plus-style=#9ece6a',
      '-c', 'delta.line-numbers-zero-style=#3b4261',
      '-c', 'delta.line-numbers-left-style=#3b4261',
      '-c', 'delta.line-numbers-right-style=#3b4261',
      '-c', 'delta.file-style=#7aa2f7 bold',
      '-c', 'delta.file-decoration-style=#3b4261 ul',
      '-c', 'delta.hunk-header-style=file line-number syntax',
      '-c', 'delta.hunk-header-decoration-style=#3b4261 ul',
      '-c', 'delta.hunk-header-line-number-style=#737aa2',
    }

    -- Run git from the entry's directory so it resolves inside the repo
    -- regardless of Neovim's cwd, and use absolute paths as pathspecs.
    local function git_cmd(dir, extra)
      local cmd = { 'git', '-C', dir }
      vim.list_extend(cmd, delta_args)
      vim.list_extend(cmd, extra)
      return cmd
    end

    -- git_status: show the diff for the selected file (handles untracked files)
    local delta_status = previewers.new_termopen_previewer {
      get_command = function(entry)
        local path = entry.path
        local dir = vim.fn.fnamemodify(path, ':h')
        if entry.status == '??' or entry.status:sub(1, 1) == 'A' then
          return git_cmd(dir, { 'diff', '--no-index', '--', '/dev/null', path })
        end
        return git_cmd(dir, { 'diff', 'HEAD', '--', path })
      end,
    }

    -- git_commits / git_bcommits: show the full commit diff
    local delta_commits = previewers.new_termopen_previewer {
      get_command = function(entry)
        return git_cmd(vim.uv.cwd(), { 'show', '--stat', '--format=fuller', entry.value })
      end,
    }

    require('telescope').setup {
      defaults = {
        mappings = {
          i = {
                ['<C-u>'] = false,
                ['<C-d>'] = false,
          },
        },
      },
      pickers = {
        git_status = { previewer = delta_status },
        git_commits = { previewer = delta_commits },
        git_bcommits = { previewer = delta_commits },
      },
    }

    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'file_browser')
    pcall(require('telescope').load_extension, 'ui-select')

    -- See `:help telescope.builtin`
    vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 90,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    vim.keymap.set('n', '<leader>sf', require('telescope.builtin').git_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sb', require('telescope.builtin').buffers, { desc = '[S]earch [B]buffers' })
    vim.keymap.set('n', '<leader>sc', require('telescope.builtin').git_status, { desc = '[S]earch [C]changes' })
    vim.keymap.set('n', '<leader>sk', require('telescope.builtin').keymaps, { desc = '[S]earch [k]eymaps' })
    vim.keymap.set('n', '<leader>sj', require('telescope.builtin').jumplist, { desc = '[S]earch [J]umplist' })
    vim.keymap.set('n', '<leader>se', require('telescope.builtin').diagnostics, { desc = '[S]earch [E]errors' })
    vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]resume' })
  end,
}
