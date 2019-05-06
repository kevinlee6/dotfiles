" Vundle Set Up
if empty(system("grep lazy_load ~/.vim/bundle/Vundle.vim/autoload/vundle.vim"))
  echoerr "Vundle plugins are not installed. Please run ~/.vim/bin/install"
else
	set nocompatible
	filetype off
	set rtp+=~/.vim/bundle/Vundle.vim
	call vundle#begin()
	Plugin 'VundleVim/Vundle.vim'

	" Syntax
	Plugin 'w0rp/ale' " Support linting
	Plugin 'mattn/emmet-vim'

	" Languages / Frameworks
  Plugin 'neoclide/coc.nvim'

	Plugin 'pangloss/vim-javascript'
  Plugin 'mxw/vim-jsx'
	Plugin 'tpope/vim-rails'
	Plugin 'kchmck/vim-coffee-script'

	" Utility
  Plugin 'christoomey/vim-tmux-navigator'
	Plugin 'tpope/vim-fugitive' " Git wrapper
	Plugin 'tpope/vim-vinegar' " Netrw file explorer upgrade
	Plugin 'junegunn/fzf' " Fuzzy finder
	Plugin 'junegunn/fzf.vim'
	Plugin 'tpope/vim-surround' " Change surrounding text
	Plugin 'altercation/vim-colors-solarized'
	Plugin 'vim-airline/vim-airline' " Status bar
  Plugin 'vim-airline/vim-airline-themes'
	Plugin 'scrooloose/nerdcommenter' " Comment/uncomment
	Plugin 'terryma/vim-multiple-cursors'

	call vundle#end()
	syntax enable
  set background=light
  " let g:solarized_termcolors=256
  let g:airline_theme='solarized'
  colorscheme solarized
	filetype plugin indent on
endif

" Global
set backspace=indent,eol,start
let mapleader="\<Space>"

" Case insensitive search
set ignorecase

" Smart search (case insensitive disabled if a cap char is used)
set smartcase

" Set line numbers
set number
set relativenumber

" Custom tab sizes
set tabstop=2
set shiftwidth=2
set expandtab

set incsearch
set hlsearch

" Word-wrapped lines can be navigated
nnoremap j gj
nnoremap k gk

let g:user_emmet_install_global = 0
autocmd FileType html,css,js,erb EmmetInstall

let g:ale_fixers = {
\ 'javascript': ['prettier', 'eslint'],
\}

" Need fzf
nnoremap <C-t> :GFiles<CR>
" fzf + ripgrep
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

"=== For coc server ===
let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
    endfunction

    inoremap <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ coc#refresh()
