return {
  'iurimateus/luasnip-latex-snippets.nvim',
  lazy = false,
  dependencies = {
    'L3MON4D3/LuaSnip',
    'lervag/vimtex',
  },
  config = function()
    require('luasnip-latex-snippets').setup()

    require('luasnip').config.setup {
      enable_autosnippets = true,
    }
  end,
}
