vim.g.mapleader = " " -- set leader to space

require("statusline")
require("fuzzysearch")
require("floaterminal")
require("vim_rooter")
require("plugin.git")
require("plugin.basic")
require("plugin.treesitter")
require("plugin.mini")
require("plugin.format")

vim.cmd([[ set shortmess +=c ]]) -- Avoid showing extra messages when using completion
vim.cmd.colorscheme("sundarban")

require("vim._core.ui2").enable({})
vim.cmd.packadd("nvim.undotree")
