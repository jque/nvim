-- LSP Configuration & Plugins
-- https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
--
-- Plugins (mason, mason-lspconfig, nvim-lspconfig, fidget) installed in
-- custom/package.lua. mason must be set up before mason-lspconfig.
require('mason').setup {}
require('fidget').setup {} -- lsp status

require('mason-lspconfig').setup {
  -- Only real LSP servers here (eslint_d is a formatter, see conform.lua).
  automatic_enable = {
    'ts_ls',
    'lua_ls',
    'eslint',
    'biome',
  },
}

vim.lsp.config('biome', {
  root_dir = function(bufnr, cb)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local found = vim.fs.find({ 'biome.json', 'biome.jsonc' }, { path = fname, upward = true })[1]

    if found then
      cb(vim.fn.fnamemodify(found, ':h'))
    end
  end,
})

vim.lsp.config('eslint', {
  root_dir = function(bufnr, cb)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local found = vim.fs.find({
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
    }, { path = fname, upward = true })[1]

    if found then
      cb(vim.fn.fnamemodify(found, ':h'))
    end
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local nmap = function(keys, func, desc)
      if desc then
        desc = 'LSP: ' .. desc
      end

      vim.keymap.set('n', keys, func, { buffer = ev.buf, desc = desc })
    end

    -- <leader>l: [l]sp group (see which-key groups in plugins/misc.lua)
    nmap('<leader>ld', require('telescope.builtin').lsp_definitions, '[L]sp goto [D]efinition')
    nmap('<leader>lr', require('telescope.builtin').lsp_references, '[L]sp goto [R]eferences')
    nmap('<leader>li', vim.lsp.buf.implementation, '[L]sp goto [I]mplementation')
    nmap('<leader>lt', vim.lsp.buf.type_definition, '[L]sp goto [T]ype definition')
    nmap('<leader>ln', vim.lsp.buf.rename, '[L]sp re[N]ame')
    nmap('<leader>la', vim.lsp.buf.code_action, '[L]sp code [A]ction')
    nmap('<leader>ls', require('telescope.builtin').lsp_document_symbols, '[L]sp document [S]ymbols')
    nmap('<leader>lS', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[L]sp workspace [S]ymbols')

    nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    -- <C-k> is reserved for window/herdr navigation (see plugins/smart-splits.lua)
    nmap('gK', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality: <leader>lw = [l]sp [w]orkspace folders
    nmap('<leader>lwa', vim.lsp.buf.add_workspace_folder, '[L]sp [W]orkspace [A]dd Folder')
    nmap('<leader>lwr', vim.lsp.buf.remove_workspace_folder, '[L]sp [W]orkspace [R]emove Folder')
    nmap('<leader>lwl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[L]sp [W]orkspace [L]ist Folders')
  end,
})
