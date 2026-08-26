-- As deps de cada subprojeto moram no venv construido DENTRO do devcontainer;
-- sem extraPaths o pyright nao resolve `import dagster_dbt` e casa
-- `import dagster` com o DIRETORIO dagster/ em vez da lib.
--
-- Fica aqui e nao no `servers` do nvim-lspconfig.lua porque o mason-lspconfig
-- instalado e v2: nao tem mais a opcao `handlers`, sobe os servers por
-- vim.lsp.enable, e aquele bloco nao roda.
vim.lsp.config('pyright', {
  -- Tem que ser on_init mexendo em client.settings: quem o servidor le e esse
  -- campo, nao config.settings. Injetar no before_init deixa os extraPaths
  -- visiveis em client.config.settings e os imports continuam sem resolver.
  on_init = function(client)
    local paths = require('utils.devcontainer').python_paths(client.root_dir)
    if vim.tbl_isempty(paths) then
      return
    end
    client.settings = vim.tbl_deep_extend('force', client.settings or {}, {
      python = { analysis = { extraPaths = paths } },
    })
    client:notify('workspace/didChangeConfiguration', { settings = client.settings })
  end,
})
