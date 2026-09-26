-- In-buffer markdown rendering (headings, tables, code blocks, checkboxes).
-- Plugin installed in custom/package.lua. Needs the markdown + markdown_inline
-- treesitter parsers (ensured in custom/plugins/tree-sitter-manager.lua).
require('render-markdown').setup {
  completions = { lsp = { enabled = true } },
  latex = { enabled = false }, -- no latex parser installed
  -- Keep the cursor line rendered in normal mode; raw source only shows in
  -- insert mode (render_modes defaults to n/c/t, so insert un-renders).
  anti_conceal = { enabled = false },
}

-- Toggle rendering on demand (e.g. to edit tables without the overlay).
vim.keymap.set('n', '<leader>md', function()
  require('render-markdown').toggle()
end, { desc = '[M]ark[d]own render toggle' })
