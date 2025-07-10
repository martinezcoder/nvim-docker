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