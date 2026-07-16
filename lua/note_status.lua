local M = {}
M.compiling = false

-- VimTeX exposes compile state via User autocmds (the b:vimtex.compiler.status
-- buffer var, not a g: var). Drive a simple flag off those events.
local group = vim.api.nvim_create_augroup('NoteStatusVimtex', { clear = true })
vim.api.nvim_create_autocmd('User', {
  group = group,
  pattern = 'VimtexEventCompiling',
  callback = function() M.compiling = true end,
})
vim.api.nvim_create_autocmd('User', {
  group = group,
  pattern = { 'VimtexEventCompileSuccess', 'VimtexEventCompileFailed', 'VimtexEventCompileStopped' },
  callback = function() M.compiling = false end,
})

function M.status()
  if vim.bo.filetype ~= 'tex' then
    return ''
  end

  local pdffile = vim.fn.expand '%:p:h' .. '/build/' .. vim.fn.expand '%:t:r' .. '.pdf'

  if M.compiling then
    return '⏳'
  elseif vim.fn.filereadable(pdffile) == 1 then
    return '✅'
  else
    return '❌'
  end
end

return M
