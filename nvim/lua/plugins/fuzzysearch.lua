local searcher = "fff" --- "raw-dog" | "fff"

vim.opt.grepprg = "rg --vimgrep --smart-case"
function Rg()
  local pattern = vim.fn.input("rg: ")
  if pattern ~= "" then
    vim.cmd('silent grep! "' .. pattern .. '"')
    vim.cmd("copen")
  end
end

function Fd(file_pattern, _)
  -- if first char is * then fuzzy search
  if file_pattern:sub(1, 1) == "*" then
    file_pattern = file_pattern:gsub(".", ".*%0") .. ".*"
  end
  local cmd = 'fd  --color=never --full-path --type file --hidden --exclude=".git" "' .. file_pattern .. '"'
  local result = vim.fn.systemlist(cmd)
  return result
end

vim.opt.findfunc = "v:lua.Fd"
vim.api.nvim_create_user_command('Rg', Rg, {})
vim.keymap.set("n", "<leader>/", ":Rg<CR>", { desc = "raw-dog: grep" })

if searcher == "raw-dog" then
  vim.keymap.set("n", "<C-p>", ":find ", { desc = "raw-dog: Project Files" })
elseif searcher == "fff" then
  vim.pack.add({ 'https://github.com/dmtrKovalenko/fff.nvim' })

  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(event)
      if event.data.updated then
        require('fff.download').download_or_build_binary()
      end
    end,
  })

  vim.g.fff = {
    lazy_sync = true, -- start syncing only when the picker is open
    debug = {
      enabled = true,
      show_scores = true,
    },
  }

  vim.keymap.set(
    'n',
    '<C-p>',
    function() require('fff').find_files() end,
    { desc = 'FFFind files' }
  )
end
