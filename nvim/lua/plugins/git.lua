return {
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    config = function()
      require("gitsigns").setup({
        signs_staged_enable = true,
        on_attach = function(bufnr)
          local gitsigns = require("gitsigns")
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]h", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]h", bang = true })
            else
              gitsigns.nav_hunk("next")
            end
          end, { desc = "Next Hunk" })

          map("n", "[h", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[h", bang = true })
            else
              gitsigns.nav_hunk("prev")
            end
          end, { desc = "Previous Hunk" })

          -- Actions
          map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage Hunk" })
          map("n", "<leader>hu", gitsigns.reset_hunk, { desc = "Reset Hunk" })

          map("v", "<leader>hs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Stage Hunk" })

          map("v", "<leader>hu", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Reset Hunk" })

          map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage Buffer" })
          map("n", "<leader>hU", gitsigns.reset_buffer, { desc = "Reset Buffer" })
          map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview Hunk" })
          map("n", "<leader>hP", gitsigns.preview_hunk_inline, { desc = "Preview Hunk Inline" })

          map("n", "<leader>hb", function()
            gitsigns.blame_line({ full = true })
          end, { desc = "Blame Line" })

          map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff This" })

          map("n", "<leader>hD", function()
            gitsigns.diffthis("~")
          end, { desc = "Diff This" })

          map("n", "<leader>hQ", function()
            gitsigns.setqflist("all")
          end, { desc = "Set Repo QF List" })
          map("n", "<leader>hq", gitsigns.setqflist, { desc = "Set Buffer QF List" })

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Hunk" })
          map({ "o", "x" }, "ah", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Hunk" })
        end,
      })
      local function get_color(group, attr)
        local fn = vim.fn
        return fn.synIDattr(fn.synIDtrans(fn.hlID(group)), attr)
      end
      local color = vim.api.nvim_get_hl_by_name("SignColumn", true).background
      vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = get_color("GitSignsAdd", "fg"), bg = color })
      vim.api.nvim_set_hl(0, "GitSignsChange", { fg = get_color("GitSignsChange", "fg"), bg = color })
      vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = get_color("GitSignsDelete", "fg"), bg = color })
      vim.api.nvim_set_hl(0, "GitSignsTopdelete", { fg = get_color("GitSignsTopdelete", "fg"), bg = color })
      vim.api.nvim_set_hl(0, "GitSignsChangedelete", { fg = get_color("GitSignsChangedelete", "fg"), bg = color })
      vim.api.nvim_set_hl(0, "GitSignsUntracked", { fg = get_color("GitSignsUntracked", "fg"), bg = color })
      vim.api.nvim_set_hl(0, "GitSignsStagedAdd", { fg = get_color("GitSignsStagedAdd", "fg"), bg = color })
      vim.api.nvim_set_hl(0, "GitSignsStagedChange", { fg = get_color("GitSignsStagedChange", "fg"), bg = color })
      vim.api.nvim_set_hl(0, "GitSignsStagedDelete", { fg = get_color("GitSignsStagedDelete", "fg"), bg = color })
      vim.api.nvim_set_hl(0, "GitSignsStagedTopdelete", { fg = get_color("GitSignsStagedTopdelete", "fg"), bg = color })
      vim.api.nvim_set_hl(
        0,
        "GitSignsStagedChangedelete",
        { fg = get_color("GitSignsStagedChangedelete", "fg"), bg = color }
      )
    end,
  },

  {
    "airblade/vim-rooter",
    lazy = false,
    config = function()
      vim.g.rooter_patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn" } --, 'Makefile', 'package.json'
    end,
  },

  -- { "tpope/vim-fugitive" },

  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "folliehiyuki/diffview.nvim", -- optional - Diff integration
    },
  },

  {
    "folliehiyuki/diffview.nvim",
    branch = "mini-icons",
    cmd = { "DiffviewOpen" },
  },
}
