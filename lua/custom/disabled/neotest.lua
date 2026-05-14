return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-neotest/neotest-jest",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter"
  },
  -- keys = {
  --   { "<leader>jr", "<cmd>Neotest run<cr>" },
  --   { "<leader>ji", "<cmd>Neotest output<cr>" },
  --   { "<leader>js", "<cmd>Neotest summary<cr>" },
  --   { "<leader>ja", "<cmd>lua require('neotest').run.run({ suite = true })<cr>" },
  -- },
  config = function()
    require('neotest').setup({
    settings = {
      watch = true,
    },
    adapters = {
        require('neotest-jest')
      }
    })
  end
}
