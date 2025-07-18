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

  -- Run current test in terminal split. This is useful when we have "binding.pry" in the test
  vim.keymap.set("n", "<Leader>tp", function()
    local filename = vim.fn.expand("%")
    local line = vim.fn.line(".")
    local cmd = string.format("bundle exec rspec %s:%d", filename, line)

    vim.cmd("botright 15split")
    vim.cmd("terminal " .. cmd)
    vim.cmd("startinsert")
  end, { desc = "Run current test in terminal split" })

  -- Run ALL file tests in terminal split
  vim.keymap.set("n", "<Leader>tP", function()
    local filename = vim.fn.expand("%")
    local cmd = string.format("bundle exec rspec %s", filename)

    vim.cmd("botright 15split")
    vim.cmd("terminal " .. cmd)
    vim.cmd("startinsert")
  end, { desc = "Run current test in terminal split" })
end
