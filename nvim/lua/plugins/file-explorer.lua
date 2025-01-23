local explorer = "raw-dog" --- "oil" | "nvim-tree" | "raw-dog"
if explorer == "raw-dog" then
  -- Set up NetRW
  vim.g.netrw_banner = 0
  vim.g.netrw_liststyle = 3
  vim.keymap.set("n", "-", "<CMD>Explore<CR>", { desc = "raw-dog: Toggle Netrw" })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function()
      vim.api.nvim_buf_set_keymap(0, "n", "<up>", "<nop>", { desc = "Up arrow disabled" })
      vim.api.nvim_buf_set_keymap(0, "n", "<down>", "<nop>", { desc = "Down arrow disabled" })
      vim.api.nvim_buf_set_keymap(0, "n", "<left>", "<nop>", { desc = "Up arrow disabled" })
      vim.api.nvim_buf_set_keymap(0, "n", "<right>", "<nop>", { desc = "Down arrow disabled" })
    end,
  })
  return {}
end

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

return {
  {
    "kyazdani42/nvim-tree.lua",
    enabled = explorer == "nvim-tree",
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
    enabled = explorer == "oil",
    config = function()
      require("oil").setup({})
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end,
  },
}
