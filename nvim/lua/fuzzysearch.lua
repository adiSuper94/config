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
  if pattern == '' then
    return files_cache
  end
  return vim.fn.matchfuzzy(files_cache, pattern)
end

function Fd(pattern, _)
  files_cache = {}
  return CachedFd(pattern)
end

vim.api.nvim_create_autocmd({ 'CmdlineChanged', 'CmdlineLeave' }, {
  pattern = { '*' },
  group = vim.api.nvim_create_augroup('CmdlineAutocompletion', { clear = true }),
  callback = function(ev)
    local function should_enable_autocomplete()
      local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), ' ')[1]
      return cmdline_cmd == 'find' or cmdline_cmd == 'help' or cmdline_cmd == 'h'
    end
    if ev.event == 'CmdlineChanged' and should_enable_autocomplete() then
      vim.opt.wildmode = 'noselect:lastused,full'
      vim.fn.wildtrigger()
    elseif ev.event == 'CmdlineLeave' then
      vim.opt.wildmode = 'full'
    end
  end
})


vim.opt.grepprg = "rg --vimgrep --smart-case"
vim.opt.findfunc = "v:lua.CachedFd"
vim.api.nvim_create_user_command('Rg', Rg, { desc = "raw-dog: grep" })
vim.keymap.set("n", "<C-p>", ":find ", { desc = "raw-dog: Project Files" })
vim.keymap.set("n", "g/", ":Rg<CR>", { desc = "raw-dog: grep" })
