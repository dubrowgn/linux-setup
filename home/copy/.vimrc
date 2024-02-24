"" Style/Appearance

" enable syntax highlighting
filetype plugin on
syntax on
set hlsearch
colorscheme tender

" show whitespace
hi Whitespace ctermfg=DarkGray
match Whitespace /\s\|\n/
set list
set listchars=tab:▸\ 

" highlight whitespace at the end of a line
highlight ExtraWhitespace ctermbg=lightgray ctermfg=black
call matchadd('ExtraWhitespace', '\s\+$')

"" Navigation

" press alt+left/right to go to prev/next tag match
map <A-Left> :tprev<CR>
imap <A-Left> <C-o>:tprev<CR>
map <A-Right> :tnext<CR>
imap <A-Right> <C-o>:tnext<CR>

" make ctrl+left/right consistent with insert/visual mode
map <C-Left> b
map <C-Right> w

" viewport nav
map <S-Down> 3<C-E>
imap <S-Down> <C-o>3<C-E>
map <S-Up> 3<C-Y>
imap <S-Up> <C-o>3<C-Y>

map <C-S-Down> 9<C-E>
imap <C-S-Down> <C-o>9<C-E>
map <C-S-Up> 9<C-Y>
imap <C-S-Up> <C-o>9<C-Y>

" cursor nav
map <C-Up> 9k
imap <C-Up> <C-o>9k
map <C-Down> 9j
imap <C-Down> <C-o>9j

"" Annoyances

" haven't used it yet, often annoying, just turn it off
set noswapfile

" turn off macro recording
map q <nop>

" for the love of god, delete, not cut
nnoremap <bs> "_X
vnoremap <bs> "_X
nnoremap <del> "_x
vnoremap <del> "_x

