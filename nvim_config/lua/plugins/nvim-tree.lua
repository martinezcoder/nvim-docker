return function()
  require('nvim-tree').setup {
    view = {
      width = 35,
      side = 'left',
    },
    renderer = {
      group_empty = true,
    },
    filters = {
      dotfiles = false,
    },
  }
  -- Keymap to toggle nvim-tree with Ctrl+n
  vim.keymap.set('n', '<leader>n', ':NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
  vim.keymap.set('n', '<Leader>++', ":NvimTreeResize +5<CR>", { desc = 'Resize Tree +5' })
  vim.keymap.set('n', '<Leader>--', ":NvimTreeResize -5<CR>", { desc = 'Resize Tree -5' })
end
