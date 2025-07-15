-- Main Neovim configuration file
-- Loads lazy.nvim plugin manager and sets up basic options

-- Set <space> as leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Load lazy.nvim plugin manager
require('lazy_setup')

-- Basic Neovim options (you can expand this later)
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = false -- Show only absolute line numbers
vim.opt.tabstop = 4           -- Number of spaces per tab
vim.opt.shiftwidth = 4        -- Number of spaces for each indentation
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.smartindent = true    -- Smart indentation
vim.opt.termguicolors = true  -- Enable true color support

vim.opt.clipboard = 'unnamedplus' -- Use system clipboard for copy/paste (yy, y, p works in visual mode)

-- Telescope keymaps (all start with 's' for search)
vim.keymap.set('n', '<leader>sf', '<cmd>Telescope find_files<cr>', { desc = 'Search Files' })
vim.keymap.set('n', '<leader>sg', '<cmd>Telescope live_grep<cr>', { desc = 'Search by Grep' })
vim.keymap.set('n', '<leader>sb', '<cmd>Telescope buffers<cr>', { desc = 'Search Buffers' })
vim.keymap.set('n', '<leader>sh', '<cmd>Telescope help_tags<cr>', { desc = 'Search Help' })

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

-- Working with Tabs
vim.keymap.set('n', '<C-e>', ":tabnew<CR>", {})
vim.keymap.set('n', '<C-h>', "gt", {})
vim.keymap.set('n', '<C-c>', ":tabclose<CR>", {})

-- Toggle indent guides (ibl) with <leader>i
local ibl = require('ibl')
local ibl_opts = require('plugins.ibl')
local guides_visible = true

vim.keymap.set('n', '<leader>i', function()
  if guides_visible then
    -- Hide indent guides by setting char to empty string
    ibl.setup(vim.tbl_deep_extend("force", ibl_opts, {
      indent = vim.tbl_deep_extend("force", ibl_opts.indent or {}, { char = "" })
    }))
    guides_visible = false
    vim.notify("Indent guides hidden", vim.log.levels.INFO)
  else
    -- Restore indent guides with rainbow colors
    ibl.setup(ibl_opts)
    guides_visible = true
    vim.notify("Indent guides visible", vim.log.levels.INFO)
  end
end, { desc = "Toggle indent guides (ibl)" })
