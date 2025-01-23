vim.g.mapleader = " " -- set leader to space
vim.g.have_nerd_font = true
vim.opt.number = true -- show line numbers
vim.opt.relativenumber = true -- show relative line numbers
vim.opt.mouse = "a" -- enable mouse support
vim.opt.showmode = false -- no need to show mode, since we have airline
vim.opt.clipboard = "unnamedplus" -- use system clipboard
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- ignore case if search pattern is all lowercase
vim.opt.signcolumn = "yes" -- For Git Gutter to not flicker
vim.opt.timeoutlen = 500 -- time to wait for a mapped sequence to complete
vim.opt.cursorline = true -- highlight current line
vim.opt.breakindent = true -- indent wrapped lines. This does not reformate the text, just visually indents it
vim.opt.scrolloff = 5 -- keep n lines above and below the cursor
vim.opt.autoindent = true -- enable autoindent (default is true, but just to be sure)
vim.opt.autoread = true -- auto read file when changed outside of vim
vim.opt.wrap = true -- wrap lines, (default is true, but just to be sure)
vim.opt.linebreak = true -- wrap lines at convenient points
vim.opt.showbreak = "↪" -- show this character when a line is broken
vim.opt.textwidth = 100 -- line width/ column width before line wraps
vim.opt.colorcolumn = "100" -- highlight column width
vim.opt.expandtab = true -- insert spaces instead of tabs
vim.opt.softtabstop = 2 -- number of spaces that that is removed or added when tab or backspace is pressed
vim.opt.tabstop = 2 -- I honestly don't know how this is different from softtabstop
vim.opt.shiftwidth = 2 -- witdth used for indetation commands (<<, >>)
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.listchars = { tab = "▸ ", eol = "¬", trail = "·", nbsp = "␣" }

-- Why did I not know about this earlier??!
vim.opt.splitbelow = true -- open new split windows below the current window
vim.opt.splitright = true -- open new split windows to the right of the current wind


vim.keymap.set("n", "<leader>l", "<cmd>set list! <CR>", { desc = "Toggle blank line chars" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
vim.keymap.set("n", "<right>", "<cmd>bn<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<left>", "<cmd>bp<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<A-x>", "<cmd>bd <CR>", { desc = "Close buffer and window" })
vim.keymap.set("n", "<leader>x", "<cmd>bp | bd # <CR>", { desc = "Close Buffer" })
vim.keymap.set("n", "<A-w>", "<cmd>w <CR>", { desc = "Save buffer" })
vim.keymap.set("n", "<C-n>", "<cmd>tabnew <CR>", { desc = "New tab" })
vim.keymap.set("n", "<leader>,", "<cmd>wincmd < <CR>", { desc = "Move to left window" })
vim.keymap.set("n", "<leader>.", "<cmd>wincmd > <CR>", { desc = "Increase window width" })
vim.keymap.set("n", "<leader>z", "<cmd>wincmd | | wincmd _<CR>", { desc = "Maximize current window" })
vim.keymap.set("n", "<leader>=", "<cmd>wincmd = <CR>", { desc = "Equalize window size" })
vim.keymap.set("n", "≈", "<cmd>bd <CR>", { desc = "Close buffer and window (Mac)" })
vim.keymap.set("n", "∑", "<cmd>w <CR>", { desc = "Save buffer (Mac)" })

-- disable arrow keys in insert mode
vim.keymap.set("i", "<up>", "<nop>", { desc = "Up arrow disabled" })
vim.keymap.set("i", "<down>", "<nop>", { desc = "Down arrow disabled" })

vim.api.nvim_create_autocmd("VimResized", { command = "wincmd =" })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ timeout = 500 })
  end,
})

-- Remove trailing whitespace
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  ui = { border = "rounded" },
  spec = "plugins",
  change_detection = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "tohtml",
        "gzip",
        "rplugin",
        "tarPlugin",
        -- "netrwPlugin",
        "zipPlugin",
        "tutor",
      },
    },
  },
})

vim.cmd([[ set shortmess +=c ]]) -- Avoid showing extra messages when using completion
vim.cmd([[ highlight Normal guibg=NONE ctermbg=NONE ]])
vim.cmd([[ highlight @comment guifg=#afafaf ]]) --comments are important AFAFAF
