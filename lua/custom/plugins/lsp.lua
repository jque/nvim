-- LSP Configuration & Plugins
-- https://github.com/adalessa/alpha-nvim/blob/main/after/plugin/lsp.lua
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

return {
  'mason-org/mason-lspconfig.nvim',
  opts = {
    automatic_enable = {
      'ts_ls',
      'lua_ls',
      'vimls',
      'eslint', -- lsp
      'eslint_d', -- format
      'biome',
    },
  },
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    { 'j-hui/fidget.nvim', opts = {} }, -- lsp status
    'neovim/nvim-lspconfig',
    'folke/snacks.nvim',
  },
  config = function(_, opts)
    require('mason-lspconfig').setup(opts)

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        local nmap = function(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end

          vim.keymap.set('n', keys, func, { buffer = ev.buf, desc = desc })
        end

        nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        nmap('<leader>do', vim.lsp.buf.code_action, '[C]ode [A]ction')
        -- nmap('<leader>gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        nmap('<leader>gd', require('snacks').picker.lsp_definitions, '[G]oto [D]efinition')
        nmap('<leader>gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        nmap('<leader>gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
        nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
        nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
        nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        nmap('gd', require('snacks').picker.lsp_definitions, '[G]oto [D]efinition')
        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

        -- Lesser used LSP functionality
        nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
        nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
        nmap('<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, '[W]orkspace [L]ist Folders')
      end,
    })
  end,
}
