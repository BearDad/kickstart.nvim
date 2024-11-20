return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  theme = 'hyper',
  config = function()
    require('dashboard').setup {
      -- config
      --
    }
  end,
  hide = {
    statusline, -- hide statusline default is true
    tabline, -- hide the tabline
    winbar, -- hide winbar
  },

  dependencies = { { 'nvim-tree/nvim-web-devicons' } },
}
