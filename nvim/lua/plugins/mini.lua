return {
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      local ai = require("mini.ai")
      ai.setup({
        custom_textobjects = {
          F = ai.gen_spec.treesitter({a = "@function.outer", i = "@function.inner"}),
          f = ai.gen_spec.treesitter({a = "@call.outer", i = "@call.inner"}),
          a = ai.gen_spec.treesitter({a = "@parameter.outer", i = "@parameter.inner"}),
        }
      })
      require("mini.surround").setup()
      require("mini.pairs").setup()
    end,
  },
}
