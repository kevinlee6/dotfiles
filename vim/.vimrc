" General format is that long blocks will start with === NAME START === and
" end with === NAME END ===.

"=== Global START ===
set backspace=indent,eol,start
let mapleader="\<Space>"

" No GUI
set guioptions=M

" Switch buffers / close buffer
nnoremap <leader><Tab> :bnext<CR>
nnoremap <leader><S-Tab> :bprevious<CR>
nnoremap <leader>q :bd<CR>

" Shortcut for nohl
nnoremap <leader><leader>/ :nohl<CR>

" Use system clipboard (needs xterm_clipboard)
set clipboard=unnamedplus

" Case insensitive search
set ignorecase

" Smart search (case insensitive disabled if a cap char is used)
set smartcase

" Shows cursor column highlight
set cursorcolumn

" Set line numbers
set number
set relativenumber

" Custom tab sizes
set tabstop=2
set shiftwidth=2
set expandtab

" Real time search
set incsearch

" Fold blocks of code (z-a to toggle)
set foldmethod=indent
set foldlevelstart=99

" Word-wrapped lines can be navigated
nnoremap j gj
nnoremap k gk
" === Global END ===

" === Everything under this line relies on plugins ===
" Nvim specifics in .nvimrc
"=== Plugin Set Up START ===
" This if statement will automatically install vim-plug for the first time,
" however, a restart of (n)vim is needed for full functionality.
" Examples: Themes and coc-highlight
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
  "=== Style ===
  " Plug 'morhetz/gruvbox'
  Plug 'NLKNguyen/papercolor-theme'

  " === Languages / Frameworks ===
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'jsx'] }
  Plug 'mxw/vim-jsx', { 'for': ['javascript', 'jsx'] }
  Plug 'kchmck/vim-coffee-script', { 'for': 'coffeescript' }
  Plug 'tpope/vim-rails', { 'for': 'ruby' }
  " Allow selection of ruby blocks
  Plug 'kana/vim-textobj-user', { 'for': 'ruby' }
  Plug 'rhysd/vim-textobj-ruby', { 'for': 'ruby' }

  "=== Git ===
  Plug 'tpope/vim-fugitive' " Git wrapper

  "=== Requires external sources ===
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim' " Fuzzy finder

  "=== Utility ===
  Plug 'tpope/vim-vinegar' " Netrw file explorer upgrade
  Plug 'tpope/vim-surround' " Change surrounding text
  Plug 'tpope/vim-commentary' " Comment/uncomment
  Plug 'google/vim-searchindex' " Shows count of match
  Plug 'terryma/vim-multiple-cursors' " C-n for multiple cursors
  Plug 'junegunn/vim-easy-align' " Align blocks of text (like =)
  Plug 'easymotion/vim-easymotion' " Visual motion; vimium-like
  Plug 'rbong/vim-crystalline' " Status bar
  Plug 'yuttie/comfortable-motion.vim' " Smooth scrolling
call plug#end()
"=== Plugin Set Up END ===

"=== Color Theme START ===
set background=light
if (has("termguicolors"))
  set termguicolors
endif
if (!empty(glob('~/.vim/plugged/papercolor-theme')))
  colorscheme PaperColor
endif
"=== Color Theme END ===

"=== Plugin Dependent Settings START ===
" EasyAlign
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" EasyMotion
nmap s <Plug>(easymotion-s)
vmap s <Plug>(easymotion-s)
let g:EasyMotion_smartcase = 1
 
" FZF
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=? -complete=dir GFiles
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=* MRU call fzf#vim#history(fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=* LinesWithPreview
    \ call fzf#vim#grep(
    \   'rg --with-filename --column --line-number --no-heading --color=always --smart-case . '.fnameescape(expand('%')), 1,
    \   fzf#vim#with_preview({'options': '--delimiter : --nth 4.. --no-sort'}, 'right:50%', '?'),
    \   <bang>0)
function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction
command! ProjectFiles execute 'GFiles' s:find_git_root()
nnoremap <C-t> :Files<CR>
nnoremap <C-p> :ProjectFiles<CR>
nnoremap <C-g> :Files ~<CR>
nnoremap <leader>/ :LinesWithPreview<CR>
nnoremap <leader>f :Rg 
nnoremap <leader>b :Buffers<CR> 

" Vim vinegar
let g:netrw_fastbrowse = 0 " Close vinegar buffer

"=== Crystalline (status bar) START ===
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
  return crystalline#bufferline(0, 0, 1)
endfunction

let g:crystalline_enable_sep = 1
let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_tabline_fn = 'TabLine'
let g:crystalline_theme = 'papercolor'

set showtabline=2
set guioptions-=e
set laststatus=2
"=== Crystalline END ===

"=== coc server START ===
" Hard code node path for work-laptop
if hostname() == 'kl-lenovo'
  let g:coc_node_path='/home/kevin/.nvm/versions/node/v8.11.2/bin/node'
endif
let g:coc_global_extensions = [
      \ 'coc-css',
      \ 'coc-git',
      \ 'coc-highlight',
      \ 'coc-json',
      \ 'coc-lists',
      \ 'coc-pairs',
      \ 'coc-prettier',
      \ 'coc-solargraph',
      \ 'coc-tsserver',
      \ 'coc-yank'
      \ ]

" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Highlight symbol under cursor on CursorHold
highlight CocHighlightText guibg=#d3d3d3 ctermbg=223
autocmd CursorHold * silent call CocActionAsync('highlight')
hi CocInfoSign guifg=Blue

" Show yank list
nnoremap <silent> <leader>y  :<C-u>CocList -A --normal yank<cr>

" Show jump list 
nnoremap <silent> <leader>j  :<C-u>CocList -A location<cr>

" Show symbol list
nnoremap <silent> <leader>s  :<C-u>CocList --interactive symbols<cr>

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)

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
"=== coc server END ===
"=== Plugin Dependent Settings END ===
