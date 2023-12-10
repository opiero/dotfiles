local overrides = require("custom.configs.overrides")

local plugins = {
  {
    "neovim/nvim-lspconfig",
    config = function ()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    config = function()
      require "custom.configs.lint"
    end
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "black",
        "eslint-lsp",
        "lua-language-server",
        "mypy",
        "prettier",
        "pyright",
        "ruff",
        "typescript-language-server",
      }
    }
  },

  {
    "zbirenbaum/copilot.lua",
    event="InsertEnter",
    opts = overrides.copilot
  },
}
return plugins
