-- O Claude edita arquivos por fora do nvim; sem isso um :w sobrescreve a
-- versao dele com o buffer velho.
vim.opt.autoread = true

vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'TermClose', 'TermLeave' }, {
  callback = function()
    if vim.fn.mode() ~= 'c' then
      vim.cmd 'checktime'
    end
  end,
})
