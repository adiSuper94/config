vim.api.nvim_create_autocmd("VimResized", { command = "wincmd =" })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank({ timeout = 500 })
  end,
})

-- Remove trailing whitespace
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})
