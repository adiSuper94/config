return {
  {
    "airblade/vim-gitgutter",
    config = function()
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePre" }, { command = "GitGutter" })
    end,
  },

  {
    "airblade/vim-rooter",
    lazy = false,
    config = function()
      vim.g.rooter_patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn" } --, 'Makefile', 'package.json'
    end,
  },

  { "tpope/vim-fugitive" },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen" },
  },
}
