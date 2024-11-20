return {
  vim.g.vimtex_view_method == '',
  vim.g.vimtex_compiler_method == 'latexmk',
  vim.opt.guicursor == 'a:block',

  vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move down' }),
  vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move up' }),

  vim.keymap.set('n', '<leader>n', '<cmd>NerdIcons<cr>', { desc = 'Open NerdIcons' }),
  vim.keymap.set({ 'n', 'v' }, '<C-p>', '"*p', { desc = 'Paste from selection clipboard' }),
  vim.keymap.set({ 'n', 'v' }, 'p', '"+p', { desc = 'Paste from system clipboard' }),
  vim.keymap.set({ 'v', 'n' }, '<leader>t', '<cmd>TSBufToggle highlight<cr>', { desc = 'Toggle Tree-sitter highlighting' }),
  vim.keymap.set('n', '<leader>z', ":!zathura <C-r>=expand('%:r')<cr>.pdf &<cr>", { desc = 'Open PDF' }),

  vim.keymap.set({ 'n' }, '<leader>p', function()
    local file_name = vim.fn.expand '%:t'
    if file_name ~= '' then
      -- Open Explorer in the current directory and select the file
      vim.fn.system { 'explorer.exe', '/select,', file_name }
    else
      print 'No file name found. Save the buffer first.'
    end
  end, { desc = 'Open file location in Explorer' }),

  vim.keymap.set({ 'n' }, '<leader>o', function()
    local file_name = vim.fn.expand '%:t'
    if file_name ~= '' then
      -- Open Explorer in the current directory and select the file
      vim.fn.system { 'explorer.exe', file_name }
    else
      print 'No file found. Make sure the buffer is saved.'
    end
  end, { desc = 'Open file ' }),
}
