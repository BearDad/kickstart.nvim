return {
  {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_general_viewer = ""
      vim.g.vimtex_view_general_options = ""
      vim.g.vimtex_view_method = ""
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_view_general_options = '--unique file:@pdf""#src:@line@tex'
      vim.g.tex_conceal = "abdmg"
      vim.g.tex_flavor = "latex"
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
    end,
  },
}
