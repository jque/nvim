return {
  'stevearc/conform.nvim',
  opts = {
    format_on_save = function(bufnr)
      local disable_filetypes = { c = true, cpp = true }

      if disable_filetypes[vim.bo[bufnr].filetype] then
        return
      end

      return {
        timeout_ms = 3000,
        lsp_fallback = true,
        -- stop_after_first = true,
      }
    end,
    formatters_by_ft = {
      javascript = { 'eslint_d', 'prettier' },
      javascriptreact = { 'eslint_d', 'prettier' },
      typescript = { 'eslint_d', 'prettier' },
      typescriptreact = { 'eslint_d', 'prettier' },
      json = { 'prettier' },
      yaml = { 'prettier' },
      markdown = { 'prettier' },
      lua = { 'stylua' },
    },
    formatters = {
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
