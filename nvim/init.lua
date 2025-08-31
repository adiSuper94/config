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
vim.opt.updatetime = 250
vim.opt.listchars = { tab = "▸ ", eol = "¬", trail = "·", nbsp = "␣", space = "·" }
vim.opt.winborder = "rounded"
vim.opt.diffopt:append("iwhite") -- ignore whitespace when diffing
vim.opt.completeopt = { "menu", "menuone", "noselect", "popup" }

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

if vim.g.colors_name ~= "gruber-darker" then -- gruber-darker has a nice brown color for comments
  vim.cmd([[ highlight @comment guifg=#afafaf ]]) --comments are important AFAFAF
else
  vim.cmd([[ highlight LspInlayHint guifg=#40443d ]]) -- grubber-darker has confusing colors for inlay hints
end

vim.cmd([[ set shortmess +=c ]]) -- Avoid showing extra messages when using completion

-- LSP setup
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    client.server_capabilities.semanticTokensProvider = nil
    vim.lsp.inlay_hint.enable(true)
    -- if client:supports_method("textDocument/completion") then
    --   vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
    -- end
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
    end
    if client:supports_method("textDocument/foldingRange") then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end
    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    map("gd", vim.lsp.buf.definition, "[G]oto [d]efinition")
    map("<C-s>", vim.lsp.buf.signature_help, "Show signature help")
    map("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
    map("<space>r", vim.lsp.buf.rename, "[R]ename")
    map("<space>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
    -- map("<space>D", vim.lsp.buf.type_definition, "Show type definition")
    map("<space>e", function()
      vim.diagnostic.config({
        virtual_lines = not vim.diagnostic.config().virtual_lines,
      })
    end, "Show diagnostics")
    map("<space>E", vim.diagnostic.open_float, "Show [E]rror")
    map("<space>q", vim.diagnostic.setloclist, "Open Diagnostic [Q]uickfix list")
    -- map("<C-space>", vim.lsp.completion.get, "Trigger Completions", "i")
  end,
})

vim.lsp.enable({ "denols", "ts_ls", "rust_analyzer", "gopls", "lua_ls", "clangd", "bashls", "jsonls", "pyright" })
