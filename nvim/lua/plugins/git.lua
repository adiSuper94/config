return {
  {
    "lewis6991/gitsigns.nvim",
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
          end, { desc = "Set QF List" })
          map("n", "<leader>hq", gitsigns.setqflist, { desc = "Set QF List" })

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
      vim.api.nvim_set_hl(0, "GitSignsChangeDelete", { fg = get_color("GitSignsChangeDelete", "fg"), bg = color })
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