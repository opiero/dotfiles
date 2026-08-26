local M = { -- Autoformat
  'stevearc/conform.nvim',
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      if require('utils.claude_diff').is_proposed_buffer(bufnr) then
        return nil
      end
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      return {
        timeout_ms = 500,
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      }
    end,
    formatters = {
      -- black/isort do venv do devcontainer, rodados pelo python3.11 do host.
      -- Versoes travadas no poetry.lock (black 24.8.0, isort 5.13.2); as do mason
      -- no host (26.3.0 / 8.0.1) geram diff que o lint do CI rejeita.
      black_venv = {
        command = require('utils.devcontainer').host_python,
        args = { '-m', 'black', '-q', '-' },
        stdin = true,
        env = function(_, ctx)
          return require('utils.devcontainer').pythonpath_env(ctx.filename)
        end,
      },
      isort_venv = {
        command = require('utils.devcontainer').host_python,
        -- --settings-path le o [tool.isort] do subprojeto (profile + known_first_party),
        -- que o stdin sozinho nao localiza.
        args = function(_, ctx)
          local sub = require('utils.devcontainer').subproject(ctx.filename)
          return { '-m', 'isort', '--settings-path', sub.dir, '-' }
        end,
        stdin = true,
        env = function(_, ctx)
          return require('utils.devcontainer').pythonpath_env(ctx.filename)
        end,
      },
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      typescript = { 'prettierd' },
      javascript = { 'prettierd' },
      html = { 'prettierd' },
      css = { 'prettierd' },
      python = function(bufnr)
        local devcontainer = require 'utils.devcontainer'
        local name = vim.api.nvim_buf_get_name(bufnr)
        if devcontainer.has_module(name, 'black') then
          return { 'isort_venv', 'black_venv' }
        end
        return { 'isort', 'black' }
      end,
      go = { 'golines', 'goimports-reviser', 'gofumpt' },
      c = { 'clang-format' },
      --
      -- You can use a sub-list to tell conform to run *until* a formatter
      -- is found.
      -- javascript = { { "prettierd", "prettier" } },
    },
  },
}
return M
