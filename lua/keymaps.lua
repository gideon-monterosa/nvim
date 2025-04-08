local map = vim.keymap.set

-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Clear highlights on search when pressing <Esc> in normal mode
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

map('v', '<Tab>', '>gv', { desc = 'increase indent of marked lines' })
map('v', '<S-Tab>', '<gv', { desc = 'decrease indent of marked lines' })
