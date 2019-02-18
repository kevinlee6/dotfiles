execute pathogen#infect()
filetype plugin indent on
set backspace=indent,eol,start

let mapleader="\<Space>"

" Solarized plugin
syntax enable
set background=light
colorscheme solarized

" Emmet plugin
let g:user_emmet_install_global = 0
autocmd FileType html,css,js,erb EmmetInstall

" Ale plugin
let g:ale_fixers = {
\  'javascript': ['prettier', 'eslint'],
\}

" Fuzzy Finder
nnoremap <leader>p :Files<CR>

" Set line numbers
set number
set relativenumber

" Custom tab sizes
set tabstop=2
set shiftwidth=2

" Dynamic highlighting with search
set incsearch
set hlsearch
nnoremap <leader><space> :nohlsearch<CR>

" Word-wrapped lines can be navigated
nnoremap j gj
nnoremap k gk
