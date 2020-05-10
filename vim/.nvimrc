let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" <<< ActiveWindow >>>
hi ActiveWindow ctermbg=None ctermfg=None guibg=#eeeeee
hi InactiveWindow ctermbg=darkgray ctermfg=gray guibg=#d3d3d3
set winhighlight=Normal:ActiveWindow,NormalNC:InactiveWindow

if has('python3')
  set pyx=3
  let g:python3_host_prog=trim(system('which python3'))
elseif has('python')
  set pyx=2
endif
