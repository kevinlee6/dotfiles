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

" <<< Centralize temp vim files >>>
" ~/.vim/tmp directory must exist
if !empty(glob('~/.vim/tmp'))
  set backupdir=~/.vim/tmp//
  set directory=~/.vim/tmp// " swp
  set undodir=~/.vim/tmp//
  set undofile
endif

if (has("termguicolors"))
  set termguicolors
endif

set background=light
" Initial Global settings END ==================================================

" Plugin Set Up START ==========================================================
" This if statement will automatically install vim-plug for the first time,
" however, a restart of (n)vim is needed for full functionality.
" Examples: Themes and coc-highlight
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
  " <<< Style >>>
  " Plug 'morhetz/gruvbox'
  Plug 'NLKNguyen/papercolor-theme'

  " <<< Languages / Frameworks / Filetype-specific >>>
  Plug 'maxmellon/vim-jsx-pretty', { 'for': ['javascript', 'javascriptreact'] }
  Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'javascriptreact'] }
  Plug 'tpope/vim-rails', { 'for': 'ruby' }
  " Allow selection of ruby blocks
  Plug 'kana/vim-textobj-user', { 'for': 'ruby' }
  Plug 'rhysd/vim-textobj-ruby', { 'for': 'ruby' }
  " Formatting
  Plug 'prettier/vim-prettier', {
    \ 'branch': 'release/1.x',
    \ 'for': [
      \ 'javascript',
      \ 'typescript',
      \ 'css',
      \ 'less',
      \ 'scss',
      \ 'json',
      \ 'graphql',
      \ 'markdown',
      \ 'vue',
      \ 'lua',
      \ 'php',
      \ 'python',
      \ 'html',
      \ 'swift' ] }
  Plug 'tpope/vim-endwise', { 'for': ['ruby', 'sh', 'bash'] }
  Plug 'chrisbra/csv.vim'

  " <<< Requires external sources >>>
  if executable('git')
    Plug 'tpope/vim-fugitive' " Git wrapper
    Plug 'tpope/vim-rhubarb' " vim-fugitive helper for github
  endif
  if executable('node')
    Plug 'neoclide/coc.nvim', { 'branch': 'release' } " Intellisense engine.
  endif
  if executable('tmux')
    Plug 'christoomey/vim-tmux-navigator'
  endif
  if executable('fzf')
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim' " Fuzzy finder
  endif
  if executable('ranger')
    Plug 'francoiscabrol/ranger.vim' " File explorer alternative to netrw
    Plug 'rbgrouleff/bclose.vim' " ranger.vim helper
  endif

  " <<< Utility >>>
  Plug 'dhruvasagar/vim-table-mode'
  Plug 'dhruvasagar/vim-zoom' " Tmux-like zoom
  Plug 'easymotion/vim-easymotion' " Visual motion; vimium-like
  Plug 'google/vim-searchindex' " Shows count of match
  Plug 'junegunn/vim-easy-align' " Align blocks of text (like =)
  Plug 'mbbill/undotree'
  Plug 'mg979/vim-visual-multi' " Multiple cursors
  Plug 'moll/vim-bbye' " Close buffer without closing split.
  Plug 'nathanaelkane/vim-indent-guides' " Show/alternate indent block colors.
  Plug 'psliwka/vim-smoothie' " Smooth scrolling.
  Plug 'rbong/vim-crystalline' " Status bar
  Plug 'tpope/vim-commentary' " Comment/uncomment
  Plug 'tpope/vim-surround' " Change surrounding text
call plug#end()
" Plugin Set Up END ============================================================

" Plugin Dependent Settings START ==============================================
" <<< Colorscheme >>>
if (!empty(glob('~/.vim/plugged/papercolor-theme')))
  colorscheme PaperColor
endif


" <<< bbye >>>
nnoremap <leader>q :Bdelete<CR>

" <<< vim-indent-guides >>>
let g:indent_guides_enable_on_vim_startup = 1

" <<< EasyAlign >>>
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" <<< EasyMotion >>>
nmap s <Plug>(easymotion-overwin-f2)
vmap s <Plug>(easymotion-s)
let g:EasyMotion_smartcase = 1

" <<< FZF >>>
if executable('fzf')
  " Non-dependent settings
  command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
  nnoremap <C-t> :Files<CR>
  nnoremap <C-g> :Files ~<CR>
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

" === Crystalline (status bar) START ===
if (v:version >= 800)
  set noshowmode " Handled by status bar.
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
    let l:s .= ' %{zoom#statusline()}'
    if a:width > 50
      let l:s .= ' %c%V %l/%L '
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
endif
" === Crystalline END ===

" === coc server START ===
if executable('node')
  let g:coc_global_extensions = [
        \ 'coc-css',
        \ 'coc-git',
        \ 'coc-highlight',
        \ 'coc-json',
        \ 'coc-lists',
        \ 'coc-pairs',
        \ 'coc-solargraph',
        \ 'coc-tsserver',
        \ 'coc-yank',
        \ 'coc-yaml'
        \ ]

  " if hidden is not set, TextEdit might fail.
  set hidden

  " Some servers have issues with backup files, see #649
  set nobackup
  set nowritebackup

  " " Better display for messages
  " set cmdheight=2

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

  nmap <leader>gf <Plug>(coc-codeaction)

  " coc-git
  nmap <leader>gg <Plug>(coc-git-chunkinfo)
  nmap <leader>gc <Plug>(coc-git-commit)
  nmap <leader>gs :CocCommand git.chunkStage<CR>
  nmap <leader>gu :CocCommand git.chunkUndo<CR>
  nmap <leader>go :CocCommand git.browserOpen<CR>
  " navigate chunks of current buffer
  nmap <leader>gN <Plug>(coc-git-prevchunk)
  nmap <leader>gn <Plug>(coc-git-nextchunk)
  " create text object for git chunks
  omap ig <Plug>(coc-git-chunk-inner)
  xmap ig <Plug>(coc-git-chunk-inner)
  omap ag <Plug>(coc-git-chunk-outer)
  xmap ag <Plug>(coc-git-chunk-outer)

  " Introduce function text object
  " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
  xmap if <Plug>(coc-funcobj-i)
  xmap af <Plug>(coc-funcobj-a)
  omap if <Plug>(coc-funcobj-i)
  omap af <Plug>(coc-funcobj-a)

  " Use <TAB> for selections ranges.
  " NOTE: Requires 'textDocument/selectionRange' support from the language server.
  " coc-tsserver, coc-python are the examples of servers that support it.
  vmap <silent> <TAB> <Plug>(coc-range-select)
  vmap <silent> <S-TAB> <Plug>(coc-range-select-backward)

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction
  " Use tab for trigger completion with characters ahead and navigate.
  " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
  " other plugin before putting this into your config.
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

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

  " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
  " position. Coc only does snippet and additional edit on confirm.
  function! s:handle_cr()
    if (exists('*complete_info') && (complete_info()["selected"] != "-1"))
      return "\<C-y>"
    elseif pumvisible()
      " for older vim versions; not sure if it conflicts w/ complete_info, so it's
      " placed on another condition.
      return "\<C-y>"
    endif
    return "\<C-g>u\<CR>"
  endfunction
  " remap <cr> because of vim-endwise.
  imap <silent> <CR> <C-R>=<SID>handle_cr()<CR>
endif
" === coc server END ===
" Plugin Dependent Settings END ================================================

" Global settings START ========================================================
set backspace=indent,eol,start
set textwidth=80
set colorcolumn=80
set formatoptions-=t " Don't insert new lines when textwidth exceeded.
highlight ColorColumn ctermbg=0 guibg=#eeeeee
set clipboard^=unnamedplus " Use system clipboard (needs xterm_clipboard)
set guioptions=M " No GUI
set lazyredraw " Don't update screen during macros
set autoread " Reload vim file after it's been altered.
au FileType * set fo-=c fo-=r fo-=o " No comment continuation on new line

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
set relativenumber " Show line number relative to current line
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

" <<< Tab >>>
set tabstop=2
set shiftwidth=2
set expandtab

" <<< URL encode/decode selection >>>
if executable('python3')
  vnoremap <leader>en :!python3 -c 'import sys,urllib.parse;print(urllib.parse.quote(sys.stdin.read().strip()))'<cr>
  vnoremap <leader>de :!python3 -c 'import sys,urllib.parse;print(urllib.parse.unquote(sys.stdin.read().strip()))'<cr>
endif

set nogdefault " Not sure what is setting g default to true.
" Global settings END ==========================================================

" Misc stuff below.
if !has('nvim')
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

" " Haven't tried yet but looks like it could come in handy
" " Use a bar-shaped cursor for insert mode, even through tmux.
" if exists('$TMUX')
"     let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
"     let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
" else
"     let &t_SI = "\<Esc>]50;CursorShape=1\x7"
"     let &t_EI = "\<Esc>]50;CursorShape=0\x7"
" endif
