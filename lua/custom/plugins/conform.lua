-- Formatter (conform.nvim). Plugin installed in custom/package.lua.
-- https://medium.com/@lysender/using-biome-with-neovim-and-conform-afcc0ea0524b
--
-- NOTE: under lazy.nvim this was lazy-loaded on BufWritePre / ConformInfo /
-- <leader>f. vim.pack has no lazy-loading, so we set up eagerly; format_on_save
-- still registers its own BufWritePre autocmd via setup().
require('conform').setup {
  notify_on_error = false,
  format_on_save = {
    timeout_ms = 500,
    lsp_format = 'never',
  },
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
        local biome_root = vim.fs.find({ 'biome.json', 'biome.jsonc' }, { path = ctx.filename, upward = true })

        return biome_root[1] ~= nil
      end,
    },
    biome = {
      condition = function(ctx)
        local biome_root = vim.fs.find({ 'biome.json', 'biome.jsonc' }, { path = ctx.filename, upward = true })

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
}

vim.keymap.set('', '<leader>f', function()
  require('conform').format { async = true, lsp_format = 'never' }
end, { desc = '[F]ormat buffer' })
