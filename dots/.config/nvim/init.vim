"""""""""""""""""""""""""""""""""""
" plug-vim
call plug#begin("~/.cache/nvim/")
  " Plugin Section
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'sbdchd/neoformat'
  Plug 'jiangmiao/auto-pairs'
  Plug 'junegunn/fzf', {'do': { -> fzf#install() } }
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
map <C-F> :wq<CR>
map <C-W> :q<CR>
map <C-S> :w<CR>


"""""""""""""""""""""""""""""""""""
" neoclide/coc.nvim
source ~/.config/nvim/coc.vim


"""""""""""""""""""""""""""""""""""
" sbdchd/neoformat
" Autoformat using Prettier
filetype plugin indent on
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.html Neoformat prettier


"""""""""""""""""""""""""""""""""""
" junegunn/fzf.vim
noremap <C-p> :call fzf#run({
  \ "sink": "tabedit",
  \ "source": "find * -type f ! -path '**/.git/**'",
  \ "down": "30%"
\ })<CR>
nnoremap <C-j> :tabprevious<CR>
nnoremap <C-i> :tablast<CR>
nnoremap <C-l> :tabnext<CR>
