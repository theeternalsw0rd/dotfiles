"------------------------------------------////
"	    VIM CONFIGURATION		
"------------------------------------------////
" located on ~/.vimrc

scriptencoding utf-8
set encoding=utf-8
set listchars=trail:·,precedes:«,extends:»,eol:↲,tab:▸\ 

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

"vim powerline
set nocompatible   " Disable vi-compatibility
"set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show unicode glyphs
set t_Co=256 " Explicitly tell vim that the terminal supports 256 colors

" protect from security issue
set modelines=0

"------------------------------------------////
"		Visual		
"------------------------------------------////
syntax on 		" enable color syntax
set number 		" show line numbers relative to current line on left side

set ignorecase 		" ignore case when searching
set hlsearch 		" highlight searches
set incsearch		" increamental search, find as you type word

set title		" show title in console title bar


" I only use vim in xterm compatible terminals so set underscore and block
" cursors
let &t_SI .= "\<Esc>[4 q"
let &t_EI .= "\<Esc>[2 q"

"set mouse-=a		" disable mouse automatically entering visual mode
"set mouse=a		" enable mouse support and activate visual mode with dragging

"set clipboard=unnamedplus,autoselect " yank and copy between OS and vim (doesn't work over ssh)


" display highlighted cursor location on idle
"autocmd CursorHold * setlocal cursorline cursorcolumn
"autocmd CursorMoved,InsertEnter *
"    \ if &l:cursorline | setlocal nocursorline nocursorcolumn | endif


"------------------------------------------////
"		Hotkey		
"------------------------------------------////

" toggle line numbers 
nmap <C-N><C-N> :set invnumber<CR>

" toggle paste mode, for issue when pasting
" from GUI to vim
" http://simon.xn--schnbeck-p4a.dk/vim-paste-indent-problems/
set pastetoggle=<F10> " in insert mode, enable pasting




"------------------------------------------////
"		Themes		
"------------------------------------------////
syntax enable
"set background=dark		" set background dark color
set background=light		" set background light color (this should be called normal)
hi LineNr ctermfg=gray

" cursorline highlights the current line and can cause slowdowns in huge files
set cursorline
hi CursorLine cterm=none ctermbg=black

"------------------------------------------////
"		Folding		
"------------------------------------------////
au BufWinLeave * mkview
au BufWinEnter * silent loadview
"set foldmethod=manual	"fold based on manual user input
"set foldmethod=indent   "fold based on indent
"set foldnestmax=10      "deepest fold is 10 levels
"set nofoldenable        "dont fold by default
"set foldlevel=1         "this is just what i use
