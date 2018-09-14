" enable syntax highlighting
filetype plugin on
syntax on
set hlsearch

" highlight whitespace at the end of a line
highlight ExtraWhitespace ctermbg=lightgray ctermfg=black guibg=lightgray guifg=black
call matchadd('ExtraWhitespace', '\s\+$')

" press alt+left/right to go to prev/next tag match
map <A-Left> :tprev<CR><CR>
map <A-Right> :tnext<CR><CR>

" make ctrl+left/right consistent with visual mode
map <C-Left> b
map <C-Right> w

" show whitespace
hi Whitespace ctermfg=DarkGray
match Whitespace /\s\|\n/
set list
set listchars=tab:▸\ ,space:·,eol:¬

" copy/paste via system clipboard
map <C-c> "+y
map <C-v> "+p
