return {
  {
    'lervag/vimtex',
    lazy = false,
    init = function()
      -- ==============================
      -- Basic VimTeX settings
      -- ==============================
      vim.g.vimtex_compiler_method = 'latexmk'
      vim.g.vimtex_view_method = 'zathura' -- PDF viewer
      vim.g.vimtex_view_automatic = 0 -- disable default auto-open
      vim.g.tex_conceal = 'abdmg'
      vim.g.tex_flavor = 'latex'
      vim.g.vimtex_syntax_conceal = {
        accents = true,
        ligatures = true,
        cites = true,
        fancy = true,
        spacing = true,
        greek = true,
        math_bounds = true,
        math_delimiters = true,
        math_fracs = true,
        math_super_sub = true,
        math_symbols = true,
        sections = true,
        styles = true,
      }

      -- ==============================
      -- Compiler setup with build folder
      -- ==============================
      vim.g.vimtex_compiler_latexmk = {
        executable = 'latexmk',
        options = {
          '-pdf',
          '-shell-escape',
          '-outdir=build', -- per-note build folder
          '-verbose',
          '-file-line-error',
          '-interaction=nonstopmode',
        },
      }

      -- ==============================
      -- Custom PDF open after compile (for -outdir=build)
      -- ==============================
      vim.cmd [[
augroup VimtexBuildDir
  autocmd!
  autocmd User VimtexEventCompileSuccess lua require('vimtex_build_pdf').open_pdf()
augroup END
]]
      vim.g.vimtex_view_general_options = function()
        local texfile = vim.fn.expand '%:p'
        local pdffile = vim.fn.expand '%:p:h' .. '/build/' .. vim.fn.expand '%:t:r' .. '.pdf'
        return '--synctex-forward @line:@col:' .. texfile .. ' ' .. pdffile
      end
    end,
  },

  vim.api.nvim_set_keymap('n', '<leader>lv', [[:lua require('vimtex_build_pdf').open_pdf()<CR>]], { noremap = true, silent = true }),
}
