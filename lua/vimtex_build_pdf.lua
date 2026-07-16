local M = {}

function M.open_pdf()
  local texfile = vim.fn.expand '%:p'
  local pdffile = vim.fn.expand '%:p:h' .. '/build/' .. vim.fn.expand '%:t:r' .. '.pdf'
  if vim.fn.filereadable(pdffile) == 0 then
    vim.notify('PDF not found: ' .. pdffile, vim.log.levels.WARN)
    return
  end

  local forward = vim.fn.line '.' .. ':' .. vim.fn.col '.' .. ':' .. texfile

  -- Forward-search reuses an existing zathura instance if one is open, and
  -- opens a fresh window otherwise. Run detached so Neovim never blocks, and
  -- pass args as a list so paths with spaces are handled safely.
  vim.fn.jobstart({ 'zathura', '--synctex-forward', forward, pdffile }, { detach = true })
end

return M
