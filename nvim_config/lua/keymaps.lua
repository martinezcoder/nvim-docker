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
