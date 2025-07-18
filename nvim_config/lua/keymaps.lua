-- Telescope keymaps (all start with 's' for search)
vim.keymap.set('n', '<leader>sf', '<cmd>Telescope find_files<cr>', { desc = 'Search Files' })
vim.keymap.set('n', '<leader>sg', '<cmd>Telescope live_grep<cr>', { desc = 'Search by Grep' })
vim.keymap.set('n', '<leader>sb', '<cmd>Telescope buffers<cr>', { desc = 'Search Buffers' })
vim.keymap.set('n', '<leader>sh', '<cmd>Telescope help_tags<cr>', { desc = 'Search Help' })

-- Next keymaps resolves a very specific use case of my setup (a US keyboard layout with a Spanish locale).

-- Insert '<' in insert mode with 'ññ'
function _G.handle_ce_left()
  vim.api.nvim_feedkeys("<", "n", true)
end

-- Insert '>' in insert mode with 'çç'
function _G.handle_ce_right()
  vim.api.nvim_input(">")
end

local map = vim.api.nvim_set_keymap
local options = { noremap = true }
map('i', 'çç', [[<Esc>:lua handle_ce_right()<CR>a]], options)
map('i', 'ññ', [[<Esc>:lua handle_ce_left()<CR>a]], options) 

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
