-- if true then return {} end
return {
  "github/copilot.vim",
  -- {'preservim/vim-markdown' , ft = {'markdown'}},
  -- {'godlygeek/tabular', ft = {'markdown'}},

  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
    config = function()
      vim.keymap.set("n", "∂", "<Plug>NetrwRefresh") -- mapping random key to NetrwRefresh, so window navigation is easier
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      win = { border = "single" },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      require("telescope").setup({
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
      vim.keymap.set("n", "<A-f>", builtin.current_buffer_fuzzy_find, { desc = "Search in buffer" })
      vim.keymap.set("n", "<leader>'", builtin.marks, { desc = "Marks" })

      vim.keymap.set("n", "<leader>tj", builtin.builtin, { desc = "Telescope builtins" })
      vim.keymap.set("n", "<leader>af", builtin.find_files, { desc = "Telescope find files" })
      vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Telescope live grep" })
      vim.keymap.set("n", "<leader>ht", builtin.help_tags, { desc = "Telescope help tags" })

      require("telescope").load_extension("fzf")
      require("telescope").load_extension("ui-select")
    end,
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    keys = { "<leader><leader>", "<up>", "<down>" },
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
      vim.keymap.set("n", "<leader><leader>", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "Harpoon Menu" }) -- open marked files
      vim.keymap.set("n", "<leader>ha", function()
        harpoon:list():add()
      end, { desc = "Harpoon Add" }) -- add marked file
      vim.keymap.set("n", "<up>", function()
        harpoon:list():next()
      end, { desc = "Harpoon Next" }) -- next marked file
      vim.keymap.set("n", "<down>", function()
        harpoon:list():prev()
      end, { desc = "Harpoon Prev" }) -- previous marked file
    end,
  },

  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async", "nvim-treesitter/nvim-treesitter" },
    keys = { "za" },
    config = function()
      require("ufo").setup({
        open_fold_hl_timeout = 200,
        provider_selector = function(bufnr, filetype, buftype)
          return { "treesitter", "indent" }
        end,
      })
      vim.opt.foldlevelstart = 99
    end,
  },

  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      disable_mouse = false,
      disabled_keys = {
        ["<Up>"] = { "i" },
        ["<Down>"] = { "i" },
        ["<Left>"] = { "i" },
        ["<Right>"] = { "i" },
      },
      disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason", "oil", "pr" , "help"},
    },
  },
}
