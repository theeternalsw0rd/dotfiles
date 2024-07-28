return {
  "folke/tokyonight.nvim",
  priority = 1000,
  config = function()
    if vim.env.TERM == "linux" then
      require("tokyonight").setup({
        style = "night",
      })
    else
      require("tokyonight").setup({
        transparent = true,
        style = "night",
        on_highlights = function(highlights, colors)
          highlights.AlphaHeader = { fg = colors.purple }
        end,
        styles = {
          sidebars = "transparent",
          floats = "transparent"
        }
      })
    end
    vim.cmd("colorscheme tokyonight")
  end
}
