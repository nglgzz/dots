"""""""""""""""""""""""""""""""""""
" plug-vim
call plug#begin("~/.cache/nvim/")
  " Plugin Section
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
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
" Autoformat using deno fmt
function! DenoFmt()
  let l:extension_map = {'todo': 'md'}
  let l:ext = get(l:extension_map, expand('%:e'), expand('%:e'))

  let saved_view = winsaveview()
  execute 'silent %!deno fmt --ext ' . l:ext . ' -'
  if v:shell_error > 0
    silent undo
  endif
  call winrestview(saved_view)
endfunction

command! DenoFmt call DenoFmt()
autocmd BufWritePre * call DenoFmt()


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
