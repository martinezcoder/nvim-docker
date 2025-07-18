-- Plugin manager setup using lazy.nvim
-- This file ensures lazy.nvim is installed and sets up plugins

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = require('plugins.tokyonight'),
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = require('plugins.treesitter'),
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
    config = require('plugins.lualine'),
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = require('plugins.telescope'),
  },
  {
    'williamboman/mason.nvim',
    config = require('plugins.mason'),
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = require('plugins.mason-lspconfig'),
  },
  {
    'neovim/nvim-lspconfig',
    config = require('plugins.lspconfig'),
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = require('plugins.cmp'),
  },
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = require('plugins.nvim-tree'),
  },
  {
    'lewis6991/gitsigns.nvim',
    config = require('plugins.gitsigns'),
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    opts = require('plugins.ibl'),
  },
  {
    'hrsh7th/cmp-buffer',
  },
  {
    'hrsh7th/cmp-path',
  },
  {
    'hrsh7th/cmp-cmdline',
  },
  {
    'hrsh7th/cmp-nvim-lua',
  },
  {
    'nvimtools/none-ls.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = require('plugins.null-ls'),
  },
  {
    'github/copilot.vim',
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "olimorris/neotest-rspec",
    },
    config = require('plugins.neotest'),
  },
})
