-- Personal config: keymaps, UI, options, plugins setup

-------------------------------------------------------------------------------
-- Options
-------------------------------------------------------------------------------
vim.opt.termguicolors = true
vim.opt.conceallevel = 2
vim.opt.fillchars = { eob = ' ' }
vim.wo.relativenumber = true
vim.o.updatetime = 250

-------------------------------------------------------------------------------
-- Kanagawa colorscheme
-------------------------------------------------------------------------------
require('kanagawa').setup {
  compile = false,
  undercurl = true,
  commentStyle = { italic = true },
  functionStyle = {},
  keywordStyle = { italic = true },
  statementStyle = { bold = true },
  typeStyle = {},
  transparent = true,
  dimInactive = true,
  terminalColors = true,
  colors = {
    palette = {},
    theme = { wave = {}, lotus = {}, dragon = {}, all = {
      ui = { bg_gutter = 'none' },
    } },
  },
  overrides = function(colors)
    local theme = colors.theme
    return {
      NormalFloat = { bg = 'none' },
      FloatBorder = { bg = 'none' },
      FloatTitle = { bg = 'none' },
      NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
      LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
      MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
      TelescopeTitle = { fg = theme.ui.special, bold = true },
      TelescopePromptNormal = { bg = theme.ui.bg_p1 },
      TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
      TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
      TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
      TelescopePreviewNormal = { bg = theme.ui.bg_dim },
      TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
    }
  end,
  theme = 'dragon',
  background = { dark = 'dragon', light = 'lotus' },
}
vim.cmd 'colorscheme kanagawa'

-- Cursorline highlight override (after colorscheme load)
vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#191724' })

-------------------------------------------------------------------------------
-- Colorizer
-------------------------------------------------------------------------------
require('colorizer').setup {
  filetypes = { '*' },
  user_default_options = {
    names = true,
    RGB = true,
    RRGGBB = true,
    RRGGBBAA = true,
    AARRGGBB = true,
    rgb_fn = true,
    hsl_fn = true,
    css = true,
    css_fn = true,
    mode = 'background',
    tailwind = 'both',
    sass = { enable = true, parsers = { 'css' } },
    virtualtext = '■',
    virtualtext_inline = true,
    virtualtext_mode = 'foreground',
    always_update = true,
  },
  buftypes = {},
  user_commands = true,
}

-------------------------------------------------------------------------------
-- Notify
-------------------------------------------------------------------------------
require('notify').setup {
  render = 'minimal',
  stages = 'fade_in_slide_out',
  top_down = false,
  timeout = 4000,
  merge_duplicates = true,
}
vim.keymap.set('n', '<leader>fn', '<cmd>Telescope notify<cr>', { desc = 'Find notifications' })

-------------------------------------------------------------------------------
-- Supermaven
-------------------------------------------------------------------------------
require('supermaven-nvim').setup {
  keymaps = {
    accept_suggestion = '<C-s>',
    clear_suggestion = '<C-]>',
    accept_word = '<C-j>',
  },
  color = {
    suggestion_color = '#c4a7e7',
    cterm = 244,
  },
  log_level = 'info',
  disable_inline_completion = false,
  disable_keymaps = false,
  condition = function()
    return false
  end,
}

-------------------------------------------------------------------------------
-- Diagnostic config
-------------------------------------------------------------------------------
vim.diagnostic.config {
  float = {
    border = 'none',
    header = '',
    prefix = '',
    source = false,
  },
}

vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
  desc = 'Auto open diagnostic float on CursorHold',
})

-------------------------------------------------------------------------------
-- VimTeX
-------------------------------------------------------------------------------
vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_compiler_method = 'latexmk'

-------------------------------------------------------------------------------
-- Keymaps
-------------------------------------------------------------------------------

-- UI
vim.opt.guicursor = 'n-v-c:block,i-ci-ve:hor1-blinkon0'
vim.keymap.set('n', '<leader>ee', '<cmd>Telescope emoji<cr>', { desc = 'Search emoji' })
vim.keymap.set('n', '<leader>n', '<cmd>NerdIcons<cr>', { desc = 'Open NerdIcons' })

-- Close command window immediately
vim.cmd [[autocmd CmdwinEnter * q]]

-- Clipboard
vim.keymap.set({ 'n', 'v' }, '<C-p>', '"*p', { desc = 'Paste from selection clipboard' })
vim.keymap.set({ 'n', 'v' }, 'p', '"+p', { desc = 'Paste from system clipboard' })

-- Treesitter toggle
vim.keymap.set({ 'v', 'n' }, '<leader>tt', '<cmd>TSBufToggle highlight<cr>', { desc = 'Toggle treesitter highlighting' })

-- Swap ; and :
vim.keymap.set({ 'n', 'v', 'x' }, ';', ':')
vim.keymap.set({ 'n', 'v', 'x' }, ':', ';')

-- Substitute shortcut
vim.keymap.set({ 'x', 'n' }, '<C-s>', [[<esc>:'<,'>s/]], { desc = 'Enter substitute mode' })

-- Better j/k on wrapped lines
vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

-- Move lines
vim.keymap.set('n', '<A-j>', "<cmd>execute 'move .+' . v:count1<cr>==", { desc = 'Move line down' })
vim.keymap.set('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move line down' })
vim.keymap.set('v', '<A-j>', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('n', '<A-k>', "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = 'Move line up' })
vim.keymap.set('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move line up' })
vim.keymap.set('v', '<A-k>', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = 'Move selection up' })

-- Better indenting
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Comments
vim.keymap.set('n', 'gco', 'o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = 'Add comment below' })
vim.keymap.set('n', 'gcO', 'O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = 'Add comment above' })

-- Window management
vim.keymap.set('n', '<leader>w', '<c-w>', { desc = 'Windows', remap = true })
vim.keymap.set('n', '<leader>-', '<C-W>s', { desc = 'Split window below', remap = true })
vim.keymap.set('n', '<leader>|', '<C-W>v', { desc = 'Split window right', remap = true })
vim.keymap.set('n', '<leader>wd', '<C-W>c', { desc = 'Delete window', remap = true })

-- Native snippets (Neovim < 0.11)
if vim.fn.has 'nvim-0.11' == 0 then
  vim.keymap.set('s', '<Tab>', function()
    return vim.snippet.active { direction = 1 } and '<cmd>lua vim.snippet.jump(1)<cr>' or '<Tab>'
  end, { expr = true, desc = 'Jump next snippet' })
  vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
    return vim.snippet.active { direction = -1 } and '<cmd>lua vim.snippet.jump(-1)<cr>' or '<S-Tab>'
  end, { expr = true, desc = 'Jump prev snippet' })
end

-- IncRename
vim.keymap.set('n', '<leader>cr', function()
  return ':IncRename ' .. vim.fn.expand '<cword>'
end, { expr = true, desc = 'IncRename' })
