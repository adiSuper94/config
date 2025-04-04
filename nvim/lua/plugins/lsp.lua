return {
  -- { "j-hui/fidget.nvim", opts = {}, ft = { "rust" } }, -- disabling this if in favour of mini.notify. But still keeping this around in case I change my mind

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
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        lua = { "stylua" },
      },
      default_format_opts = { lsp_format = "fallback" },
    },
  },

  -- have to wait for https://github.com/neovim/neovim/issues/28261 to be resolved
  {
    "felpafel/inlay-hint.nvim",
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
