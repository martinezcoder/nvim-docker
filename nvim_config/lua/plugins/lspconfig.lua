return function()
  require('lspconfig').lua_ls.setup {
    settings = {
      Lua = {
        diagnostics = { globals = { 'vim' } },
      },
    },
  }
  vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float)
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
end
