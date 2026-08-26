-- Servidor WebSocket/MCP que o `claude --ide` (ou `/ide`) descobre via lockfile
-- em ~/.claude/ide/. O Claude roda em pane proprio do tmux, entao nao ha
-- terminal dentro do nvim: provider 'none' (trocar para 'native' se quiser
-- o Claude num split do nvim, ai vale mapear :ClaudeCode).
local M = {
  'coder/claudecode.nvim',
  -- VeryLazy e obrigatorio: sem ele o servidor so sobe no primeiro :ClaudeCode*
  -- e o `claude --ide` nao acha o lockfile em ~/.claude/ide/.
  event = 'VeryLazy',
  opts = {
    terminal = { provider = 'none' },
    diff_opts = { layout = 'vertical' },
  },
  cmd = {
    'ClaudeCodeStart',
    'ClaudeCodeStop',
    'ClaudeCodeStatus',
    'ClaudeCodeSend',
    'ClaudeCodeAdd',
    'ClaudeCodeTreeAdd',
    'ClaudeCodeDiffAccept',
    'ClaudeCodeDiffDeny',
    'ClaudeCodeCloseAllDiffs',
  },
  keys = {
    { '<leader>a', nil, desc = '[A]I/Claude Code' },
    { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Claude: [A]dd current [B]uffer' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Claude: [S]end selection' },
    { '<leader>as', '<cmd>ClaudeCodeTreeAdd<cr>', desc = 'Claude: add file', ft = { 'NvimTree' } },
    { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Claude: [A]ccept diff' },
    { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Claude: [D]eny diff' },
    { '<leader>ai', '<cmd>ClaudeCodeStatus<cr>', desc = 'Claude: [I]DE status' },
  },
}

return M
