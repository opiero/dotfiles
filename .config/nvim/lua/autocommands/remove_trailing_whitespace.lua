local claude_diff = require 'utils.claude_diff'

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = { '*' },
  callback = function(ev)
    if claude_diff.is_proposed_buffer(ev.buf) then
      return
    end
    local save_cursor = vim.fn.getpos '.'
    pcall(function()
      vim.cmd [[%s/\s\+$//e]]
    end)
    vim.fn.setpos('.', save_cursor)
  end,
})
