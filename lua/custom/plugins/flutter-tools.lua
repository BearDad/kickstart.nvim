return
-- install flutter tools
{
  'akinsho/flutter-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('flutter-tools').setup {
      lsp = {
        on_attach = function(_, bufnr)
          local bufmap = function(mode, lhs, rhs)
            vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap = true, silent = true })
          end
          bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
          bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
        end,
      },
    }
  end,
}
