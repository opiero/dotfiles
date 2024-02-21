local overrides = require("custom.configs.overrides")

local plugins = {
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end,
	},
	{
		"ThePrimeagen/vim-be-good",
		event = "VeryLazy",
	},
	{
		"gptlang/CopilotChat.nvim",
		event = "VeryLazy",
	},
	{
		"mfussenegger/nvim-lint",
		event = "VeryLazy",
		config = function()
			require("custom.configs.lint")
		end,
	},
	{
		"mhartington/formatter.nvim",
		event = "VeryLazy",
		opts = function()
			return require("custom.configs.formatter")
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
				"black",
				"eslint_d",
				"mypy",
				"luacheck",
				"prettier",
				"stylua",
				"pyright",
				"ruff",
				"lua-language-server",
				"isort",
				"typescript-language-server",
			},
		},
	},
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		opts = overrides.copilot,
	},
	{
		"Equilibris/nx.nvim",

		dependencies = {
			"nvim-telescope/telescope.nvim",
		},

		opts = {
			-- See below for config options
			nx_cmd_root = "nx",
		},
		event = "VeryLazy",
		-- Plugin will load when you use these keys
		keys = {
			{ "<leader>nx", "<cmd>Telescope nx actions<CR>", desc = "nx actions" },
		},
	},
}
return plugins
