vim.g.mapleader = " " -- set leader to space
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
vim.opt.updatetime = 250
vim.opt.listchars = { tab = "▸ ", eol = "¬", trail = "·", nbsp = "␣", space = "·" }
vim.opt.winborder = "rounded"
vim.opt.diffopt:append("iwhite") -- ignore whitespace when diffing
vim.opt.completeopt = { "menu", "menuone", "noselect", "fuzzy", "popup" }
vim.opt.pumheight = 15
vim.opt.pummaxwidth = 60
vim.opt.pumborder = "rounded"
-- Fold Settings
vim.opt.foldlevelstart = 99
vim.opt.foldlevel = 99
vim.opt.foldcolumn = "0"

-- Why did I not know about this earlier??!
vim.opt.splitbelow = true -- open new split windows below the current window
vim.opt.splitright = true -- open new split windows to the right of the current wind

-- Netrw opts
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3

vim.keymap.set("n", "-", "<CMD>Explore<CR>", { desc = "raw-dog: Toggle Netrw" })
vim.keymap.set("n", "<leader>l", "<cmd>set list! <CR>", { desc = "Toggle blank line chars" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
vim.keymap.set("n", "<A-x>", "<cmd>bd <CR>", { desc = "Close buffer and window" })
vim.keymap.set("n", "<leader>x", "<cmd>bp | bd # <CR>", { desc = "Close Buffer" })
vim.keymap.set("n", "<C-n>", "<cmd>tabnew <CR>", { desc = "New tab" })
vim.keymap.set("n", "<C-w>z", "<cmd>wincmd | | wincmd _<CR>", { desc = "Maximize current window" })


-- Move lines up or down
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move lines up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move lines down" })

-- disable arrow keys
vim.keymap.set("n", "<right>", "<nop>", { desc = "Right arrow disabled" })
vim.keymap.set("n", "<left>", "<nop>", { desc = "Left arrow disabled" })
vim.keymap.set({ "n", "i" }, "<up>", "<nop>", { desc = "Up arrow disabled" })
vim.keymap.set({ "n", "i" }, "<down>", "<nop>", { desc = "Down arrow disabled" })

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

require("statusline")
require("fuzzysearch")
require("floaterminal")
require("plugins.git")
require("plugins.basic")
require("plugins.treesitter")
require("plugins.mini")
require("plugins.format")

vim.api.nvim_create_user_command("DBUI", function()
  vim.api.nvim_del_user_command("DBUI")
  require("plugins.db")
  print("DBUI Lazy Loaded")
  vim.api.nvim_command("DBUI")
end, { desc = "Initialize DBUI" })

vim.keymap.set("n", "<leader>b", function()
  require("plugins.dap")
  print("DAP Lazy Loaded")
  vim.keymap.del("n", "<leader>b")
end, { desc = "Debugger: Lazy load" })

vim.cmd([[ set shortmess +=c ]]) -- Avoid showing extra messages when using completion
vim.cmd.colorscheme("sundarban")

-- LSP setup
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end
    client.server_capabilities.semanticTokensProvider = nil
    vim.lsp.inlay_hint.enable(true)
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
    end
    if client:supports_method("textDocument/foldingRange") then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end
    if client:supports_method("textDocument/declaration") then
      map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    end
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end

    if client:supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
    end
    map("grd", function()
      vim.diagnostic.config({
        virtual_lines = not vim.diagnostic.config().virtual_lines,
      })
    end, "Show diagnostics")
    map("<space>q", vim.diagnostic.setloclist, "Open Diagnostic [Q]uickfix list")
  end,
})

vim.lsp.enable({ "denols", "ts_ls", "rust_analyzer", "gopls", "lua_ls", "clangd", "bashls", "jsonls", "ty" })
