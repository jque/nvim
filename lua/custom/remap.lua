-- Diagnostic keymaps
vim.keymap.set('n', '<leader>E', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set('n', '<leader>e', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set('n', '<leader>df', vim.diagnostic.open_float, { desc = "[D]iagnostic open [F]loating message" })
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = "[D]iagnostic open [L]ist" })
