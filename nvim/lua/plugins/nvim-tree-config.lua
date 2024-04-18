-- Please see https://github.com/nvim-tree/nvim-tree.lua/wiki/Migrating-To-on_attach for assistance in migrating.
local function on_attach(bufnr)
  local api = require('nvim-tree.api')
  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end
	api.config.mappings.default_on_attach(bufnr)
  -- You will need to insert "your code goes here" for any mappings with a custom action_cb
  vim.keymap.set('n', 'h', api.tree.close, opts('Close'))
  vim.keymap.set('n', 'l',  api.node.open.edit,           opts('Open'))
end


return {
  "kyazdani42/nvim-tree.lua",
  enabled = false,
  dependencies = { "kyazdani42/nvim-web-devicons" },
  config = function()
    vim.g.loaded_netrw = 1
    vim.gloaded_netrwPlugin = 1
    require("nvim-tree").setup({
      hijack_cursor = true,
      on_attach = on_attach,
    })
    require("nvim-web-devicons").get_icons()
    vim.keymap.set('n', '<leader>t', '<cmd>NvimTreeToggle <CR>', { noremap = true, silent = true})
  end,
}
