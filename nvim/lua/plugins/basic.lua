vim.pack.add({
  "https://github.com/hiphish/rainbow-delimiters.nvim",
  "https://github.com/prichrd/netrw.nvim",
  "https://github.com/mrjones2014/smart-splits.nvim",
  "https://github.com/stevearc/dressing.nvim",
  "https://github.com/github/copilot.vim",
});

vim.api.nvim_set_keymap("i", "<C-k>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""


vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)
vim.keymap.set("n", "<C-\\>", require("smart-splits").move_cursor_previous)

require("netrw").setup({})


