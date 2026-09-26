-- Diagnostic keymaps
vim.keymap.set('n', '<leader>E', function() vim.diagnostic.jump { count = -1, float = true } end, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', '<leader>e', function() vim.diagnostic.jump { count = 1, float = true } end, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>df', vim.diagnostic.open_float, { desc = '[D]iagnostic open [F]loating message' })
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = '[D]iagnostic open [L]ist' })

-- clipboard
vim.keymap.set('n', '<leader>y', '"+y', { desc = '[Y]ank to the system clipboard' })
vim.keymap.set('n', '<leader>p', '"+p', { desc = '[P]paste from the system clipboard' })

-- ghostty
vim.keymap.set('i', '<C-`>', '<Esc>', { noremap = true, silent = true })

-- window navigation lives in custom/plugins/smart-splits.lua (smart-splits keymaps)

-- tabs
vim.keymap.set('n', '<C-w>a', '<cmd>tabnew<cr>', { desc = '[A]ppend a new tab (mirrors herdr prefix+a)' })
