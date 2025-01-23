local navigator = "raw-dog" -- harpoon | raw-dog
if navigator == "raw-dog" then
  -- Just use marks
  return {}
end
return {
  {
    "ThePrimeagen/harpoon",
    enabled = navigator == "harpoon",
    branch = "harpoon2",
    keys = { "<leader><leader>", "<up>", "<down>" },
    dependencies = { "nvim-lua/plenary.nvim" },
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
}
