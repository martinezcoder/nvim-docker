return function()
  require('lspconfig').lua_ls.setup {
    settings = {
      Lua = {
        diagnostics = { globals = { 'vim' } },
      },
    },
  }

  require('lspconfig').solargraph.setup {
    cmd = { "solargraph", "stdio" }, -- Use the Mason/global binary, not bundle exec
    settings = {
      solargraph = {
        diagnostics = true,
        completion = true,
        formatting = true,
        rubocop = false, -- Rubocop is managed by none-ls plugin
      }
    }
  }

  vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float)
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
end
