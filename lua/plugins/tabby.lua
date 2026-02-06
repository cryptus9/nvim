return {
  'nanozuki/tabby.nvim',
  config = function()
    require('tabby.tabline').use_preset('active_wins_at_tail', {
      theme = {
        fill = 'TabLineFill',       -- The background color
        head = 'TabLine',           -- The left-side label
        current_tab = 'TabLineSel', -- The active tab highlight
        tab = 'TabLine',            -- Inactive tabs
        win = 'TabLine',            -- Individual windows
        tail = 'TabLine',           -- The right-side label
      },
      option = {
        lualine_theme = nil,       -- Set this if you want to sync with lualine
        tab_name = {
          name_fallback = function(tabid)
            return 'Tab ' .. tabid
          end,
        },
      },
    })
  end
  }
