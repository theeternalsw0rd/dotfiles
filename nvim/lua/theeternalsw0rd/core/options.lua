vim.g.netrw_liststyle = 3

local opt = vim.opt

opt.relativenumber = false
opt.number = true

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

opt.wrap = true

-- visualize whitespace
opt.list = true
local space = '·'
opt.listchars = {
  trail = space,
  lead = space,
  multispace = space,
  precedes = '',
  extends = '',
  eol = '󰌑',
  tab = '󰌒 '
}
-- selection
opt.virtualedit = { "block", "onemore" } -- when selecting to end of the line include last character visually in selection

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if search term is mixed-case assume case-sensitive

opt.cursorline = true -- highlight current line

-- theming
opt.termguicolors = true
opt.background = "dark" -- make theme dark mode
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical to the right
opt.splitbelow = true -- split horizontal to the bottom


