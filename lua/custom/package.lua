-- Native plugin management with vim.pack (Neovim 0.12+).
-- Replaces lazy.nvim. See `:help vim.pack`.
--
-- How this is laid out:
--   * vim.pack.add() below installs + loads every plugin (synchronously).
--   * Each require('custom.plugins.<name>') only *configures* an already
--     loaded plugin (setup()/keymaps). There is no per-file plugin spec
--     anymore: the source URLs all live here.
--   * Build steps (e.g. telescope-fzf-native's `make`) run from the
--     PackChanged autocmd, which must be registered BEFORE vim.pack.add so
--     it also fires on the very first install.

-- Build hooks ---------------------------------------------------------------
local builds = {
  ['telescope-fzf-native.nvim'] = { 'make' },
}

vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('pack-build-hooks', { clear = true }),
  callback = function(ev)
    local cmd = builds[ev.data.spec.name]
    if cmd and (ev.data.kind == 'install' or ev.data.kind == 'update') then
      if vim.fn.executable(cmd[1]) ~= 1 then
        vim.notify(('[pack] skip build of %s: %s not found'):format(ev.data.spec.name, cmd[1]), vim.log.levels.WARN)
        return
      end
      vim.notify('[pack] building ' .. ev.data.spec.name, vim.log.levels.INFO)
      vim.system(cmd, { cwd = ev.data.path }):wait()
    end
  end,
})

-- diffs.nvim integrations. Set BEFORE vim.pack.add so the value exists when
-- the plugin is sourced. diffs.nvim lists gitsigns.nvim as conflicting, so we
-- enable the explicit integration to make them coexist instead of overlapping.
vim.g.diffs = {
  integrations = {
    fugitive = true,  -- guh.nvim's optional git backend
    gitsigns = true,  -- we use gitsigns for gutter signs
    telescope = true, -- highlight telescope git previews (replaces delta)
  },
}

-- Install + load -------------------------------------------------------------
-- `version = vim.version.range('*')` tracks the latest semver tag (the
-- equivalent of lazy.nvim's `version = '*'`); omitting it tracks the
-- repository's default branch.
vim.pack.add({
  -- tpope essentials (no setup needed)
  { src = 'https://github.com/tpope/vim-fugitive' },
  { src = 'https://github.com/tpope/vim-rhubarb' },
  { src = 'https://github.com/tpope/vim-sleuth' },
  { src = 'https://github.com/tpope/vim-surround' },

  -- editing helpers
  { src = 'https://github.com/numToStr/Comment.nvim' },
  { src = 'https://github.com/folke/which-key.nvim' },
  { src = 'https://github.com/nicwest/vim-camelsnek' },
  { src = 'https://github.com/justinmk/guh.nvim' },
  { src = 'https://github.com/barrettruth/diffs.nvim' }, -- diff highlighting for guh.nvim
  { src = 'https://github.com/dmmulroy/ts-error-translator.nvim' },

  -- colorscheme
  { src = 'https://github.com/folke/tokyonight.nvim' },

  -- telescope + deps
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope.nvim', version = vim.version.range('*') },
  { src = 'https://github.com/nvim-telescope/telescope-file-browser.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope-ui-select.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim' },

  -- LSP
  { src = 'https://github.com/mason-org/mason.nvim' },
  { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/j-hui/fidget.nvim' },
  { src = 'https://github.com/folke/snacks.nvim' },

  -- completion
  { src = 'https://github.com/hrsh7th/nvim-cmp' },
  { src = 'https://github.com/hrsh7th/cmp-nvim-lsp' },
  { src = 'https://github.com/hrsh7th/cmp-buffer' },
  { src = 'https://github.com/L3MON4D3/LuaSnip' },
  { src = 'https://github.com/saadparwaiz1/cmp_luasnip' },

  -- formatting
  { src = 'https://github.com/stevearc/conform.nvim' },

  -- UI / git / files / misc
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/lukas-reineke/indent-blankline.nvim' },
  { src = 'https://github.com/nvim-lualine/lualine.nvim' },
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  { src = 'https://github.com/nvim-tree/nvim-tree.lua', version = vim.version.range('*') },
  { src = 'https://github.com/folke/trouble.nvim' },
  { src = 'https://github.com/ThePrimeagen/harpoon' },
  { src = 'https://github.com/romus204/tree-sitter-manager.nvim' },
  { src = 'https://github.com/folke/sidekick.nvim' },
  { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim', version = vim.version.range('*') },

  -- window navigation / resize
  { src = 'https://github.com/mrjones2014/smart-splits.nvim' },
  { src = 'https://github.com/lmilojevicc/herdr-splits.nvim' }, -- replaces smart-splits inside herdr
  { src = 'https://github.com/nvimtools/hydra.nvim' },
})

-- Configure ------------------------------------------------------------------
-- Colorscheme first so highlight groups exist when other UIs initialize.
require('custom.themes')

-- Order matters only where one plugin's *setup* depends on another already
-- being configured (harpoon registers a telescope extension).
require('custom.plugins.misc')
require('custom.plugins.telescope')
require('custom.plugins.harpoon')
require('custom.plugins.lsp')
require('custom.plugins.cmp')
require('custom.plugins.conform')
require('custom.plugins.gitsigns')
require('custom.plugins.indent-blankline')
require('custom.plugins.lualine')
require('custom.plugins.filetree')
require('custom.plugins.trouble')
require('custom.plugins.typescript')
require('custom.plugins.vim-camelsnek')
require('custom.plugins.tree-sitter-manager')
require('custom.plugins.sidekick')
require('custom.plugins.smart-splits')
require('custom.plugins.render-markdown')
