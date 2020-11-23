" Lua Notes:
" - Errors are silent.
" - The lua block cannot start/end indented.

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

" Centralized variable for nvim-treesitter and nvim-lspconfig.
" key: LSP server, values: supported languages (for treesitter).
let lsp_server_map = {
  \'bashls': ['bash'],
  \'cssls': ['css'],
  \'diagnosticls': [],
  \'gopls': ['go'],
  \'html': ['html'],
  \'jsonls': ['json'],
  \'pyls': ['python'],
  \'solargraph': ['ruby'],
  \'sqlls': [],
  \'tsserver': ['javascript', 'typescript'],
  \'vimls': [],
  \'yamlls': ['yaml']
\}

if has_key(plugs, 'nvim-treesitter')
:lua <<EOF
  local lsp_server_map = vim.g.lsp_server_map
  local languages = vim.tbl_flatten(vim.tbl_values(lsp_server_map))
  require'nvim-treesitter.configs'.setup {
    -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    -- :TSInstall <Tab> to find out list of languages.
    ensure_installed = languages,
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
  " <<< completion START >>>
  " Use <Tab> and <S-Tab> to navigate through popup menu
  inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

  " Set completeopt to have a better completion experience
  set completeopt=menuone,noinsert,noselect

  " Avoid showing message extra message when using completion
  set shortmess+=c
  " <<< completion END >>>

  " Automatic installation adapted from LSPInstall source code.
  function! s:install_lsp_servers()
:lua << EOF
  local configs = require('lspconfig/configs')
  local lsp_server_map = vim.g.lsp_server_map
  local lsp_server_names = vim.tbl_keys(lsp_server_map)
  for _, server in ipairs(lsp_server_names) do
    local config = configs[server]
    local is_installable = config.install
    if not is_installable then
      print(string.format('WARN: "%s" could not be installed.', server))
      goto continue
    end

    local is_installed = config.install_info().is_installed
    if is_installed then
      print(string.format('SKIP: "%s" is already installed.', server))
    else
      config.install()
      print(string.format('SUCCESS: "%s" installed.', server))
    end
    ::continue::
  end
EOF
  endfunction
  command! LspInstallServers call s:install_lsp_servers()

:lua << EOF
  local lsp = require('lspconfig')
  local on_attach = function(_, _bufnr)
    require('completion').on_attach()
  end
  local lsp_server_map = vim.g.lsp_server_map
  local lsp_server_names = vim.tbl_keys(lsp_server_map)
  for _, server in ipairs(lsp_server_names) do
    lsp[server].setup { on_attach = on_attach }
  end
EOF

  " <<< diagnostics >>>
  highlight LspDiagnosticsVirtualTextHint guifg=#888888
endif
