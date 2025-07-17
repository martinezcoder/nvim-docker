return function()
  require('gitsigns').setup {
    current_line_blame = true, -- Show git blame for current line
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol', -- Show at end of line
      delay = 500,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  }

  -- Keymap to show full git blame for current line
  vim.keymap.set('n', '<leader>gb', function()
    require('gitsigns').blame_line { full = true }
  end, { desc = 'Show full git blame for current line' })
end
