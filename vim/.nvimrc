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
  let g:python_host_prog=trim(system('which python'))
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
        -- More or less overrides vim's default <g> go-to definitions.
        keymaps = {
          goto_definition = "gd",
          list_definitions = "<leader>gdl",
          list_definitions_toc = "<leader>gdL",
          goto_next_usage = "g*",
          goto_previous_usage = "g#",
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
  " Adapted from LSPInstall source code.
  function! s:install_lsp_servers()
:lua << EOF
  local configs = require('lspconfig/configs')
  local lsp_server_map = vim.g.lsp_server_map
  local lsp_server_names = vim.tbl_keys(lsp_server_map)
  for _, server in ipairs(lsp_server_names) do
    local config = configs[server]
    local is_installable = config.install
    -- Unfortunately not all configurations can be installed using LspInstall.
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
  " Quality of life custom Ex command to automate most lsp server installation.
  command! LspInstallServers call s:install_lsp_servers()

:lua << EOF
  local lsp = require('lspconfig')
  local nvim_command = vim.api.nvim_command
  local on_attach = function(_client, _bufnr)
    require('completion').on_attach()
    -- Show diagnostic on hover w/ floating window.
    nvim_command('autocmd CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics()')
  end
  local global_server_settings = {
    on_attach = on_attach,
    handlers = {
      ["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
          -- Virtual text is nice, but can be buggy when buffer updates rapidly.
          -- Such as numerous undos or scrolling really quickly.
          virtual_text = false
        }
      )
    }
  }
  local custom_server_settings = {
    solargraph = {
      settings = {
        solargraph = {
          diagnostics = true
        }
      }
    }
  }
  local lsp_server_map = vim.g.lsp_server_map
  local lsp_server_names = vim.tbl_keys(lsp_server_map)
  -- Manually merge global + custom settings into new table.
  -- Custom settings have higher priority than global settings (on collision).
  for _, server in ipairs(lsp_server_names) do
    local server_settings = {}
    for k, v in pairs(global_server_settings) do
      server_settings[k] = v
    end
    custom_settings = custom_server_settings[server] or {}
    for k, v in pairs(custom_settings) do
      server_settings[k] = v
    end
    lsp[server].setup(server_settings)
  end
EOF

  " <<< diagnostics >>>
  highlight LspDiagnosticsVirtualTextHint guifg=#888888
  highlight LspDiagnosticsVirtualTextInformation guifg=#4997D0
  highlight LspDiagnosticsFloatingHint guifg=#888888
  highlight LspDiagnosticsFloatingInformation guifg=#4997D0
  " Error underline should be more visible.
  highlight LspDiagnosticsUnderlineError guibg=#FFB7C5
  nnoremap <leader>gdn <cmd>lua vim.lsp.diagnostic.goto_next { wrap = false }<CR>
  nnoremap <leader>gdN <cmd>lua vim.lsp.diagnostic.goto_prev { wrap = false }<CR>

  " <<< completion START >>>
  " Use <Tab> and <S-Tab> to navigate through popup menu
  inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

  " Set completeopt to have a better completion experience
  set completeopt=menuone,noinsert,noselect

  " Avoid showing message extra message when using completion
  set shortmess+=c
  " <<< completion END >>>
endif
