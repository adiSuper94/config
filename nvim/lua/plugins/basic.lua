vim.pack.add({
  "https://github.com/catgoose/nvim-colorizer.lua",
  "https://github.com/itchyny/lightline.vim",
  "https://github.com/hiphish/rainbow-delimiters.nvim",
  "https://github.com/prichrd/netrw.nvim",
  "https://github.com/echasnovski/mini.nvim",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter",             version = "master" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "master" },
  "https://github.com/mrjones2014/smart-splits.nvim",
  "https://github.com/stevearc/dressing.nvim",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/github/copilot.vim",
});

vim.api.nvim_set_keymap("i", "<C-k>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""


vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)
vim.keymap.set("n", "<C-\\>", require("smart-splits").move_cursor_previous)

require("colorizer").setup({
  filetypes = { "css", "sass", "rasi", "toml", "lua" },
})
require("netrw").setup({})

require("which-key").setup({ preset = "helix", win = { border = "single" } })

require("mini.surround").setup()
require("mini.pairs").setup()
require("mini.icons").setup()
local notify = require("mini.notify")
notify.setup()
vim.notify = notify.make_notify({
  ERROR = { duration = 5000 },
  WARN = { duration = 4000 },
  INFO = { duration = 3000 },
})

vim.g.lightline = {
  active = {
    left = {
      { "mode",      "paste" },
      { "gitbranch", "readonly", "filename", "modified" },
    },
    right = {
      { "lineinfo" },
      { "percent" },
      { "fileencoding", "filetype" },
    },
  },
  component_function = {
    gitbranch = "v:lua.LightlineGitBranch",
    filename = "v:lua.LightlineFilename",
    gitdiff = "v:lua.LightlineGitDiff"
  },
}

function LightlineGitDiff()
  if vim.b.gitsigns_status_dict then
    local status = vim.b.gitsigns_status_dict
    local added = status.added and status.added > 0 and ("+" .. status.added) or ""
    local changed = status.changed and status.changed > 0 and ("~" .. status.changed) or ""
    local removed = status.removed and status.removed > 0 and ("-" .. status.removed) or ""
    return table.concat({ added, changed, removed }, " ")
  else
    return ""
  end
end

function LightlineGitBranch()
  if vim.b.gitsigns_head and vim.b.gitsigns_head ~= "" then
    return " " .. vim.b.gitsigns_head
  else
    return ""
  end
end

function LightlineFilename()
  local git_root = vim.b.rootDir
  local path = vim.fn.expand("%:p")
  if git_root and path:sub(1, #git_root) == git_root then
    return path:sub(#git_root + 2) -- Remove the Git root and leading slash
  end
  return vim.fn.expand("%")
end

require("nvim-treesitter.configs").setup({
  ensure_installed = { "go", "typescript", "javascript", "rust", "vim", "vimdoc" },
  sync_install = false,
  auto_install = false,
  -- List of parsers to ignore installing (or "all")
  ignore_install = { "gitignore", "tmux" },
  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
  highlight = {
    enable = true,
    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    -- disable = { "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
      local highlight_disable_languages = {}
      for _, hd_lang in ipairs(highlight_disable_languages) do
        if hd_lang == lang then
          return true
        end
      end
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@call.outer",
        ["if"] = "@call.inner",
        ["aF"] = "@function.outer",
        ["iF"] = "@function.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["ic"] = "@class.inner",
        ["ac"] = "@class.outer",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["ad"] = "@conditional.outer",
        ["id"] = "@conditional.inner",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
  },
})
