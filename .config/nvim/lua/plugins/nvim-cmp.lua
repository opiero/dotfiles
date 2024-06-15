local M = { -- Autocompletion
  'hrsh7th/nvim-cmp',
  lazy = false,
  priority = 100,
  event = 'InsertEnter',
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      build = 'make install_jsregexp',
    },
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'onsails/lspkind.nvim',
    'saadparwaiz1/cmp_luasnip',
  },
  config = function()
    require 'configs.nvim-cmp'
  end,
}
return M
