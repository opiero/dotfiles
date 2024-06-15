vim.opt.completeopt = { completeopt = 'menu,menuone,noselect' }
vim.opt.shortmess:append 'c'

local lspkind = require 'lspkind'
lspkind.init {}

local cmp = require 'cmp'
local luasnip = require 'luasnip'
luasnip.config.setup {}

cmp.setup {
  sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer' },
  },

  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-y>'] = cmp.mapping.confirm { select = true },
    ['<C-f>'] = cmp.mapping.complete {},
  },

  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
}
