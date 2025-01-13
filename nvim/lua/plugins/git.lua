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

  {
    "ThePrimeagen/git-worktree.nvim",
    enabled = false,
    event = "VeryLazy",
    keys = { { "<leader>gw", desc = "Load git.worktree.nvim" } },
    dependencies = { "telescope/telescope.nvim" },
    config = function()
      require("git-worktree").setup({})
      if pcall(require, "which-key") then
        local wk = require("which-key")
        if wk then
          wk.add({
            { "<leader>g", group = "Git" },
            { "<leader>gw", group = "Worktree" },
          })
        end
      end
      require("telescope").load_extension("git_worktree")
      twt = require("telescope").extensions.git_worktree
      vim.keymap.set("n", "<leader>gwl", twt.git_worktrees, { desc = "Git Worktrees: List" })
      vim.keymap.set("n", "<leader>gwc", twt.create_git_worktree, { desc = "Git Worktrees: Create" })
    end,
  },

  { "tpope/vim-fugitive" },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen" },
  },

  {
    "ldelossa/gh.nvim",
    keys = { { "<leader>gh", desc = "Load Github" } },
    dependencies = {
      {
        "ldelossa/litee.nvim",
        config = function()
          require("litee.lib").setup({ icon_set = "nerd" })
        end,
      },
      "nvim-telescope/telescope.nvim",
      "folke/which-key.nvim",
    },
    config = function()
      require("litee.gh").setup({
        icon_set = "nerd",
      })
      local wk = require("which-key")
      wk.add({
        { "<leader>g", group = "Git" },
        { "<leader>gh", group = "Github" },
        { "<leader>ghc", group = "Commits" },
        { "<leader>ghcc", "<cmd>GHCloseCommit<cr>", desc = "Close" },
        { "<leader>ghce", "<cmd>GHExpandCommit<cr>", desc = "Expand" },
        { "<leader>ghco", "<cmd>GHOpenToCommit<cr>", desc = "Open To" },
        { "<leader>ghcp", "<cmd>GHPopOutCommit<cr>", desc = "Pop Out" },
        { "<leader>ghcz", "<cmd>GHCollapseCommit<cr>", desc = "Collapse" },
        { "<leader>ghi", group = "Issues" },
        { "<leader>ghip", "<cmd>GHPreviewIssue<cr>", desc = "Preview" },
        { "<leader>ghl", group = "Litee" },
        { "<leader>ghlt", "<cmd>LTPanel<cr>", desc = "Toggle Panel" },
        { "<leader>ghp", group = "Pull Request" },
        { "<leader>ghpc", "<cmd>GHClosePR<cr>", desc = "Close" },
        { "<leader>ghpd", "<cmd>GHPRDetails<cr>", desc = "Details" },
        { "<leader>ghpe", "<cmd>GHExpandPR<cr>", desc = "Expand" },
        { "<leader>ghpo", "<cmd>GHOpenPR<cr>", desc = "Open" },
        { "<leader>ghpp", "<cmd>GHPopOutPR<cr>", desc = "PopOut" },
        { "<leader>ghpr", "<cmd>GHRefreshPR<cr>", desc = "Refresh" },
        { "<leader>ghpt", "<cmd>GHOpenToPR<cr>", desc = "Open To" },
        { "<leader>ghpz", "<cmd>GHCollapsePR<cr>", desc = "Collapse" },
        { "<leader>ghr", group = "Review" },
        { "<leader>ghrb", "<cmd>GHStartReview<cr>", desc = "Begin" },
        { "<leader>ghrc", "<cmd>GHCloseReview<cr>", desc = "Close" },
        { "<leader>ghrd", "<cmd>GHDeleteReview<cr>", desc = "Delete" },
        { "<leader>ghre", "<cmd>GHExpandReview<cr>", desc = "Expand" },
        { "<leader>ghrs", "<cmd>GHSubmitReview<cr>", desc = "Submit" },
        { "<leader>ghrz", "<cmd>GHCollapseReview<cr>", desc = "Collapse" },
        { "<leader>ght", group = "Threads" },
        { "<leader>ghtc", "<cmd>GHCreateThread<cr>", desc = "Create" },
        { "<leader>ghtn", "<cmd>GHNextThread<cr>", desc = "Next" },
        { "<leader>ghtt", "<cmd>GHToggleThread<cr>", desc = "Toggle" },
      })
    end,
  },
}
