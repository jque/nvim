-- LSP Configuration & Plugins
return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'tamago324/nlsp-settings.nvim',

    -- Useful status updates for LSP
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

    -- Additional lua configuration, makes nvim stuff amazing!
    'folke/neodev.nvim',
  },
  config = function()
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require 'mason-lspconfig'
    -- local nls_psettings = require("nlspsettings")
    --
    -- nls_psettings.setup({
    --   config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
    --   local_settings_dir = ".nlsp-settings",
    --   local_settings_root_markers_fallback = { '.git' },
    --   append_default_schemas = true,
    --   loader = 'json'
    -- })

    local on_attach = function(_, bufnr)
      local nmap = function(keys, func, desc)
        if desc then
          desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
      end

      nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
      nmap('<leader>do', vim.lsp.buf.code_action, '[C]ode [A]ction')
      nmap('<leader>gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
      nmap('<leader>gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
      nmap('<leader>gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
      nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
      nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
      nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

      nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
      nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
      -- nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
      nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

      -- Lesser used LSP functionality
      nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
      nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
      nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, '[W]orkspace [L]ist Folders')

      -- Create a command `:Format` local to the LSP buffer
      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
      end, { desc = 'Format current buffer with LSP' })
    end

    local eslint_fix_all_format_is_enabled = true

    vim.api.nvim_create_user_command('EslintFixAllToggle', function()
      eslint_fix_all_format_is_enabled = not eslint_fix_all_format_is_enabled
      print('EslintFixAll BufWritePre setting to: ' .. tostring(eslint_fix_all_format_is_enabled))
    end, {})

    local eslint_on_attach = function(_, bufnr)
      on_attach(_, bufnr)

      -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#eslint
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          if not eslint_fix_all_format_is_enabled then
            return
          end

          vim.cmd("EslintFixAll")
        end
      });
    end

    -- use either `LspSettings buffer` or `LspSettings tsserver` to add a new config.
    local servers = {
      html = {},
      eslint = {},
      -- tsserver = {},
      ts_ls = {},
      yamlls = {
        yaml = {
          schemas = {
            ["kubernetes"] = "/templates/*.yaml",
          },
        },
      },
      jsonls = {
        settings = {
          json = {
            format = {
              enable = true,
            },
          },
          validate = { enable = true },
        },
      },
      dockerls = {},
      bashls = {},
      lua_ls = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    }

    -- Setup neovim lua configuration
    require('neodev').setup()

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    -- Setup mason so it can manage external tooling
    require('mason').setup()

    mason_lspconfig.setup {
      ensure_installed = vim.tbl_keys(servers),
    }

    mason_lspconfig.setup_handlers {
      function(server_name)
        local config = {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = servers[server_name],
        }

        if server_name == 'eslint' then
          config.on_attach = eslint_on_attach
        end

        lspconfig[server_name].setup(config)
      end,
    }
  end,
}
