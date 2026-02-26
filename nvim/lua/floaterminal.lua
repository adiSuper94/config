-- Shamelessly copied from teej_dv's Advent of Neovim [Video](https://www.youtube.com/watch?v=5PIiKDES_wc)
local state = {
  floating = {
    win = -1,
    buf = -1,
  },
}

local function create_floating_window(opts)
  opts = opts or {}
  -- calculate the width and height of the floating window, in #columns and #lines
  local width = opts.width or math.floor(vim.o.columns * 0.7)
  local height = opts.height or math.floor(vim.o.lines * 0.7)

  -- find the center of the nvim
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  -- create a new buffer if need, else reuse the existing one
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    -- first arg marks the buffer as unlisted, second arg marks the buffer as scratch
    buf = vim.api.nvim_create_buf(false, true)
  end
  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
  }
  local win = vim.api.nvim_open_win(buf, true, win_config)
  return { buf = buf, win = win }
end

local function toggle_terminal()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window({ buf = state.floating.buf })
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
      -- Opening a terminal marks the buffer as listed, so we need to unlist it
      vim.bo[state.floating.buf].buflisted = false
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {})
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  command = "startinsert",
})
vim.keymap.set("t", "<esc><esc>", "<C-\\><C-n>")
vim.keymap.set({ "t", "n" }, "<leader>tt", "<CMD>:Floaterminal<CR>", { desc = "Toggle Floating Terminal" })
