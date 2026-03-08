local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if ok_cmp then
  capabilities = vim.tbl_deep_extend('force', capabilities, cmp_lsp.default_capabilities())
end

vim.lsp.config['dbt'] = {
  cmd = { 'dbt-language-server' },
  filetypes = { 'sql', 'yaml' },
  root_markers = { 'dbt_project.yml' },
  capabilities = capabilities,
}

vim.lsp.enable 'dbt'
