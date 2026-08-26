-- Sucessor do neodev (deprecado pelo autor). O neodev se enganchava no
-- lspconfig.setup, que o mason-lspconfig v2 nao chama mais -- resultado era
-- `Undefined global vim` no proprio config. O lazydev injeta a library via
-- didChangeConfiguration, independente de como o lua_ls subiu.
local M = {
  'folke/lazydev.nvim',
  ft = 'lua',
  opts = {
    library = {
      -- tipos do vim.uv (usado em commands/devcontainer.lua)
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
  },
}

return M
