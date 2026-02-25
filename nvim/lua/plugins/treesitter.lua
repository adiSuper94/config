vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main",
    data = {
      run = function(_)
        vim.cmd "TSUpdate"
      end
    }
  },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
});

local ts = require("nvim-treesitter")
ts.setup({
  install_dir = vim.fn.stdpath('data') .. '/site'
})
ts.install({ "go", "typescript", "javascript", "rust" }):wait(5 * 60 * 1000)
require("nvim-treesitter-textobjects").setup {
  select = {
    lookahead = true,
    include_surrounding_whitespace = false,
  },
}

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

vim.keymap.set({ "x", "o" }, "af", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "if", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "aF", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@call.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "iF", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@call.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ac", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ic", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "al", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@loop.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "il", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@loop.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ad", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@conditional.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "id", function()
  require "nvim-treesitter-textobjects.select".select_textobject("@conditional.inner", "textobjects")
end)
vim.keymap.set("n", "<leader>a", function()
  require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner"
end, { desc = "Swap next parameter" })
vim.keymap.set("n", "<leader>A", function()
  require("nvim-treesitter-textobjects.swap").swap_previous "@parameter.outer"
end, { desc = "Swap previous parameter" })
