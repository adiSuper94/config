vim.pack.add({
  "https://github.com/stevearc/conform.nvim",
  { src = "https://github.com/felpafel/inlay-hint.nvim", version = "nightly" },
})

-- have to wait for https://github.com/neovim/neovim/issues/28261 to be resolved
require('inlay-hint').setup()

require("conform").setup({
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
})
vim.keymap.set("n", "<leader>f", function() require("conform").format({ async = true }) end, { desc = "Format file" })
