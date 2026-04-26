-- ~/.config/nvim/lua/vimtex_build_pdf.lua
local M = {}

function M.open_pdf()
  local texfile = vim.fn.expand '%:p'
  local pdffile = vim.fn.expand '%:p:h' .. '/build/' .. vim.fn.expand '%:t:r' .. '.pdf'
  if vim.fn.filereadable(pdffile) == 1 then
    vim.fn.jobstart({
      'zathura',
      '--synctex-forward',
      vim.fn.line '.' .. ':' .. vim.fn.col '.' .. ':' .. texfile,
      pdffile,
    }, { detach = true })
  else
    vim.notify('PDF not found: ' .. pdffile, vim.log.levels.WARN)
  end
end

return M
