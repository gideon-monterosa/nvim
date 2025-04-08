---@diagnostic disable: undefined-global
return {
  {
    'folke/snacks.nvim',
    ---@type snacks.Config
    opts = {
      picker = {},

      statuscolumn = {},

      scroll = {
        animate = {
          duration = { step = 25, total = 100 },
        },
      },
    },
    keys = {
      -- TODO: remove after fixing stylua.toml not being detected
      -- stylua: ignore start
      { '<leader><leader>', function() Snacks.picker.buffers() end, desc = 'Buffers', },
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
      { '<leader>ff', function() Snacks.picker.git_files() end, desc = 'Find Git Files', },

      { '<leader>fs', function() Snacks.picker.smart() end, desc = 'Smart Find Files', },
      { '<leader>fa', function() Snacks.picker.files() end, desc = 'Find Files', },
      { '<leader>fp', function() Snacks.picker.projects() end, desc = 'Projects', },
      { '<leader>fr', function() Snacks.picker.recent() end, desc = 'Recent', },
      -- stylua: ignore end
    },
  },
}
