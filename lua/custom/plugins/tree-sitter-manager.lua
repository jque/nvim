-- Treesitter parser manager. Plugin installed in custom/package.lua.
-- NOTE: the tree-sitter CLI must be installed system-wide.
require('tree-sitter-manager').setup {
  ensure_installed = { 'lua', 'python', 'vim', 'vimdoc', 'markdown', 'markdown_inline', 'json', 'html', 'css', 'javascript', 'typescript', 'tsx', 'diff' }, -- parsers installed at startup ('diff' for diffs.nvim)
  auto_install = true,
  highlight = true,
  -- The gitcommit TS grammar expects a commit message, so it misparses guh's
  -- raw-diff prdiff buffers (ft=gitcommit): the leading lines parse as commit
  -- `subject` and get painted bold-blue (@markup.heading), bleeding over the
  -- file that follows a collapsed "(viewed)" entry. Regex syntax + diffs.nvim
  -- cover those buffers (and plain commit messages) fine without it.
  nohighlight = { 'gitcommit' },
  -- Default Options
  -- ensure_installed = {}, -- list of parsers to install at the start of a neovim session
  -- border = nil, -- border style for the window (e.g. "rounded", "single"), if nil, use the default border style defined by 'vim.o.winborder'. See :h 'winborder' for more info.
  -- auto_install = false, -- if enabled, install missing parsers when editing a new file
  -- highlight = true, -- treesitter highlighting is enabled by default
  -- languages = {}, -- override or add new parser sources
  -- parser_dir = vim.fn.stdpath("data") .. "/site/parser",
  -- query_dir = vim.fn.stdpath("data") .. "/site/queries",
}
