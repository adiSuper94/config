-- Disable unnecessary plugins
vim.g.loaded_zipPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.have_nerd_font = true
vim.opt.number = true -- show line numbers
vim.opt.relativenumber = true -- show relative line numbers
vim.opt.mouse = "a" -- enable mouse support
vim.opt.showmode = false -- no need to show mode, since lightline does that
vim.opt.clipboard = "unnamedplus" -- use system clipboard
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- ignore case if search pattern is all lowercase
vim.opt.signcolumn = "yes" -- For Git Gutter to not flicker
vim.opt.timeoutlen = 500 -- time to wait for a mapped sequence to complete
vim.opt.cursorline = true -- highlight current line
vim.opt.breakindent = true -- indent wrapped lines. This does not reformat the text, just visually indents it
vim.opt.scrolloff = 5 -- keep n lines above and below the cursor
vim.opt.autoindent = true -- enable auto indent (default is true, but just to be sure)
vim.opt.autoread = true -- auto read file when changed outside of vim
vim.opt.wrap = true -- wrap lines, (default is true, but just to be sure)
vim.opt.linebreak = true -- wrap lines at convenient points
vim.opt.showbreak = "↪" -- show this character when a line is broken
vim.opt.textwidth = 100 -- line width/ column width before line wraps
vim.opt.colorcolumn = "100" -- highlight column width
vim.opt.expandtab = true -- insert spaces instead of tabs
vim.opt.softtabstop = 2 -- number of spaces that that is removed or added when tab or backspace is pressed
vim.opt.tabstop = 2 -- I honestly don't know how this is different from softtabstop
vim.opt.shiftwidth = 2 -- width used for indentation commands (<<, >>)
vim.opt.undofile = true
vim.opt.listchars = { tab = "▸ ", eol = "¬", trail = "·", nbsp = "␣", space = "·" }
vim.opt.diffopt:append("iwhite") -- ignore whitespace when diffing
vim.opt.autocomplete = true      -- autotriggers completions
vim.opt.completeopt = { "menu", "menuone", "noselect", "fuzzy", "popup" }
vim.opt.pumheight = 15
vim.opt.pummaxwidth = 60
vim.opt.pumborder = "rounded"
vim.opt.winborder = "rounded"

-- Fold Settings, Do not fold by default
vim.opt.foldlevelstart = 99
vim.opt.foldlevel = 99
vim.opt.foldcolumn = "0"

-- Why did I not know about this earlier??!
vim.opt.splitbelow = true -- open new split windows below the current window
vim.opt.splitright = true -- open new split windows to the right of the current wind

-- Netrw opts
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
