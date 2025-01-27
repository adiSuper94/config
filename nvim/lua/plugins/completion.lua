local cmp_plugin = "hrsh7th" -- [hrsh7th | blink] default is hrsh7th
-- blink is the new cool kid on the block, has easier config for snippets and signature help.
-- But my hrsh7th setup is fairly simple as I dont use snippets. Wouldn't mind signature help.
-- is hrsh7th + ray signature help better than blink ? Don't know.
-- Might move to this if gets better (for me) than hrsh7th.
if cmp_plugin == "blink" then
  return {
    {
      "saghen/blink.cmp",
      -- dependencies = "rafamadriz/friendly-snippets",  -- enable when I like snippets
      event = "InsertEnter",
      version = "*",
      opts = {
        keymap = {
          preset = "default",
          -- Maybe fixed when 93541e4e45ddd06cd7efa9d65840936dff557fb3 is merged
          -- else create an issue
          ["<C-k>"] = { "fallback" },
          cmdline = {
            preset = "enter",
            ["<Tab>"] = { "show", "select_next", "fallback" },
            ["<S-Tab>"] = { "select_prev", "fallback" },
          },
        },
        appearance = {
          use_nvim_cmp_as_default = false,
          -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          nerd_font_variant = "mono",
        },
        sources = {
          default = { "lsp", "path", "buffer", "dadbod" }, -- "snippets" },
          providers = {
            dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
          },
        },
        completion = {
          -- list = { selection = { preselect = false, auto_insert = false } },
          menu = {
            auto_show = function(ctx)
              return ctx.mode ~= "cmdline"
            end,
            draw = {
              columns = {
                { "label", "label_description", gap = 1 },
                { "kind" },
              },
            },
          },
          documentation = { auto_show = true, auto_show_delay_ms = 500 },
        },
        signature = { enabled = true },
      },
      opts_extend = { "sources.default" },
    },
  }
else
  return {
    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-path" },
      config = function()
        local cmp = require("cmp")
        cmp.setup({
          -- Set completeopt to have a better completion experience
          -- :help completeopt│
          -- menuone: popup even when there's only one match
          -- noinsert: Do not insert text until a selection is made
          -- noselect: Do not select, force user to select one from the menu
          completion = {
            completeopt = "menu,menuone,noinsert,noselect",
          },
          mapping = {
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.close(),
            ["<CR>"] = cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Insert,
              select = true,
            }),
          },

          -- Installed sources
          sources = {
            { name = "nvim_lsp" },
            -- { name = 'vsnip' },
            { name = "path" },
            -- { name = 'buffer' },
          },
        })
      end,
    },
  }
end
