-- Please see https://github.com/nvim-tree/nvim-tree.lua/wiki/Migrating-To-on_attach for assistance in migrating.
local function on_attach(bufnr)
  local api = require("nvim-tree.api")
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end
  api.config.mappings.default_on_attach(bufnr)
  -- You will need to insert "your code goes here" for any mappings with a custom action_cb
  vim.keymap.set("n", "h", api.tree.close, { desc = "Collapse" })
  vim.keymap.set("n", "l", api.node.open.edit, { desc = "Open" })
end

local use_oil = true
return {
  {
    "kyazdani42/nvim-tree.lua",
    enabled = not use_oil,
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function()
      vim.g.loaded_netrw = 1
      vim.gloaded_netrwPlugin = 1
      require("nvim-tree").setup({
        hijack_cursor = true,
        on_attach = on_attach,
      })
      require("nvim-web-devicons").get_icons()
      vim.keymap.set("n", "<leader>t", "<cmd>NvimTreeToggle <CR>", { desc = "Toggle file tree" })
    end,
  },

  {
    "stevearc/oil.nvim",
    enabled = use_oil,
    config = function()
      require("oil").setup({})
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end,
  },
}
