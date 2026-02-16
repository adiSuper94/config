function Rg()
  local pattern = vim.fn.input("rg: ")
  if pattern ~= "" then
    vim.cmd('silent grep! "' .. pattern .. '"')
    vim.cmd("copen")
  end
end

local files_cache = {}

function CachedFd(pattern)
  if #files_cache == 0 then
    local cmd = 'fd  --color=never --full-path --type file --hidden --exclude=".git"'
    files_cache = vim.fn.systemlist(cmd)
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

vim.api.nvim_create_autocmd("DirChanged", {
  pattern = "*",
  callback = function()
    files_cache = {}
  end,
})


vim.opt.grepprg = "rg --vimgrep --smart-case"
vim.opt.findfunc = "v:lua.CachedFd"
vim.api.nvim_create_user_command('Rg', Rg, { desc = "raw-dog: grep" })
vim.keymap.set("n", "<C-p>", ":find ", { desc = "raw-dog: Project Files" })
vim.keymap.set("n", "<leader>/", ":Rg<CR>", { desc = "raw-dog: grep" })
