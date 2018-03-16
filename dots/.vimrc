set tabstop=2
set expandtab
set shiftwidth=2
set number

execute pathogen#infect()
syntax on
hi EndOfBuffer ctermfg=black ctermbg=NONE
filetype plugin indent on

let g:AutoPairsShortcutFastWrap = 'æ'
let g:user_emmet_mode='a'
let g:user_emmet_leader_key='<C-E>'

" auto remove trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

let mapleader=" "
map <Leader>w :w<Enter>
map <Leader>q :q<Enter>

" move between tabs with <leader>+tab_index
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>

noremap <C-p> :Files<Enter>
nnoremap <C-j> :tabprevious<CR>
nnoremap <C-k> :tabnext<CR>

