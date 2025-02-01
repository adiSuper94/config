local searcher = "raw-dog" --- "telescope" | "raw-dog"
if searcher == "raw-dog" then
  vim.opt.grepprg = "rg --vimgrep --smart-case"
  vim.keymap.set("n", "<leader>/", function()
    local pattern = vim.fn.input("rg: ")
    if pattern ~= "" then
      vim.cmd("silent grep! " .. pattern)
      vim.cmd("copen")
    end
  end, { desc = "raw-dog: Live grep" })

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
  vim.keymap.set("n", "<C-p>", ":find ", { desc = "raw-dog: Project Files" })
  return {}
end

return {
  {
    "nvim-telescope/telescope.nvim",
    enabled = searcher == "telescope",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      local default_theme = "dropdown"
      require("telescope").setup({
        pickers = {
          find_files = {
            theme = default_theme,
            previewer = false,
          },
          git_files = {
            theme = default_theme,
            previewer = false,
          },
          builtin = {
            theme = default_theme,
            previewer = false,
          },
          current_buffer_fuzzy_find = {
            previewer = false,
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_ivy(),
          },
        },
      })
      local utils = require("telescope.utils")
      local builtin = require("telescope.builtin")
      local project_files = function()
        local _, ret, _ = utils.get_os_command_output({ "git", "rev-parse", "--is-inside-work-tree" })
        if ret == 0 then
          builtin.git_files()
        else
          builtin.find_files()
        end
      end
      vim.keymap.set("n", "<C-p>", project_files, { desc = "Project Files" })

      vim.keymap.set("n", "<leader>tj", builtin.builtin, { desc = "Telescope builtins" })
      vim.keymap.set("n", "<leader>tf", builtin.find_files, { desc = "Telescope find files" })
      vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Telescope live grep" })
      vim.keymap.set("n", "<leader>th", builtin.help_tags, { desc = "Telescope help tags" })
      vim.keymap.set("n", "<leader>c", function()
        builtin.git_files({ cwd = "~/.config/nvim/" })
      end, { desc = "Open nvim init.lua" })

      require("telescope").load_extension("fzf")
      require("telescope").load_extension("ui-select")
    end,
  },
}
