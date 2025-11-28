--
-- example config
-- https://medium.com/@lysender/using-biome-with-neovim-and-conform-afcc0ea0524b
--
return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'never' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      local lsp_format_opt = 'never'
      return {
        timeout_ms = 500,
        lsp_format = lsp_format_opt,
      }
    end,
    formatters_by_ft = {
      go = { 'goimports', 'gofmt' },
      lua = { 'stylua' },
      rust = { 'rustfmt' },
      json = { 'prettier' },
      yaml = { 'prettier' },
      markdown = { 'prettier' },
      javascript = { 'biome', 'biome-organize-imports', 'eslint_d' },
      javascriptreact = { 'biome', 'biome-organize-imports', 'eslint_d' },
      typescript = { 'biome', 'biome-organize-imports', 'eslint_d' },
      typescriptreact = { 'biome', 'biome-organize-imports', 'eslint_d' },
    },
    formatters = {
      ['biome-organize-imports'] = {
        condition = function(ctx)
          local biome_root = vim.fs.find({ 'biome.json' }, { path = ctx.filename, upward = true })

          return biome_root[1] ~= nil
        end,
      },
      biome = {
        condition = function(ctx)
          local biome_root = vim.fs.find({ 'biome.json' }, { path = ctx.filename, upward = true })

          return biome_root[1] ~= nil
        end,
      },
      eslint_d = {
        condition = function(ctx)
          local eslint_root = vim.fs.find({
            '.eslintrc',
            '.eslintrc.js',
            '.eslintrc.cjs',
            '.eslintrc.json',
            '.eslintrc.yaml',
            '.eslintrc.yml',
            'eslint.config.js',
            'eslint.config.cjs',
            'eslint.config.mjs',
            'eslint.config.ts',
          }, { path = ctx.filename, upward = true })

          return eslint_root[1] ~= nil
        end,
      },
    },
  },
}
