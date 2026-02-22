vim.pack.add({
  "https://github.com/kristijanhusak/vim-dadbod-ui",
  "https://github.com/tpope/vim-dadbod",
  "https://github.com/kristijanhusak/vim-dadbod-completion"
})
vim.g.db_ui_use_nerd_fonts = 1
vim.api.nvim_create_autocmd("FileType", {
  pattern = "sql,mysql,plsql",
  callback = function()
    vim.opt_local.omnifunc = "vim_dadbod_completion#omni"   -- for-omni
  end,
})
