return {
  {
    'OXY2DEV/markview.nvim',
    ft = { 'markdown' },
    keys = {
      { '<leader>ts', ':Markview splitToggle<CR>', desc = 'Toggle Split' },
    },
  },

  {
    'nfrid/markdown-togglecheck',
    lazy = false,
    dependencies = { 'nfrid/treesitter-utils' },
    ft = { 'markdown' },
    keys = {
      {
        '<enter>',
        function()
          require('markdown-togglecheck').toggle()
        end,
        desc = 'Toggle Checkbox',
      },
    },
  },
}
