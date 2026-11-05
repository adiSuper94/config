function Rg()
  local pattern = vim.fn.input("rg: ")
  if pattern ~= "" then
    vim.cmd('silent grep! "' .. pattern .. '"')
    vim.cmd("copen")
  end
end

-- vim.fn.chdir does not trigger, DirChanged. https://github.com/neovim/neovim/issues/32270
local files_cache = {}
local cwd = ""

function CachedFd(pattern)
  local current_cwd = vim.fn.getcwd()
  if #files_cache == 0 or cwd ~= current_cwd then
    local cmd = 'fd  --color=never --full-path --type file --hidden --exclude=".git"'
    files_cache = vim.fn.systemlist(cmd)
    cwd = current_cwd
  end
  if pattern == "" then
    return files_cache
  end
  return vim.fn.matchfuzzy(files_cache, pattern)
end

function Fd(pattern, _)
  files_cache = {}
  return CachedFd(pattern)
end

-- use ui2 cmd buffer as file picker
local ui2 = require("vim._core.ui2")
local ns = vim.api.nvim_create_namespace("fuzzysearch")
local max_shown = 10
local list = { items = {}, selected = 1, top = 1, skip_update = false }

local function render()
  local buf = ui2.bufs.cmd
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  local icons = require("mini.icons")
  local lines = {}
  for i = list.top, math.min(#list.items, list.top + max_shown - 1) do
    local path = list.items[i]
    local icon, hl = icons.get("file", path)
    local sel = i == list.selected and "PmenuSel" or nil
    lines[#lines + 1] = { { "  ", sel }, { icon, sel or hl }, { " " .. path, sel } }
  end
  if #lines > 0 then
    -- Left gravity keeps the mark on the prompt line when ui2 rewrites it.
    vim.api.nvim_buf_set_extmark(buf, ns, 0, 0, { virt_lines = lines, right_gravity = false })
  end
end

local M = {}

-- Select a match and put it in the cmdline, so <CR> opens it with plain :find.
function M.select(step)
  local sel = (list.selected + step - 1) % #list.items + 1
  list.selected = sel
  list.top = math.max(math.min(list.top, sel), sel - max_shown + 1)
  list.skip_update = true
  vim.fn.setcmdline("find " .. vim.fn.fnameescape(list.items[sel]))
end

-- Keys that move through the list while it is shown, and behave as usual otherwise.
local function map_list_key(lhs, step, desc, after)
  vim.keymap.set("c", lhs, function()
    if #list.items == 0 then
      return lhs
    end
    return ("<Cmd>lua require('fuzzysearch').select(%d)<CR>%s"):format(step, after or "")
  end, { expr = true, desc = desc })
end

vim.o.wildcharm = vim.keycode("<Tab>"):byte()
map_list_key("<Tab>", 1, "Fuzzy search: next item")
map_list_key("<S-Tab>", -1, "Fuzzy search: previous item")
map_list_key("<C-n>", 1, "Fuzzy search: next item")
map_list_key("<C-p>", -1, "Fuzzy search: previous item")
map_list_key("<Down>", 1, "Fuzzy search: next item")
map_list_key("<Up>", -1, "Fuzzy search: previous item")
map_list_key("<C-y>", 0, "Fuzzy search: accept item", "<CR>")

local group = vim.api.nvim_create_augroup("CmdlineAutocompletion", { clear = true })

vim.api.nvim_create_autocmd("CmdlineChanged", {
  group = group,
  pattern = ":",
  callback = function()
    local line = vim.fn.getcmdline()
    if not list.skip_update then
      local pattern = line:match("^find (.*)")
      list.items = pattern and CachedFd(pattern) or {}
      list.selected, list.top = 1, 1
    end
    list.skip_update = false
    render()

    local cmd = line:match("^%S+")
    if cmd == "help" or cmd == "h" then
      vim.opt.wildmode = "noselect:lastused,full"
      vim.fn.wildtrigger()
    end
  end,
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
  group = group,
  pattern = ":",
  callback = function()
    list.items = {}
    render()
    vim.opt.wildmode = "full"
  end,
})

vim.opt.grepprg = "rg --vimgrep --smart-case"
vim.opt.findfunc = "v:lua.CachedFd"
vim.api.nvim_create_user_command("Rg", Rg, { desc = "raw-dog: grep" })
vim.keymap.set("n", "<C-p>", ":find ", { desc = "raw-dog: Project Files" })
vim.keymap.set("n", "g/", ":Rg<CR>", { desc = "raw-dog: grep" })

return M
