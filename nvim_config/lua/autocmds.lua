-- Show line numbers everywhere except in nvim-tree
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    if vim.bo.filetype ~= "NvimTree" then
      vim.opt_local.number = true
    else
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
    end
  end,
})

-- Always open all folds when opening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    vim.cmd("normal! zR")
  end,
})

-- Highliht the text that was yanked, like when you use 'yy' or 'y' in visual mode
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 200 }
  end,
})

-- Close certain windows with "q"
vim.api.nvim_create_autocmd("FileType", {
 pattern = {
  "help",
  "startuptime",
  "qf",
  "lspinfo",
  "neotest-output",
  "neotest-attach",
  },
  command = [[nnoremap <buffer><silent> q :close<CR>]],
})

local focus_filetypes = {
  help = true,
  startuptime = true,
  qf = true,
  lspinfo = true,
  ["neotest-output"] = true,
  ["neotest-attach"] = true,
}

-- Keep focus on specific filetypes when entering a window
vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    vim.defer_fn(function()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local ft = vim.api.nvim_buf_get_option(buf, "filetype")
        if focus_filetypes[ft] then
          vim.api.nvim_set_current_win(win)
          break
        end
      end
    end, 30) -- some miliseconds delay to ensure the window is ready
  end,
})
