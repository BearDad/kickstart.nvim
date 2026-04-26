return {
  'ImmanuelHaffner/pigmentor.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  ft = { 'tex', 'latex' },
  config = function()
    require('pigmentor').setup {
      enabled = true, -- Double-check this is true
      display = {
        style = 'hybrid', -- Try 'highlight' if inline fails (colors the text itself)
        inactive = true, -- Show in split windows too
        inline = {
          text_post = '●', -- The swatch dot
          inverted = false, -- No bg swap
        },
      },
      modes = {
        n = { cursor = true, line = true, visible = true }, -- Normal mode: full visibility
        i = { cursor = true, line = true, visible = true }, -- Insert mode: enable cursor/line for real-time under-cursor swatches
      },
      colormatchers = {
        latex = {
          -- Add a pattern for color names in commands like \cellcolor{name}
          pattern = '\\(cellcolor|color|textcolor)%s*%{([^}]+)}', -- Matches {name} arg
          resolver = function(match)
            -- Simple: If it's a known standard, resolve; else fallback to text highlight
            local name = match:match '([^}]+)'
            if name:match '!' or vim.tbl_contains({ 'red', 'blue', 'gray' }, name) then -- Extend list of standards
              return name -- Pigmentor will try to resolve
            end
            return nil -- No preview
          end,
        },
      },
    }
  end,
}
