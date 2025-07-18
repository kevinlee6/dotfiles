" - Nvim specifics in .nvimrc, although this vimrc was created/tested w/ nvim.
" - Split into major sections:
"   1. Initial Global settings (plugins will override these if applicable OR
"      subsequent commands relies on it)
"   2. Vim-plug setup
"   3. Plugin-dependent settings
"   4. Global settings (since it's last it will override anything from above)
" NOTE: if there is an issue w/ a plugin, check if global settings override is
" causing the issue.

" Run :PlugInstall to get started.

" Initial Global settings START ================================================
let mapleader="\<Space>"

if has('win32')
    let $VIMHOME = $HOME.'/vimfiles'
else
    let $VIMHOME = $HOME.'/.vim'
endif

" <<< Centralize temp vim files >>>
" ~/.vim/tmp directory must exist
if !empty(glob($VIMHOME.'/tmp'))
  set backupdir=$VIMHOME/tmp//
  set directory=$VIMHOME/tmp// " swp
  set undodir=$VIMHOME/tmp//
  set undofile
endif

if (has("termguicolors"))
  set termguicolors
endif

set background=light
" Initial Global settings END ==================================================

" Plugin Set Up START ==========================================================
" This if statement will automatically install vim-plug for the first time,
" however, a restart of (n)vim is needed for full functionality (ex: themes).
if empty(glob($VIMHOME.'/autoload/plug.vim'))
  silent !curl -fLo $VIMHOME/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin($VIMHOME.'/plugged')
  " <<< Style >>>
  " Plug 'morhetz/gruvbox'
  Plug 'NLKNguyen/papercolor-theme'

  " <<< Languages / Frameworks / Filetype-specific >>>
  " Note: vim-ruby seems to be already bundled w/ vim.
  Plug 'tpope/vim-rails', { 'for': 'ruby' }
  " Formatting
  Plug 'prettier/vim-prettier', { 'do': 'npm install' }
  Plug 'chrisbra/csv.vim'

  " <<< Requires external sources >>>
  if executable('git')
    Plug 'airblade/vim-gitgutter'
    Plug 'tpope/vim-fugitive' " Git wrapper
    Plug 'tpope/vim-rhubarb' " vim-fugitive helper for github
  endif
  if executable('tmux')
    Plug 'christoomey/vim-tmux-navigator'
  endif
  if executable('fzf')
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim' " Fuzzy finder
  endif
  if executable('ranger')
    Plug 'francoiscabrol/ranger.vim' " File explorer alternative to netrw
    Plug 'rbgrouleff/bclose.vim' " ranger.vim helper
  endif

  " <<< Utility >>>
  Plug 'dhruvasagar/vim-table-mode'
  Plug 'dhruvasagar/vim-zoom' " Tmux-like zoom
  if has('nvim-0.7')
    Plug 'ggandor/leap.nvim'
  else
    Plug 'justinmk/vim-sneak' " Visual motion; vimium-like
  endif
  Plug 'junegunn/vim-easy-align' " Align blocks of text around type of element
  Plug 'mbbill/undotree'
  Plug 'mg979/vim-visual-multi' " Multiple cursors
  Plug 'moll/vim-bbye' " Close buffer without closing split
  Plug 'nathanaelkane/vim-indent-guides' " Show/alternate indent block colors
  Plug 'tpope/vim-commentary' " Comment/uncomment
  Plug 'tpope/vim-surround' " Change surrounding text

  " Airline lags recently. Replace w/ lightline
  " Plug 'vim-airline/vim-airline' " Status bar
  " Plug 'vim-airline/vim-airline-themes'
  Plug 'itchyny/lightline.vim'
  Plug 'mengelbrecht/lightline-bufferline'

  Plug 'sheerun/vim-polyglot' " Syntax Highlighting
  Plug 'terryma/vim-expand-region'
  " Allow selection of ruby blocks
  Plug 'kana/vim-textobj-user', { 'for': 'ruby' }
  Plug 'rhysd/vim-textobj-ruby', { 'for': 'ruby' }
  " Registers
  Plug 'junegunn/vim-peekaboo'

  if executable('node') && (v:version >= 800)
    " Intellisense engine.
    Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
  endif
  " " Depends on version/flavor of vim.
  " if has('nvim-0.5')
  "   Plug 'neovim/nvim-lspconfig'
  "   Plug 'nvim-lua/completion-nvim'

  "   Plug 'nvim-treesitter/nvim-treesitter'
  "   Plug 'romgrk/nvim-treesitter-context'
  "   Plug 'nvim-treesitter/nvim-treesitter-refactor'
  "   Plug 'nvim-treesitter/nvim-treesitter-textobjects'
  "   Plug 'steelsojka/completion-buffers'
  " else
  "   Plug 'sheerun/vim-polyglot' " Syntax Highlighting
  "   Plug 'terryma/vim-expand-region'
  "   " Allow selection of ruby blocks
  "   Plug 'kana/vim-textobj-user', { 'for': 'ruby' }
  "   Plug 'rhysd/vim-textobj-ruby', { 'for': 'ruby' }

  "   if executable('node') && (v:version >= 800)
  "     Plug 'neoclide/coc.nvim', { 'branch': 'release' } " Intellisense engine.
  "   endif
  " endif
  if (v:version > 800) || has('nvim')
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
  else
    Plug 'google/vim-searchindex' " Shows count of match.
  endif
call plug#end()
" Plugin Set Up END ============================================================

" Plugin Dependent Settings START ==============================================
" <<< Colorscheme >>>
if has_key(plugs, 'papercolor-theme')
  colorscheme PaperColor
endif

if executable('git')
  " <<< fugitive/rhubarb >>>
  " Open file in browser / github.
  nmap <leader>go :GBrowse<CR>

  " <<< gitgutter >>>
  set signcolumn=yes " Always show sign column.
  let g:gitgutter_map_keys = 0 " Don't use gitgutter's default keys.
  let g:gitgutter_sign_priority = 11 " default 10
  highlight GitGutterAdd    guifg=#008800 guibg=#90EE90 ctermfg=2
  highlight GitGutterChange guifg=#654321 guibg=#FDD5B1 ctermfg=3
  highlight GitGutterDelete guifg=#6B0000  guibg=#F08080 ctermfg=1
  let g:gitgutter_sign_removed = '-'
  nmap <leader>gn <Plug>(GitGutterNextHunk)
  nmap <leader>gN <Plug>(GitGutterPrevHunk)
  " (ctrl+w)+w toggles between floating window.
  nmap <leader>gp <Plug>(GitGutterPreviewHunk)
  nmap <leader>gs <Plug>(GitGutterStageHunk)
  xmap <leader>gs <Plug>(GitGutterStageHunk)
  nmap <leader>gu <Plug>(GitGutterUndoHunk)
endif

" " <<< Airline >>>
" let g:airline_theme='papercolor'
" let g:airline_powerline_fonts = 1
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'

" <<< Lightline >>>
set showtabline=2
let g:lightline = {
      \ 'colorscheme': 'PaperColor',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'tabline': {
      \   'left': [ ['buffers'] ],
      \   'right': [ ['close'] ]
      \ },
      \ 'component_expand': {
      \   'buffers': 'lightline#bufferline#buffers'
      \ },
      \ 'component_type': {
      \   'buffers': 'tabsel'
      \ },
      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }
      \ }

" <<< Tableize >>>
let g:table_mode_corner='|'

" <<< bbye >>>
nnoremap <leader>q :Bdelete<CR>

" <<< vim-indent-guides >>>
let g:indent_guides_enable_on_vim_startup = 1

" <<< EasyAlign >>>
xmap <leader>ga <Plug>(EasyAlign)
nmap <leader>ga <Plug>(EasyAlign)


" Transitioned from easymotion to sneak because of easymotion issue #442.
" Easymotion labels triggered linters.
" <<< Sneak >>>
" tips: s forward, S backwards. <Tab> to generate next set of labels.
let g:sneak#label = 1 " Provides labels like easymotion.
let g:sneak#use_ic_scs = 1 " Case insensitive.
highlight Sneak guifg=#FFFFFF guibg=#36454F

" <<< FZF >>>
if executable('fzf') && has_key(plugs, 'fzf')
  " Non-dependent settings
  command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
  nnoremap <C-t> :Files<CR>
  nnoremap <leader><C-t> :Files ~<CR>
  nnoremap <leader>b :Buffers<CR>
  nnoremap <leader>h :History<CR>
  nnoremap <leader>m :Marks<CR>
  command! -bang -nargs=* MRU call fzf#vim#history(fzf#vim#with_preview(), <bang>0)

  if executable('git')
    command! -bang -nargs=? -complete=dir GFiles
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
    function! s:find_git_root()
      return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
    endfunction
    command! ProjectFiles execute 'GFiles' s:find_git_root()
    nnoremap <C-p> :ProjectFiles<CR>
  endif

  if executable('rg')
    command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
      \   fzf#vim#with_preview(), 1)
    command! -bang -nargs=* LinesWithPreview
        \ call fzf#vim#grep(
        \   'rg --with-filename --column --line-number --no-heading --color=always --smart-case . '.fnameescape(expand('%')), 1,
        \   fzf#vim#with_preview({'options': '--delimiter : --nth 4.. --no-sort'}, 'right:50%', '?'),
        \   1)
    nnoremap <leader>/ :LinesWithPreview<CR>
    " Don't remove trailing space!
    nnoremap <leader>f :Rg 
  elseif executable('ag')
    " Don't know if ag and rg uses same options.
    nnoremap <leader>f :Ag 
  endif
endif

" <<< Ranger >>>
if executable('ranger')
  let g:ranger_map_keys = 0
  let g:ranger_replace_netrw = 1
  nnoremap - :Ranger<CR>
endif

" <<< Expand-region and text-objects >>>
if (!empty(glob($VIMHOME.'/plugged/vim-expand-region')))
  vmap <Tab> <Plug>(expand_region_expand)
  vmap <S-Tab> <Plug>(expand_region_shrink)
  " 1 means recursive.
  let g:expand_region_text_objects = {
        \ 'iw'  :0,
        \ 'iW'  :0,
        \ 'i"'  :0,
        \ 'i''' :0,
        \ 'i]'  :1,
        \ 'ib'  :1,
        \ 'iB'  :1,
        \ 'a]'  :1,
        \ 'ab'  :1,
        \ 'aB'  :1
        \ }
  " Requires external dep, such from as coc-nvim.
  call expand_region#custom_text_objects({
        \ 'if'  :1,
        \ 'af'  :1
        \ })
  " Requires vim-textobj-user, vim-textobj-ruby.
  call expand_region#custom_text_objects('ruby', {
        \ 'ir' :1,
        \ 'ar' :1
        \ })
endif

if(has('nvim'))
  " <<< Peekaboo >>>
  function! CreateCenteredFloatingWindow() abort
    let width = float2nr(&columns * 0.6)
    let height = float2nr(&lines * 0.6)
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}
    let s:buf = nvim_create_buf(v:false, v:true)
    call nvim_open_win(s:buf, v:true, opts)
  endfunction
  let g:peekaboo_window="call CreateCenteredFloatingWindow()"
endif
if has('nvim-0.7')
  " <<< Leap >>>
  lua require('leap').add_default_mappings()
endif

if executable('node') && has_key(plugs, 'coc.nvim') && (v:version >= 800)
  let g:coc_global_extensions = [
        \ 'coc-css',
        \ 'coc-go',
        \ 'coc-json',
        \ 'coc-lists',
        \ 'coc-pairs',
        \ 'coc-pyright',
        \ 'coc-solargraph',
        \ 'coc-tsserver',
        \ 'coc-yank'
        \ ]
        " Past plugins:
        " Works great, esp w/ async, but kind of laggy.
        " \ 'coc-highlight',
        " coc-yaml is very resource intensive
        " \ 'coc-yaml'
        " Works great; nothing wrong with it. Replaced w/ gitgutter.
        " "\ 'coc-git',

  autocmd FileType ruby let b:coc_root_patterns = ['.git', '.env', '.solargraph.yml']
  " Remap keys for gotos
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gr <Plug>(coc-references)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)

  nmap <leader>gf <Plug>(coc-codeaction)
  " Remap for rename current word
  nmap <leader>rn <Plug>(coc-rename)

  " Introduce function text object
  " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
  xmap if <Plug>(coc-funcobj-i)
  xmap af <Plug>(coc-funcobj-a)
  omap if <Plug>(coc-funcobj-i)
  omap af <Plug>(coc-funcobj-a)

  " if hidden is not set, TextEdit might fail.
  set hidden

  " Some servers have issues with backup files, see #649
  set nobackup
  set nowritebackup

  " " Better display for messages
  " set cmdheight=2

  " Shows count of matches.
  if (v:version > 800)
    set shortmess-=S
  endif
  " don't give |ins-completion-menu| messages.
  set shortmess+=c

  " Show yank list
  nnoremap <silent> <leader>y  :<C-u>CocList -A --normal yank<cr>

  " Show jump list
  nnoremap <silent> <leader>j  :<C-u>CocList -A location<cr>

  " Show symbol list
  nnoremap <silent> <leader>s  :<C-u>CocList --interactive symbols<cr>

  function! CheckBackSpace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
  endfunction

  " Insert <tab> when previous text is space, refresh completion if not.
  inoremap <silent><expr> <TAB>
	\ coc#pum#visible() ? coc#pum#next(1):
	\ CheckBackSpace() ? "\<Tab>" :
	\ coc#refresh()
  inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
  " Make enter select current item (usually for first result).
  inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  " function! s:check_back_space() abort
  "   let col = col('.') - 1
  "   return !col || getline('.')[col - 1]  =~# '\s'
  " endfunction
  " " Use tab for trigger completion with characters ahead and navigate.
  " " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
  " " other plugin before putting this into your config.
  " inoremap <silent><expr> <TAB>
  "       \ pumvisible() ? "\<C-n>" :
  "       \ <SID>check_back_space() ? "\<TAB>" :
  "       \ coc#refresh()
  " inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  " Use K to show documentation in preview window
  nnoremap <silent> K :call <SID>show_documentation()<CR>
  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  " Original info highlight yellow looks too similar to vim's search highlight.
  hi! CocInfoHighlight guibg=#ffffe0
  hi default CocMenuSel ctermbg=237 guibg=#ffffe0
endif

" vim-commentary
autocmd FileType sql setlocal commentstring=--\ %s

" Plugin Dependent Settings END ================================================

" Global settings START ========================================================
set backspace=indent,eol,start
set textwidth=80
set colorcolumn=80
set formatoptions-=t " Don't insert new lines when textwidth exceeded.
highlight ColorColumn ctermbg=0 guibg=#eeeeee
set guioptions=M " No GUI
set lazyredraw " Don't update screen during macros
set autoread " Reload vim file after it's been altered.
au FileType * set fo-=c fo-=r fo-=o " No comment continuation on new line
set updatetime=100 " Suggested to increase responsiveness for async actions.

set splitbelow " Default up
set splitright " Default left

" <<< Visual markers >>>
set list
set lcs=tab:»·
set lcs+=trail:·

" <<< Buffers >>>
nnoremap <leader><Tab> :bnext<CR> " Go to right buffer
nnoremap <leader><S-Tab> :bprevious<CR> " Go to left buffer
" Commented below out in favor of bbye plugin.
" nnoremap <leader>q :bd<CR> " Close buffer

" <<< Command Line >>>
" set wildmenu " Autocomplete UI horizontal instead of vertical
" set wildchar=<Tab>
" set wildmode=list:longest,full " wildchar behavior

" <<< Fold >>>
" z-a to toggle
set foldmethod=indent
set foldlevelstart=99

" <<< Navigation >>>
set cursorcolumn " Show cursor column highlight
set cursorline " Show cursor row highlight
set number " Show line number
" Word-wrapped lines can be navigated
nnoremap j gj
nnoremap k gk

" <<< Search >>>
set hlsearch " Highlight results
set incsearch " Real time search
set gdefault " Regex by default
set ignorecase " Case insensitive search
set smartcase " Case sensitive if cap char is used
nnoremap <leader><leader>/ :nohl<CR> " Remove highlight
set magic " Enable extended regex
" verymagic eliminates need for some backslashes; more PCRE style.
:nnoremap / /\v
:cnoremap %s/ %s/\v
" Prevent cursor from moving when searching word under cursor.
nnoremap * *``

" <<< Tab >>>
set tabstop=2
set shiftwidth=2
set expandtab

" <<< Registers >>>
set clipboard^=unnamedplus " Use system clipboard (needs xterm_clipboard)
" Shortcut to set clipboard to vim's last used register.
nmap <leader>" :let @+ = @"<CR>

set nogdefault " Not sure what is setting g default to true.
" Global settings END ==========================================================

" Misc stuff below.
if has('nvim')
  try
    source ~/.nvimrc
  catch
    " Fail silently.
  endtry
else
  try
    source ~/.ogvimrc
  catch
    " Fail silently.
  endtry
endif

" Work related settings
try
  source ~/.vimrc-work
catch
  " Fail silently.
endtry

" <<< URL encode/decode selection >>>
if executable('python3')
  vnoremap <leader>en :!python3 -c 'import sys,urllib.parse;print(urllib.parse.quote(sys.stdin.read().strip()))'<cr>
  vnoremap <leader>de :!python3 -c 'import sys,urllib.parse;print(urllib.parse.unquote(sys.stdin.read().strip()))'<cr>
endif
