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

	" Utility
	Plugin 'tpope/vim-fugitive' " Git wrapper
	Plugin 'tpope/vim-vinegar' " Netrw file explorer upgrade
	Plugin 'junegunn/fzf' " Fuzzy finder
	Plugin 'junegunn/fzf.vim'
	Plugin 'tpope/vim-surround'
	Plugin 'altercation/vim-colors-solarized'

	" Languages / Frameworks
	Plugin 'pangloss/vim-javascript'
	Plugin 'tpope/vim-rails'

	call vundle#end()
	filetype plugin indent on
endif

" Global
set backspace=indent,eol,start
let mapleader="\<Space>"

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

" Netrw
nnoremap <leader>- :Lex<CR>

" Word-wrapped lines can be navigated
nnoremap j gj
nnoremap k gk

" Below to End of Block relates to plugins
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

