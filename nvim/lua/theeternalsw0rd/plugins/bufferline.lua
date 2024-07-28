return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  opts = {
    highlights = {
      buffer_selected = {
        bold = true,
        italic = false,
      },
    },
    options = {
      mode = "tabs",
      separator_style = {" ", " "},
      indicator = {
        style = "underline",
      },
      middle_mouse_command = "bdelete! %d",
    },
  },
}
