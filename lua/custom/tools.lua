-- Tools: Zettelkasten, Inkscape, Arduino, Dart, Spell checking

-- Filetype association for Arduino sketches
vim.filetype.add { extension = { ino = 'cpp' } }

-- Arduino keymaps
vim.keymap.set('n', '<leader>aa', '<cmd>ArduinoAttach<cr>', { desc = 'Arduino: attach to a device' })
vim.keymap.set('n', '<leader>av', '<cmd>ArduinoVerify<cr>', { desc = 'Arduino: verify a sketch' })
vim.keymap.set('n', '<leader>au', '<cmd>ArduinoUpload<cr>', { desc = 'Arduino: upload a sketch' })
vim.keymap.set('n', '<leader>aU', '<cmd>ArduinoUploadAndSerial<cr>', { desc = 'Arduino: upload and open serial monitor' })
vim.keymap.set('n', '<leader>as', '<cmd>ArduinoSerial<cr>', { desc = 'Arduino: open serial monitor' })
vim.keymap.set('n', '<leader>ab', '<cmd>ArduinoChooseBoard<cr>', { desc = 'Arduino: choose board' })
vim.keymap.set('n', '<leader>ap', '<cmd>ArduinoChooseProgrammer<cr>', { desc = 'Arduino: choose programmer' })

-- Dart: auto hot reload on save
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*.dart',
  callback = function()
    local ok, flutter_tools = pcall(require, 'flutter-tools')
    if ok then
      flutter_tools.reload()
    end
  end,
  desc = 'Flutter: hot reload on save',
})

-- Spell checking (global — remove vim.opt_local if you want per-buffer only)
vim.opt.spell = true
vim.opt.spelllang = { 'es', 'en_us' }

vim.keymap.set({ 'i', 'n' }, '<C-j>', function()
  vim.cmd 'stopinsert'
  vim.cmd 'normal! ma[s1z=`a'
end, { noremap = true, silent = true, desc = 'Fix nearest spelling error' })

-------------------------------------------------------------------------------
-- Zettelkasten: numbered LaTeX notes
-------------------------------------------------------------------------------
vim.keymap.set('n', '<leader>nn', function()
  local name = vim.fn.input 'Note name: '
  if name == '' then
    print 'Aborted'
    return
  end
  name = string.lower(name):gsub('%s+', '-'):gsub('[^%w%-]', '')

  local date = os.date '%Y-%m-%d'
  local cwd = vim.fn.getcwd()

  local base_dir = cwd
  if vim.fn.isdirectory(cwd .. '/chapters') == 1 then
    base_dir = cwd .. '/chapters'
  elseif #vim.fn.glob(cwd .. '/*.tex', false, true) > 0 then
    base_dir = vim.fn.fnamemodify(cwd, ':h')
    print('Inside existing note → using parent:', base_dir)
  end

  local function get_highest_number()
    local highest = 0
    local folders = vim.fn.systemlist {
      'find', base_dir, '-type', 'd', '-name', '[0-9][0-9][0-9]-*',
      '-exec', 'basename', '{}', ';',
    }
    for _, foldername in ipairs(folders) do
      local num = foldername:match '^(%d%d%d)%-'
      if num then
        local n = tonumber(num)
        if n > highest then highest = n end
      end
    end
    return highest
  end

  local next_num = get_highest_number() + 1
  local num_str = string.format('%03d', next_num)

  local folder = base_dir .. '/' .. num_str .. '-' .. date .. '-' .. name
  local texfile = folder .. '/' .. num_str .. '-' .. date .. '-' .. name .. '.tex'
  local template = vim.fn.expand '~/git/Clase/template/template.tex'

  vim.fn.mkdir(folder, 'p')

  if vim.fn.filereadable(texfile) == 0 then
    if vim.fn.filereadable(template) == 1 then
      vim.fn.system { 'cp', template, texfile }
      print('Created → ' .. texfile)
    else
      vim.fn.writefile({
        '\\documentclass{article}',
        '\\begin{document}',
        '\\title{' .. name .. '}',
        '\\date{' .. date .. '}',
        '\\maketitle',
        '',
        '\\end{document}',
      }, texfile)
      print('Created minimal → ' .. texfile)
    end
  end

  vim.cmd.edit(vim.fn.fnameescape(texfile))
end, { desc = 'Zettel: new numbered note' })

-------------------------------------------------------------------------------
-- Inkscape integration (Telescope fuzzy search)
-------------------------------------------------------------------------------
local has_telescope, _ = pcall(require, 'telescope')
if not has_telescope then
  vim.notify('Inkscape integration requires Telescope', vim.log.levels.WARN)
  return
end

local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values

local function git_root()
  local file_dir = vim.fn.expand '%:p:h'
  local cmd = string.format('cd %s && git rev-parse --show-toplevel 2>/dev/null', vim.fn.shellescape(file_dir))
  local result = vim.fn.systemlist(cmd)[1]
  if result and result ~= '' then return result end
  return nil
end

local function spawn_inkscape(file_path)
  local script_path = vim.fn.expand '~/.config/nvim/inkscape_move_dynamic.sh'
  vim.fn.jobstart({ script_path, file_path }, { detach = true })
end

local function insert_incfig(filename)
  vim.ui.input({ prompt = 'Enter size for \\incfig[size]{file} (0 < size <= 1): ' }, function(size)
    if not size or size == '' then return end
    local num = tonumber(size)
    if not num or num <= 0 or num > 1 then
      print 'Invalid size! Must be >0 and <=1'
      return
    end
    local line = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(0, line, line, true, { string.format('\\incfig[%s]{%s}', num, filename) })
  end)
end

local function open_or_create_inkscape_svg()
  local repo_root = git_root() or vim.fn.getcwd()
  repo_root = repo_root:gsub('\27%[[%d;]*[A-Za-z]', ''):gsub('%c', ''):gsub('^%s+', ''):gsub('%s+$', '')

  local images_dir = repo_root .. '/images'
  vim.fn.mkdir(images_dir, 'p')

  local svg_files = vim.fn.globpath(images_dir, '*.svg', false, true)
  local filenames = {}
  for _, path in ipairs(svg_files) do
    table.insert(filenames, vim.fn.fnamemodify(path, ':t:r'))
  end
  table.insert(filenames, '▶ New file')

  pickers.new({}, {
    prompt_title = 'Select or create SVG',
    finder = finders.new_table { results = filenames },
    sorter = conf.generic_sorter {},
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        local template_path = vim.fn.expand '~/git/Clase/templates-inkscape/cross.svg'
        if not selection then return end

        if selection[1] == '▶ New file' then
          vim.ui.input({ prompt = 'Enter new SVG file name: ' }, function(input)
            if not input or input == '' then return end
            local file_path = images_dir .. '/' .. input .. '.svg'
            vim.fn.system { 'cp', template_path, file_path }
            spawn_inkscape(file_path)
            insert_incfig(input)
          end)
        else
          local filename = selection[1]
          local file_path = images_dir .. '/' .. filename .. '.svg'
          local options = {
            'Open in Inkscape + insert \\incfig',
            'Insert \\incfig only',
            'Open in Inkscape only (edit, no insert)',
            'Do nothing',
          }
          vim.ui.select(options, { prompt = 'File exists, choose action:' }, function(opt)
            if not opt then return end
            if opt == 'Open in Inkscape + insert \\incfig' then
              spawn_inkscape(file_path)
              insert_incfig(filename)
            elseif opt == 'Insert \\incfig only' then
              insert_incfig(filename)
            elseif opt == 'Open in Inkscape only (edit, no insert)' then
              spawn_inkscape(file_path)
            end
          end)
        end
      end)
      return true
    end,
  }):find()
end

vim.keymap.set('n', '<leader>i', open_or_create_inkscape_svg, { desc = 'Inkscape: open/create SVG + insert \\incfig' })

-- Auto-export SVG → PDF + PDF_TeX on save
-- TODO: this autocmd does not currently export correctly, needs fixing
local repo_root = git_root() or vim.fn.getcwd()
local images_dir = repo_root .. '/images'

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*.svg',
  callback = function(args)
    local svg_file = args.file
    if svg_file:sub(1, #images_dir) == images_dir then
      local pdf_file = svg_file:gsub('%.svg$', '.pdf')
      vim.fn.jobstart {
        'inkscape', svg_file,
        '--export-type=pdf',
        '--export-latex',
        '--export-filename=' .. pdf_file,
      }
    end
  end,
  desc = 'Inkscape: auto-export SVG to PDF + PDF_TeX on save',
})
