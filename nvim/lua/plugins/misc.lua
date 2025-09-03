-- if true then return {} end
local term = os.getenv("TERM")
local is_tmux = false
if term == "alacritty" or term == "foot" or term == "tmux-256color" or term == "screen-256color" then
  is_tmux = true
end

return {
  {
    "github/copilot.vim",
    enabled = false,
    config = function()
      vim.api.nvim_set_keymap("i", "<C-k>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""
    end,
  },

  {
    "christoomey/vim-tmux-navigator",
    enabled = is_tmux,
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

  { "stevearc/dressing.nvim", opts = {} }, -- I'll use this if I remove find a telescope less workflow

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      win = { border = "single" },
    },
  },
}
