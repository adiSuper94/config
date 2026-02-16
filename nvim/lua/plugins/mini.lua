vim.pack.add({
  "https://github.com/echasnovski/mini.nvim",
});

require("mini.surround").setup()
require("mini.pairs").setup()
require("mini.icons").setup()
require('mini.indentscope').setup()

local notify = require("mini.notify")
notify.setup()
vim.notify = notify.make_notify({
  ERROR = { duration = 5000 },
  WARN = { duration = 4000 },
  INFO = { duration = 3000 },
})

local hipatterns = require('mini.hipatterns')
hipatterns.setup({
  highlighters = {
    fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
    hack  = { pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHack'  },
    todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
    note  = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  },

    hex_color = hipatterns.gen_highlighter.hex_color(), -- Highlight hex strings (`#rrggbb`)
  },
})

local miniclue = require("mini.clue")
miniclue.setup({
  triggers = {
    { mode = { 'n', 'x' }, keys = '<Leader>' },
    { mode = 'n',          keys = '[' },
    { mode = 'n',          keys = ']' },
    { mode = 'i',          keys = '<C-x>' },
    { mode = { 'n', 'x' }, keys = 'g' },
    { mode = { 'n', 'x' }, keys = "'" },
    { mode = { 'n', 'x' }, keys = '`' },
    { mode = { 'n', 'x' }, keys = '"' },
    { mode = { 'i', 'c' }, keys = '<C-r>' },
    { mode = 'n',          keys = '<C-w>' },
    { mode = { 'n', 'x' }, keys = 'z' },
  },
  clues = {
    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  }
})
