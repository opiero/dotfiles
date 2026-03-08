local M = {
  'PedramNavid/dbtpal',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  ft = {
    'sql',
    'md',
    'yaml',
  },
  config = function()
    require 'configs.dbtpal'
  end,
}

return M
