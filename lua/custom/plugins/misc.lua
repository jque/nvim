-- Small setup-only plugins that previously used lazy's `opts = {}`.
-- (Plugins are installed in custom/package.lua via vim.pack.)

-- "gc" to comment visual regions/lines
require('Comment').setup()

-- Shows pending keybinds
require('which-key').setup()
