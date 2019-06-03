" Nvim specifics in .nvimrc
" Vundle / Plugin Set Up
if empty(system("grep lazy_load ~/.vim/bundle/Vundle.vim/autoload/vundle.vim"))
  echoerr "Vundle plugins are not installed. Please run ~/.vim/bin/install"
else
	set nocompatible
	filetype off
	set rtp+=~/.vim/bundle/Vundle.vim
	call vundle#begin()
	Plugin 'VundleVim/Vundle.vim'

  "=== Style ===
  " Plugin 'morhetz/gruvbox'
  Plugin 'NLKNguyen/papercolor-theme'

	"=== Syntax ===
	Plugin 'w0rp/ale' " Support linting
  let g:ale_set_highlights = 0 " Disable linting highlights

	" === Languages / Frameworks ===
  Plugin 'neoclide/coc.nvim'
	Plugin 'pangloss/vim-javascript'
  Plugin 'mxw/vim-jsx'
	Plugin 'tpope/vim-rails'
	Plugin 'kchmck/vim-coffee-script'

  "=== Git ===
	Plugin 'tpope/vim-fugitive' " Git wrapper
  Plugin 'airblade/vim-gitgutter' " Shows git diff realtime

  "=== Requires external sources ===
  Plugin 'christoomey/vim-tmux-navigator'
	Plugin 'junegunn/fzf' " Fuzzy finder
	Plugin 'junegunn/fzf.vim'
  nnoremap <C-t> :GFiles<CR>
  " fzf + ripgrep
  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)


	"=== Utility ===
	Plugin 'tpope/vim-vinegar' " Netrw file explorer upgrade
  let g:netrw_fastbrowse = 0 " Close vinegar buffer

	Plugin 'tpope/vim-surround' " Change surrounding text
  Plugin 'google/vim-searchindex' " Shows count of match
  Plugin 'rbong/vim-crystalline' " Status bar

	Plugin 'scrooloose/nerdcommenter' " Comment/uncomment
  let g:NERDSpaceDelims = 1 " Add 1 space after comment

	Plugin 'terryma/vim-multiple-cursors'
	call vundle#end()
  filetype plugin indent on

  syntax enable
  set background=light
  if (has("termguicolors"))
    set termguicolors
  endif
  colorscheme PaperColor

  "=== Crystalline Block Start ===
  function! StatusLine(current, width)
    let l:s = ''

    if a:current
      let l:s .= crystalline#mode() . crystalline#right_mode_sep('')
    else
      let l:s .= '%#CrystallineInactive#'
    endif
    let l:s .= ' %f%h%w%m%r '
    if a:current
      let l:s .= crystalline#right_sep('', 'Fill') . ' %{fugitive#head()}'
    endif

    let l:s .= '%='
    if a:current
      let l:s .= crystalline#left_sep('', 'Fill') . ' %{&paste ?"PASTE ":""}%{&spell?"SPELL ":""}'
      let l:s .= crystalline#left_mode_sep('')
    endif
    " if a:width > 80
    " let l:s .= ' %{&ft}[%{&enc}][%{&ffs}] %l/%L %c%V %P '
    if a:width > 50
      let l:s .= ' %l/%L '
    else
      let l:s .= ' '
    endif

    return l:s
  endfunction

  function! TabLine()
    let l:vimlabel = has('nvim') ?  ' NVIM ' : ' VIM '
    return crystalline#bufferline(2, len(l:vimlabel), 1) . '%=%#CrystallineTab# ' . l:vimlabel
  endfunction

  let g:crystalline_enable_sep = 1
  let g:crystalline_statusline_fn = 'StatusLine'
  let g:crystalline_tabline_fn = 'TabLine'
  let g:crystalline_theme = 'papercolor'

  set showtabline=2
  set guioptions-=e
  set laststatus=2
  "=== Crystalline Block end ===

  "=== coc server start; taken from documentation ===
  let g:coc_global_extensions = ['coc-tsserver', 'coc-solargraph', 'coc-css', 'coc-pairs', 'coc-highlight', 'coc-json']

  " if hidden is not set, TextEdit might fail.
  set hidden

  " Some servers have issues with backup files, see #649
  set nobackup
  set nowritebackup

  " Better display for messages
  " set cmdheight=2

  " Smaller updatetime for CursorHold & CursorHoldI
  set updatetime=300

  " don't give |ins-completion-menu| messages.
  set shortmess+=c

  " always show signcolumns
  " set signcolumn=yes

  " Highlight symbol under cursor on CursorHold
  highlight CocHighlightText  guibg=#d3d3d3 ctermbg=223
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Remap keys for gotos
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " Use K to show documentation in preview window
  nnoremap <silent> K :call <SID>show_documentation()<CR>
  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  " Remap for rename current word
  nmap <leader>rn <Plug>(coc-rename)

  " Use tab for trigger completion with characters ahead and navigate.
  " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction
  "=== coc server end ===
endif

" === Everything after this line does not depend on plugins ===
" Global
set backspace=indent,eol,start
let mapleader="\<Space>"

" Switch buffers / close buffer
:nnoremap <Tab> :bnext<CR>
:nnoremap <S-Tab> :bprevious<CR>
:nnoremap <leader>q :bd<CR>

" Use system clipboard (needs xterm_clipboard)
set clipboard=unnamedplus

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
