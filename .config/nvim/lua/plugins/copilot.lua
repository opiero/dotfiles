local config = require 'configs.copilot'

local M = {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup(config)
  end,
}
return M
