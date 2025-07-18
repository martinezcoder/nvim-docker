return function()
  require("neotest").setup({
    adapters = {
      require("neotest-rspec")({
        args = { "--format", "documentation" }
      })
    },
  })

  local map = vim.api.nvim_set_keymap
  local options = { noremap = true }
  map('n', '<Leader>T', ':lua require("neotest").run.run(vim.fn.expand("%"))<CR>', options)
  map('n', '<Leader>tt', ':lua require("neotest").run.run()<CR>', options)
  map('n', '<Leader>to', ':lua require("neotest").output.open()<CR>', options)
  map('n', '<Leader>ta', ':lua require("neotest").run.attach()<CR>', options)
  map('n', '<Leader>ts', ':lua require("neotest").summary.open()<CR>', options)
end
