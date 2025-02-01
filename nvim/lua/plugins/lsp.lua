-- if true then return {} end
return {
  -- { "j-hui/fidget.nvim", opts = {}, ft = { "rust" } }, -- disabling this if in favour of mini.notify. But still keeping this around in case I change my mind

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },
    },
    config = function()
      vim.keymap.del({ "n", "x" }, "gra")
      vim.keymap.del("n", "gri")
      vim.keymap.del("n", "grn")
      vim.keymap.del("n", "grr")
      vim.keymap.del("n", "gO")
      local nvim_lsp = require("lspconfig")
      -- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
      local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
      function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or "rounded"
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
      end

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          client.server_capabilities.semanticTokensProvider = nil
          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          vim.lsp.inlay_hint.enable(true)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
          end
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
          map("gd", vim.lsp.buf.definition, "[G]oto [d]efinition")
          map("gr", vim.lsp.buf.references, "[G]oto [r]eferences")
          map("K", vim.lsp.buf.hover, "Show hover")
          map("gO", vim.lsp.buf.document_symbol, "Object QFList")
          map("gi", vim.lsp.buf.implementation, "[G]oto [i]mplementation")
          map("gs", vim.lsp.buf.signature_help, "Show signature help")
          map("<space>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
          map("<space>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
          map("<space>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, "List workspace folders")
          map("<space>D", vim.lsp.buf.type_definition, "Show type definition")
          map("<space>r", vim.lsp.buf.rename, "[R]ename")
          map("<space>ca", vim.lsp.buf.code_action, "Show [C]ode [A]ction", { "n", "x" })
          map("<space>e", vim.diagnostic.open_float, "Show diagnostics")
          map("[d", vim.diagnostic.goto_prev, "Go to previous diagnostic")
          map("]d", vim.diagnostic.goto_next, "Go to next diagnostic")
          map("<space>q", vim.diagnostic.setloclist, "Open Diagnostic [Q]uickfix list")
          -- vim.cmd([[hi! link LspReferenceText CursorColumn]])
          -- vim.cmd([[hi! link LspReferenceRead CursorColumn]])
          -- vim.cmd([[hi! link LspReferenceWrite CursorColumn]])
          -- vim.cmd([[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]])
          -- vim.cmd([[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]])
          -- vim.cmd([[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]])
        end,
      })
      local settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "none",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
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
          },
        },
        ["rust-analyzer"] = {
          procMacro = { enable = true },
          diagnostics = {
            enable = true,
            disabled = { "unresolved-proc-macro", "missing-unsafe" },
          },
        },
      }
      -- local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
      -- capabilities.textDocument.completion.completionItem.snippetSupport = false
      local servers = { "jsonls", "clangd", "pyright", "rust_analyzer", "gopls", "ts_ls", "bashls", "lua_ls" }
      for _, lsp in pairs(servers) do
        nvim_lsp[lsp].setup({
          -- capabilities = capabilities,
          settings = settings,
        })
      end
    end,
  },

  {
    "stevearc/conform.nvim",
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true })
        end,
        desc = "Format file",
      },
    },
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        javascript = { "prettierd", "prettier", stop_after_first = true },
        lua = { "stylua" },
      },
      default_format_opts = { lsp_format = "fallback" },
    },
  },

  -- have to wait for https://github.com/neovim/neovim/issues/28261 to be resolved
  {
    "felpafel/inlay-hint.nvim",
    branch = "nightly",
    ft = { "typescript", "javascript" },
    config = true,
  },

  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      -- vim.api.nvim_create_autocmd("FileType", {
      --   pattern = "sql,mysql,plsql",
      --   callback = function()
      --     require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
      --   end,
      -- })
    end,
  },
}
