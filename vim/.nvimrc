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

if (!empty(glob($VIMHOME.'/plugged/nvim-treesitter')))
lua <<EOF
require'nvim-treesitter.configs'.setup {
  -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  -- :TSInstall <Tab> to find out list of languages.
  ensure_installed = { "bash", "css", "go", "html", "javascript", "json", "python", "regex", "ruby", "yaml" },
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
  },
  refactor = {
    highlight_definitions = { enable = true },
    highlight_current_scope = { enable = true },
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = "<leader>gr",
      },
    },
    navigation = {
      enable = true,
      keymaps = {
        goto_definition = "<leader>gd",
        list_definitions = "<leader>gD",
        list_definitions_toc = "<leader><leader>gD"
      },
    },
  },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
}
EOF
endif
