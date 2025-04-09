return {
  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
    },
    keys = {
      { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>', desc = 'Move focus to the left window' },
      { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>', desc = 'Move focus to the lower window' },
      { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>', desc = 'Move focus to the upper window' },
      { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>', desc = 'Move focus to the right window' },
    },
  },

  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    keys = {
      { '-', '<CMD>Oil --float<CR>', mode = 'n', desc = 'Open parent directory' },
    },
    config = function()
      require('oil').setup()

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'oil',
        callback = function()
          -- Map double Escape to close the floating Oil window
          vim.keymap.set('n', '<Esc><Esc>', '<Cmd>q<CR>', {
            buffer = true,
            desc = 'Close Oil floating window',
          })
        end,
      })
    end,
  },

  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    opts = {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      settings = {
        save_on_toggle = true,
      },
    },
    keys = function()
      local keys = {
        {
          '<leader>H',
          function()
            require('harpoon'):list():add()
          end,
          desc = 'Harpoon File',
        },
        {
          '<leader>h',
          function()
            local harpoon = require 'harpoon'
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = 'Harpoon Quick Menu',
        },
      }

      for i = 1, 9 do
        table.insert(keys, {
          '<leader>' .. i,
          function()
            require('harpoon'):list():select(i)
          end,
          desc = 'which_key_ignore',
        })
      end
      return keys
    end,
  },

  {
    -- INFO: Currently using noice for the command_palette because snacks input doesnt supose to replace this
    -- see https://github.com/folke/snacks.nvim/issues/239
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      presets = {
        command_palette = true,
      },
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
  },
}
