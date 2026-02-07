return {
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
        javascript = { "oxfmt", "deno_fmt", "prettierd", "prettier", stop_after_first = true },
        typescript = { "oxfmt", "deno_fmt", "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        lua = { "stylua" },
        python = { "ruff_format" },
      },
      formatters = {
        deno_fmt = {
          command = "deno",
          args = { "fmt", "-" },
          stdin = true,
          condition = function(ctx)
            return vim.fs.root(0, { "deno.json", "deno.jsonc" })
          end,
        },
      },
      default_format_opts = { lsp_format = "fallback" },
    },
  },

  -- have to wait for https://github.com/neovim/neovim/issues/28261 to be resolved
  {
    "felpafel/inlay-hint.nvim",
    ft = { "typescript", "javascript", "javascriptreact", "typescriptreact", "c" },
    config = true,
  },

  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod",                     lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function(ev)
      vim.g.db_ui_use_nerd_fonts = 1
      -- vim.api.nvim_create_autocmd("FileType", {
      --   pattern = "sql,mysql,plsql",
      --   callback = function()
      --     require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } }) -- for nvim-cmp
      --     vim.opt_local.omnifunc = "vim_dadbod_completion#omni" -- for-omni
      --   end,
      -- })
    end,
  },
}
