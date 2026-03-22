local M = {
  'https://codeberg.org/esensar/nvim-dev-container',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  config = function()
    require('devcontainer').setup {
      -- Detecta o devcontainer correto baseado no diretório do buffer atual
      config_search_start = function()
        local cwd = vim.loop.cwd()
        local current_file = vim.fn.expand('%:p:h')

        -- Detecta se estamos em um subdiretório específico (backend, frontend, dagster)
        local subdirs = { 'backend', 'frontend', 'dagster' }
        for _, subdir in ipairs(subdirs) do
          if current_file:find('/' .. subdir .. '/') or current_file:match('/' .. subdir .. '$') then
            local devcontainer_path = cwd .. '/.devcontainer/' .. subdir
            if vim.fn.isdirectory(devcontainer_path) == 1 then
              return devcontainer_path
            end
          end
        end

        return cwd
      end,
      -- Instala neovim como root no container (necessário quando remoteUser não é root)
      nvim_install_as_root = true,
      attach_mounts = {
        neovim_config = {
          enabled = true,
        },
        neovim_data = {
          enabled = true,
        },
        neovim_state = {
          enabled = true,
        },
      },
      -- Monta config do neovim também no home do nonroot
      always_mount = {
        vim.fn.expand('~/.config/nvim') .. ':/home/nonroot/.config/nvim:ro',
        vim.fn.expand('~/.local/share/nvim') .. ':/home/nonroot/.local/share/nvim',
        vim.fn.expand('~/.local/state/nvim') .. ':/home/nonroot/.local/state/nvim',
      },
    }
  end,
}

return M
