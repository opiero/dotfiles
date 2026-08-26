-- Buffers de proposta do claudecode.nvim recebem nome "<arquivo> (proposed)",
-- "<arquivo> (NEW FILE - proposed)" ou "<arquivo> (New)". Aceitar o diff e um :w
-- nesse buffer, entao qualquer hook de BufWritePre reescreve o conteudo proposto
-- pelo Claude antes de ir pro disco.
local M = {}

function M.is_proposed_buffer(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  return name:match 'proposed%)$' ~= nil or name:match '%(New%)$' ~= nil
end

return M
