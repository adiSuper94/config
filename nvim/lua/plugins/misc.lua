-- if true then return {} end
return {
  {
    "github/copilot.vim",
    config = function()
      vim.api.nvim_set_keymap("i", "<C-k>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""
    end,
  },
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
      vim.opt.foldlevel = 99
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
      disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason", "oil", "pr", "help", "fugitive" },
    },
  },
}
