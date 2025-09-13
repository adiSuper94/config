vim.opt.foldlevelstart = 99
vim.opt.foldlevel = 99
vim.opt.foldcolumn = "0"
local fold_method = "raw-dog" -- ["raw-dog" | "ufo"]

if fold_method == "raw-dog" then
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
elseif fold_method == "ufo" then
  vim.pack.add({ src = "https://github.com/kevinhwang91/nvim-ufo" })
  require("ufo").setup({
    open_fold_hl_timeout = 200,
    provider_selector = function(bufnr, filetype, buftype)
      return { "treesitter", "indent" }
    end,
  })
end
