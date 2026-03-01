local highlight_colors = require 'nvim-highlight-colors'
vim.opt.termguicolors = true

highlight_colors.setup {
  render = 'virtual',
  virtual_symbol_prefix = ' ',
  virtual_symbol_suffix = '',
  virtual_symbol_position = 'eow',
}
