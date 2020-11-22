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

if has_key(plugs, 'nvim-treesitter')
:lua <<EOF
require'nvim-treesitter.configs'.setup {
  -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  -- :TSInstall <Tab> to find out list of languages.
  ensure_installed = {
    'bash',
    'css',
    'go',
    'html',
    'javascript',
    'json',
    'python',
    'regex',
    'ruby',
    'typescript',
    'yaml'
  },
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

if has_key(plugs, 'nvim-lspconfig')
  " <<< completion >>>
  " Use <Tab> and <S-Tab> to navigate through popup menu
  inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

  " Set completeopt to have a better completion experience
  set completeopt=menuone,noinsert,noselect

  " Avoid showing message extra message when using completion
  set shortmess+=c

  " NOTE: manually keep in sync with lspconfig configs in lua.
  let lsp_configs = [
    'bashls',
    'cssls',
    'diagnosticls',
    'gopls',
    'html',
    'jsonls',
    'pyls',
    'solargraph',
    'sqlls'
    'tsserver',
    'vimls',
    'yamlls'
  ]
  for config in lsp_configs
    if empty(glob($HOME.'/.cache/nvim/lspconfig/'.config))
      LspInstall config
    endif
  endfor

:lua << EOF
  local lsp = require('lspconfig')
  local on_attach = function()
    require('completion').on_attach()
  end
  " NOTE: manually keep in sync with lspconfig configs in vimscript.
  local lsp_configs = {
    'bashls',
    'cssls',
    'diagnosticls',
    'gopls',
    'html',
    'jsonls',
    'pyls',
    'solargraph',
    'sqlls'
    'tsserver',
    'vimls',
    'yamlls'
  }
  for _, config in ipairs(lsp_configs) do
    lsp[config].setup { on_attach = on_attach }
  end
EOF
endif
