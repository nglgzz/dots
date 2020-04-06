"""""""""""""""""""""""""""""""""""
" plug-vim
call plug#begin("~/.cache/nvim/")
  " Plugin Section
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'prettier/vim-prettier', { 'do': 'yarn install', 'branch': 'release/0.x' }
  Plug 'jiangmiao/auto-pairs'
  Plug 'mattn/emmet-vim'
  Plug 'junegunn/fzf.vim'
call plug#end()


"""""""""""""""""""""""""""""""""""
" global
" For better readability
syntax enable
set number

" Tab size
set tabstop=2
set expandtab
set shiftwidth=2

" Nicer colors for EOF
hi EndOfBuffer ctermfg=black ctermbg=NONE

" auto remove trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

let mapleader=" "
map <C-F> :wq<Enter>
map <C-W> :q<Enter>
map <C-S> :w<Enter>


"""""""""""""""""""""""""""""""""""
" neoclide/coc.nvim
source ~/.config/nvim/coc.vim


"""""""""""""""""""""""""""""""""""
" mattn/emmet-vim
let g:user_emmet_mode='a'
let g:user_emmet_expandabbr_key = '<C-E>'


"""""""""""""""""""""""""""""""""""
" prettier/vim-prettier
" Autoformat using Prettier
filetype plugin indent on
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.html Prettier


"""""""""""""""""""""""""""""""""""
" junegunn/fzf.vim
let g:fzf_action = {
  \ 'return': 'tab split',
  \ 'ctrl-j': 'split',
  \ 'ctrl-k': 'vsplit' }

noremap <C-p> :Files<Enter>
nnoremap <C-j> :tabprevious<CR>
noremap <C-i> :tablast<cr>
nnoremap <C-l> :tabnext<CR>
