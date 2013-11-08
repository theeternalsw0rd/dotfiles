"------------------------------------------////
"	    VIM CONFIGURATION		
"------------------------------------------////
" located on ~/.vimrc

scriptencoding utf-8
set nocompatible   " Disable vi-compatibility
"set laststatus=2   " Always show the statusline
set t_Co=256 " Explicitly tell vim that the terminal supports 256 colors
set encoding=utf-8 " Necessary to show unicode glyphs
set list
set listchars=trail:·,precedes:«,extends:»,eol:¬,tab:▸\ 
let mapleader=","
set backspace=indent,eol,start
set tabpagemax=50
"------------------------------------------////
"               Mouse
"------------------------------------------////
set mouse=a
set ttymouse=xterm2
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>

"------------------------------------------////
"		Plugins		
"------------------------------------------////
"pathogen plugin -- https://github.com/tpope/vim-pathogen
call pathogen#infect()			" include all plugins in bundle folder
call pathogen#helptags()		" include helppage for vim plugins in bundle folder
" call pathogen#runtime_append_all_bundles()

filetype plugin indent on		" enable detection, plugin, indenting
filetype plugin on		" enable detection, plugin, indenting

" override default filetypes
au Bufread,BufNewFile *.zsh-theme set filetype=zsh

python from powerline.bindings.vim import source_plugin; source_plugin()

" protect from security issue
set modelines=0
set nomodeline

"------------------------------------------////
"		Visual		
"------------------------------------------////
syntax on 		" enable color syntax
set number 		" show line numbers relative to current line on left side

set ignorecase 		" ignore case when searching
set hlsearch 		" highlight searches
set incsearch		" increamental search, find as you type word

set title		" show title in console title bar


" magic cursors doesn't work switching panes in tmux

"au VimEnter * silent !~/.scripts/helper/cursor_command.zsh
"au VimLeave * silent !~/.scripts/helper/cursor_insert.zsh
"au InsertEnter * silent !~/.scripts/helper/cursor_insert.zsh
"au InsertLeave * silent !~/.scripts/helper/cursor_command.zsh
"let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
"let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"

"set mouse-=a		" disable mouse automatically entering visual mode
"set mouse=a		" enable mouse support and activate visual mode with dragging

"set clipboard=unnamedplus,autoselect " yank and copy between OS and vim (doesn't work over ssh)


" display highlighted cursor location on idle
"autocmd CursorHold * setlocal cursorline cursorcolumn
"autocmd CursorMoved,InsertEnter *
"    \ if &l:cursorline | setlocal nocursorline nocursorcolumn | endif

"------------------------------------------////
"		Functions
"------------------------------------------////

"------------------------------------------////
"		Hotkey		
"------------------------------------------////

" toggle line numbers 
nmap <C-N><C-N> :set invnumber<CR>
inoremap <s-tab> <c-n>
" toggle paste mode, for issue when pasting
" from GUI to vim
" http://simon.xn--schnbeck-p4a.dk/vim-paste-indent-problems/
set pastetoggle=<F10> " in insert mode, enable pasting

"------------------------------------------////
"		Super Retab	
"------------------------------------------////
" Return indent (all whitespace at start of a line), converted from
" tabs to spaces if what = 1, or from spaces to tabs otherwise.
" When converting to tabs, result has no redundant spaces.
function! Indenting(indent, what, cols)
  let spccol = repeat(' ', a:cols)
  let result = substitute(a:indent, spccol, '\t', 'g')
  let result = substitute(result, ' \+\ze\t', '', 'g')
  if a:what == 1
    let result = substitute(result, '\t', spccol, 'g')
  endif
  return result
endfunction

" Convert whitespace used for indenting (before first non-whitespace).
" what = 0 (convert spaces to tabs), or 1 (convert tabs to spaces).
" cols = string with number of columns per tab, or empty to use 'tabstop'.
" The cursor position is restored, but the cursor will be in a different
" column when the number of characters in the indent of the line is changed.
function! IndentConvert(line1, line2, what, cols)
  let savepos = getpos('.')
  let cols = empty(a:cols) ? &tabstop : a:cols
  execute a:line1 . ',' . a:line2 . 's/^\s\+/\=Indenting(submatch(0), a:what, cols)/e'
  call histdel('search', -1)
  call setpos('.', savepos)
endfunction
command! -nargs=? -range=% Space2Tab call IndentConvert(<line1>,<line2>,0,<q-args>)
command! -nargs=? -range=% Tab2Space call IndentConvert(<line1>,<line2>,1,<q-args>)
command! -nargs=? -range=% RetabIndent call IndentConvert(<line1>,<line2>,&et,<q-args>)

"------------------------------------------////
"		Themes		
"------------------------------------------////
syntax enable
"set background=dark		" set background dark color
set background=light		" set background light color (this should be called normal)
hi LineNr ctermfg=gray
hi NonText ctermfg=darkgray
hi SpecialKey ctermfg=darkgray

" cursorline highlights the current line and can cause slowdowns in huge files
set cursorline
hi CursorLine cterm=none ctermbg=black

set fillchars+=stl:\ ,stlnc:\

"------------------------------------------////
"		Folding		
"------------------------------------------////
"au BufWinLeave * mkview " causes options to be saved
"au BufWinEnter * silent loadview " causes options to be restored
"set foldmethod=manual	"fold based on manual user input
set foldmethod=indent   "fold based on indent
"set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
"set foldlevel=1         "this is just what i use

"------------------------------------------////
"		FileType specific overrides		
"------------------------------------------////
au FileType javascript call JavaScriptFold()
au BufNewFile,BufReadPost *.sass setl softtabstop=2 shiftwidth=2 expandtab
au BufNewFile,BufReadPost *.coffee setl softtabstop=2 shiftwidth=2 expandtab
au BufNewFile,BufReadPost *.haml setl softtabstop=2 shiftwidth=2 expandtab
