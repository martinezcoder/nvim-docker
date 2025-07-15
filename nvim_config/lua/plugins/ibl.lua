-- indent-blankline (ibl) rainbow configuration 
-- https://github.com/lukas-reineke/indent-blankline.nvim

local function set_rainbow_highlights()
  vim.api.nvim_set_hl(0, "RainbowRed",    { fg = "#E06C75" })
  vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
  vim.api.nvim_set_hl(0, "RainbowBlue",   { fg = "#61AFEF" })
  vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
  vim.api.nvim_set_hl(0, "RainbowGreen",  { fg = "#98C379" })
  vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
  vim.api.nvim_set_hl(0, "RainbowCyan",   { fg = "#56B6C2" })
end

set_rainbow_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = set_rainbow_highlights,
})

return {
  indent = {
    highlight = {
      "RainbowRed",
      "RainbowYellow",
      "RainbowBlue",
      "RainbowOrange",
      "RainbowGreen",
      "RainbowViolet",
      "RainbowCyan",
    },
  },
  scope = { enabled = false },
}
