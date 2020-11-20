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

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,
    use_languagetree = false, -- Use this to enable language injection (this is very unstable)
    custom_captures = {
      -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
      ["foo.bar"] = "Identifier",
    },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",
      node_incremental = "<TAB>",
      scope_incremental = "<CR>",
      node_decremental = "<S-TAB>",
    },
  },
  indent = {
    enable = true
  }
}
EOF
