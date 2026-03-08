vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = 'a'

vim.opt.showmode = true

vim.opt.clipboard = 'unnamedplus'

vim.opt.breakindent = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true

vim.opt.undofile = true

vim.opt.ignorecase = true

vim.opt.signcolumn = 'auto'

vim.opt.updatetime = 250

--disable swap file
vim.opt.swapfile = false

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.inccommand = 'split'

vim.opt.cursorline = false

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

require 'mapping.diagnostics'
require 'mapping.disable_arrow_keys'
require 'mapping.move_focus'
require 'mapping.nvtree'
require 'mapping.tmux-vim-navigator'
require 'mapping.file-navigation'
require 'mapping.dbtpal'

-- Autocommands
require 'autocommands.highlight_yanking'
require 'autocommands.conceallevel_markdown'
require 'autocommands.remove_trailing_whitespace'


local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  'tpope/vim-sleuth',
  require 'plugins.nvim-dap',
  require 'plugins.comment',
  require 'plugins.conform',
  require 'plugins.gitsigns',
  require 'plugins.nvim-autopairs',
  require 'plugins.nvim-lspconfig',
  require 'plugins.nvim-cmp',
  require 'plugins.dbtpal',
  require 'plugins.nvtree',
  require 'plugins.telescope',
  require 'plugins.themes.tokyonight',
  require 'plugins.themes.nagai-poolside',
  require 'plugins.themes.gruvbox',
  require 'plugins.themes.kanagawa',
  require 'plugins.themes.catpuccin',
  require 'plugins.todo-comments',
  require 'plugins.treesitter',
  require 'plugins.vim-tmux-navigator',
  require 'plugins.easytables',
  require 'plugins.which-key',
  require 'plugins.nvim-highlight-colors',
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

vim.cmd.colorscheme 'kanagawa'
-- Standalone LSP's
require 'lsp.dbt'
