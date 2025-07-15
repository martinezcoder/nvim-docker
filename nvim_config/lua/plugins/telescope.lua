return function()
  local builtin = require('telescope.builtin')
  require('telescope').setup {
    defaults = {
      file_ignore_patterns = { "node_modules", ".git" },
    },
  }

  -- Keymaps for Telescope
  vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })
  vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = '[ ] Find existing buffers' })
  vim.keymap.set('n', '<leader>/', function()
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      -- previewer = false,
    })
  end, { desc = '[/] Fuzzily search in current buffer]' })
end
