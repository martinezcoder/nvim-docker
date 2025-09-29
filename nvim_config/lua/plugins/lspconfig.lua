return function()
  vim.lsp.config("lua_ls", {
    settings = {
      Lua = {
        diagnostics = { globals = { 'vim' } },
      },
    },
  })

  vim.lsp.config("solargraph", {
    cmd = { "solargraph", "stdio" }, -- Use the Mason/global binary, not bundle exec
    settings = {
      solargraph = {
        diagnostics = false,
        completion = true,
        formatting = true,
      }
    }
  })

  vim.lsp.config("standardrb", {
    settings = {
      diagnostics = false,
    }
  })

  vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float)
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

  -- Unfortunately, we need to disable all diagnostics in the worst brave way...
  -- In Ruby projects, it is showing rubocop issues and not only the ones from the local configuration
  -- This has the consequence that no ther diagnostics are shown.
  -- If you open :LspInfo in a ruby file, you will see that there are many instances of _standardrb_ and
  -- not all of them has the `diagnostics = false`. I couldn't find a solution for this.
  vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, method, params, client_id, bufnr, config)
    return
  end
end
