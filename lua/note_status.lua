local M = {}
M.last_compile = 0

function M.status()
  if vim.bo.filetype ~= 'tex' then
    return ''
  end

  local texfile = vim.fn.expand '%:p'
  local pdffile = vim.fn.expand '%:p:h' .. '/build/' .. vim.fn.expand '%:t:r' .. '.pdf'
  local compiling = vim.g['vimtex#compiler#status'] or 0

  if compiling == 1 then
    M.last_compile = os.time()
    return '⏳'
  elseif vim.fn.filereadable(pdffile) == 1 then
    return '✅'
  elseif os.time() - M.last_compile <= 2 then
    -- Show compiling icon briefly even if VimTeX finished
    return '⏳'
  else
    return '❌'
  end
end

return M
