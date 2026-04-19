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
