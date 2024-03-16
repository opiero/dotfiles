-- ['<C-h>'] = { '<cmd> TmuxNavigateLeft<CR>', 'window left' },
-- ['<C-l>'] = { '<cmd> TmuxNavigateRight<CR>', 'window right' },
-- ['<C-j>'] = { '<cmd> TmuxNavigateDown<CR>', 'window down' },
-- ['<C-k>'] = { '<cmd> TmuxNavigateUp<CR>', 'window up' },

vim.keymap.set('n', '<C-h>', '<cmd> TmuxNavigateLeft<CR>', { desc = 'Move to the window to the left' })
vim.keymap.set('n', '<C-l>', '<cmd> TmuxNavigateRight<CR>', { desc = 'Move to the window to the right' })
vim.keymap.set('n', '<C-j>', '<cmd> TmuxNavigateDown<CR>', { desc = 'Move to the window below' })
vim.keymap.set('n', '<C-k>', '<cmd> TmuxNavigateUp<CR>', { desc = 'Move to the window above' })
