local searcher = "telescope" --- "telescope" | "raw-dog"
if searcher == "raw-dog" then
  vim.opt.grepprg = "rg --vimgrep --smart-case"
  vim.keymap.set("n", "<leader>/", function()
    local pattern = vim.fn.input("rg: ")
    if pattern ~= "" then
      vim.cmd("silent grep! " .. pattern)
      vim.cmd("copen")
    end
  end, { desc = "raw-dog: Live grep" })

  vim.opt.path:append("**") -- search in subdirectories
  vim.opt.wildignore:append("*/node_modules/**")
  vim.opt.wildignore:append("*/build/**")
  vim.opt.wildignore:append("*/target/**")
  vim.opt.wildignore:append("*/.git/**")
  local find_files = function()
    local pattern = vim.fn.input("Find: ")
    pattern = pattern:gsub(".", "%1*")
    if pattern ~= "" then
      vim.fn.feedkeys(":find " .. pattern .. "\t", "t")
    end
  end
  vim.keymap.set("n", "<C-p>", find_files, { desc = "raw-dog: Project Files" }) -- Still very slow in mac
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
