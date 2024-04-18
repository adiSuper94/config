-- if true then return {} end
return {
  {
    'neovim/nvim-lspconfig',
    dependencies = { {'williamboman/mason.nvim', config = true}, {'j-hui/fidget.nvim', opts = {}} },
    config= function()
      local nvim_lsp = require'lspconfig'
      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          client.server_capabilities.semanticTokensProvider = nil
          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<space>df',vim.diagnostic.open_float, opts)
          vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', '<space>r', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
          end, opts)
        end,
      })
      local settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = 'none',
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          }
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = 'all',
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          }
        },
        gopls = {
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          }
        }
      }
      -- local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
      -- capabilities.textDocument.completion.completionItem.snippetSupport = false
      local servers = {'jsonls', 'clangd', 'pyright', 'rust_analyzer', 'gopls', 'tsserver'}
      for _, lsp in pairs(servers) do
        nvim_lsp[lsp].setup {
          -- capabilities = capabilities,
          settings = settings
        }
      end
    end
  },

  {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    dependencies = {'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-path'},
    config = function()
      local cmp = require'cmp'
      cmp.setup({
        -- Enable LSP snippets
        -- snippet = {
        --   expand = function(args)
        --       vim.fn["vsnip#anonymous"](args.body)
        --   end,
        -- },

        -- Set completeopt to have a better completion experience
        -- :help completeopt│
        -- menuone: popup even when there's only one match
        -- noinsert: Do not insert text until a selection is made
        -- noselect: Do not select, force user to select one from the menu
        completion = {
          completeopt = 'menu,menuone,noinsert,noselect',
        },
        mapping = {
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          })
        },

        -- Installed sources
        sources = {
          { name = 'nvim_lsp' },
          -- { name = 'vsnip' },
          { name = 'path' },
          -- { name = 'buffer' },
          -- { name = 'vim-dadbod-completion' }
        },
      })

    end
  },

  {
    'ray-x/lsp_signature.nvim',
    dependencies = { "neovim/nvim-lspconfig", "hrsh7th/nvim-cmp" },
    -- event = "VeryLazy",
    opts = { bind = true, hint_prefix = "🐼 "},  -- add you config here
    config = function(_, opts) require'lsp_signature'.setup(opts) end
  },

  {
    'lvimuser/lsp-inlayhints.nvim',
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
      require("lsp-inlayhints").setup()
      vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
      vim.api.nvim_create_autocmd("LspAttach", {
        group = "LspAttach_inlayhints",
        callback = function(args)
          if not (args.data and args.data.client_id) then
            return
          end
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          require("lsp-inlayhints").on_attach(client, bufnr)
        end,
      })
      -- vim.api.nvim_set_hl can set the entire highlight group, not partialy update it
      vim.cmd [[ hi LspInlayHint guibg=#3a3a3a ]]
    end
  },

  {
    'kristijanhusak/vim-dadbod-ui',
    lazy = "VeryLazy",
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.api.nvim_create_autocmd('FileType', { pattern ="sql,mysql,plsql",
        callback= function()
          require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
        end
      })
    end,
  },

}