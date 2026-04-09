vim.pack.add({
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/airblade/vim-rooter",
})

require("gitsigns").setup({
  signs_staged_enable = true,
  on_attach = function(bufnr)
    local gitsigns = require("gitsigns")
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      if vim.wo.diff then
        vim.cmd.normal({ l, bang = true })
      else
        vim.keymap.set(mode, l, r, opts)
      end
    end

    -- Navigation
    map("n", "]c", function()
      gitsigns.nav_hunk("next")
    end, { desc = "Next Hunk" })

    map("n", "[c", function()
      gitsigns.nav_hunk("prev")
    end, { desc = "Previous Hunk" })

    -- Actions
    map("n", "do", gitsigns.preview_hunk, { desc = "Preview Hunk" })
    map("n", "dO", gitsigns.stage_hunk, { desc = "Toggle staged Hunk" })
    map("n", "dp", gitsigns.reset_hunk, { desc = "Reset Hunk" })
    map("n", "gB", gitsigns.blame_line, { desc = "Blame Line" })

    map("v", "dO", function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Stage Visual Hunk" })
    map("v", "dp", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Reset Visual Hunk" })

    map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff This" })

    map("n", "<leader>hQ", function()
      gitsigns.setqflist("all")
    end, { desc = "Set Repo QF List" })
    map("n", "<leader>hq", gitsigns.setqflist, { desc = "Set Buffer QF List" })

    -- Text object
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Hunk" })
    map({ "o", "x" }, "ah", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Hunk" })
  end,
})

vim.g.rooter_patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn" } --, 'Makefile', 'package.json'
