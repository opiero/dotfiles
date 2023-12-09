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
    "jose-elias-alvarez/null-ls.nvim",
    -- event = "VeryLazy",
    lazy = false,
    config = function ()
      require "custom.configs.null-ls"
    end,
  },

  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "pyright",
        "mypy",
        "debugpy",
        "ruff",
        "black",
        "typescript-language-server",
        "eslint-lsp",
        "prettier"
      }
    }
  },

   {
     "mfussenegger/nvim-dap",
     config = function (_, opts)
       require("core.utils").load_mappings("dap")
     end
   },
 
   {
     "mfussenegger/nvim-dap-python",
     ft = "python",
     dependencies = {
       "mfussenegger/nvim-dap",
       "rcarriga/nvim-dap-ui"
     },
     config = function (_, opts)
       local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
       require("dap-python").setup(path)
       require("core.utils").load_mappings("dap_python")
     end
   },
 
   {
     "rcarriga/nvim-dap-ui",
     dependencies = {"mfussenegger/nvim-dap"},
 
     config = function ()
       local dap = require("dap")
       local dapui = require("dapui")
       dapui.setup()
       dap.listeners.after.event_initialized["dapui_config"] = function()
         dapui.open()
       end
       dap.listeners.before.event_terminated["dapui_config"] = function()
         dapui.close()
       end
       dap.listeners.before.event_exited["dapui_config"] = function()
         dapui.close()
       end
     end,
   },
  {
    "zbirenbaum/copilot.lua",
    event="InsertEnter",
    opts = overrides.copilot
  }

}
return plugins
