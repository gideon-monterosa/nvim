return {
  {
    'OXY2DEV/markview.nvim',
    ft = { 'markdown' },
    keys = {
      { '<leader>ts', ':Markview splitToggle<CR>', desc = 'Toggle Split' },
      { '<leader>tp', ':Markview toggle<CR>', desc = 'Toggle Preview' },
    },
  },

  {
    'nfrid/markdown-togglecheck',
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
