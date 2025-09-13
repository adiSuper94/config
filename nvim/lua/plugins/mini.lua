vim.pack.add({
  { src = "https://github.com/echasnovski/mini.nvim" },
})
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
