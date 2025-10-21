return {
  {
    'somerocketeer/nagai-poolside.nvim',
    priority = 1000,
    config = function()
      require('nagai_poolside').setup { transparent = false }
      vim.cmd.colorscheme 'nagai-poolside'
    end,
  },
}
