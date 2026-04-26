return {
  'atiladefreitas/dooing',
  config = function()
    require('dooing').setup {
      -- Core settings
      save_path = vim.fn.stdpath 'data' .. '/dooing_todos.json',

      -- Window appearance
      window = {
        width = 80, -- Width of the floating window
        height = 20, -- Height of the floating window
        border = 'rounded', -- Border style
      },

      -- Icons
      icons = {
        pending = '○', -- Pending todo icon
        done = '✓', -- Completed todo icon
      },

      -- Keymaps
      keymaps = {
        toggle_window = '<leader>td', -- Toggle the main window
        new_todo = 'i', -- Add a new todo
        toggle_todo = 'x', -- Toggle todo status
        delete_todo = 'd', -- Delete the current todo
        delete_completed = 'D', -- Delete all completed todos
        close_window = 'q', -- Close the window
        add_due_date = 'h', -- Add due date to todo
        remove_due_date = 'r', -- Remove due date from todo
        toggle_help = '?', -- Toggle help window
        toggle_tags = 't', -- Toggle tags window
        clear_filter = 'c', -- Clear active tag filter
        edit_todo = 'e', -- Edit todo item
        edit_tag = 'e', -- Edit tag [on tag window]
        delete_tag = 'd', -- Delete tag [on tag window]
        search_todo = '/', -- Toggle todo searching
        toggle_priority = '<Space>', -- Toggle todo priority on creation
      },

      prioritization = true,
      priorities = { -- Defines priorities one can assign to tasks
        {
          name = 'important',
          weight = 4, -- Weight of each priority. E.g. here, `important` is ranked higher than `urgent`.
        },
        {
          name = 'urgent',
          weight = 2,
        },
        {
          name = 'low',
          weight = 0,
        },
      },
      priority_thresholds = {
        {
          min = 5, -- Corresponds to `urgent` and `important` tasks
          max = 999,
          color = nil, --this is not yet implemented
          hl_group = 'DiagnosticError',
        },
        {
          min = 3, -- Corresponds to `important` tasks
          max = 4,
          color = nil,
          hl_group = 'DiagnosticWarn',
        },
        {
          min = 1, -- Corresponds to `urgent tasks`
          max = 2,
          color = nil,
          hl_group = 'DiagnosticInfo',
        },
        {
          min = 0, -- Corresponds to `none` tasks
          max = 1,
          color = nil,
          hl_group = 'Diagnostic',
        },
      },

      -- Calendar settings
      calendar = {
        language = 'en', -- Calendar language ("en" or "pt")
        keymaps = {
          previous_day = 'h', -- Move to previous day
          next_day = 'l', -- Move to next day
          previous_week = 'k', -- Move to previous week
          next_week = 'j', -- Move to next week
          previous_month = 'H', -- Move to previous month
          next_month = 'L', -- Move to next month
          select_day = '<CR>', -- Select the current day
          close_calendar = 'q', -- Close the calendar
        },
      },
    }
  end,
}
