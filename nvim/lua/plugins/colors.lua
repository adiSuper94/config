-- if true then return {} end

return {
  {
    "thimc/gruber-darker.nvim",
    priority = 1000,
    config = function()
      require("gruber-darker").setup({ transparent = true })
      vim.cmd.colorscheme("gruber-darker")
    end,
  },

  --  {
  --   "ellisonleao/gruvbox.nvim",
  --   priority = 1000,
  --   config = function()
  --     require("gruvbox").setup({
  --       transparent_mode = true,
  --     })
  --     vim.cmd.colorscheme("gruvbox")
  --   end,
  -- },

  -- {
  --   "Shatur/neovim-ayu",
  --   priority = 1000,
  --   config = function()
  --     require("ayu").setup({
  --       overrides = {
  --         Normal = { bg = "None" }
  --       },
  --     })
  --     vim.cmd.colorscheme("ayu-dark")
  --   end,
  -- },

  -- {
  --   "folke/tokyonight.nvim",
  --   priority = 1000,
  --   opts = {},
  --   config = function()
  --     require("tokyonight").setup({
  --       transparent = true,
  --     })
  --     vim.cmd.colorscheme("tokyonight")
  --   end,
  -- },

  -- {
  --   "RRethy/base16-nvim",
  --   priority = 1000,
  --   config = function()
  --     require("base16-colorscheme").with_config({
  --       telescope_borders = true,
  --     })
  --     vim.cmd.colorscheme("base16-gruvbox-dark-hard")
  --   end,
  -- },

  {
    "catgoose/nvim-colorizer.lua",
    ft = { "css", "sass", "rasi", "toml" },
    config = function()
      require("colorizer").setup({
        filetypes = { "css", "sass", "rasi", "toml" },
      })
    end,
  },

  {
    "itchyny/lightline.vim",
    lazy = false,
    config = function()
      vim.g.lightline = {
        active = {
          left = {
            { "mode", "paste" },
            { "gitbranch", "readonly", "filename", "modified" },
          },
          right = {
            { "lineinfo" },
            { "percent" },
            { "fileencoding", "filetype" },
          },
        },
        component_function = {
          gitbranch = "FugitiveHead",
          filename = "v:lua.LightlineFilename",
        },
      }
      function LightlineFilename(opts)
        local git_root = vim.b.git_dir
        if not git_root then
          return vim.fn.expand("%")
        end
        local branch = ""
        if vim.fn.fnamemodify(vim.b.git_dir, ":t") == ".git" then
          git_root = vim.fn.fnamemodify(vim.b.git_dir, ":h")
        else
          git_root = vim.fn.fnamemodify(vim.b.git_dir, ":h:h")
          branch = vim.fn.FugitiveHead() .. "/"
        end
        local path = vim.fn.expand("%:p")
        if git_root and path:sub(1, #git_root) == git_root then
          return path:sub(#git_root + #branch + 2) -- Remove the Git root and leading slash
        end
        return vim.fn.expand("%")
      end
    end,
  },

  { "hiphish/rainbow-delimiters.nvim" },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    enabled = false, -- colored brackets are useful, but scope line seems unnecessary right now.
    opts = {},
    dependencies = { "hiphish/rainbow-delimiters.nvim" },
    config = function()
      local highlight = {
        "RainbowDelimiterYellow",
        "RainbowDelimiterGreen",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
        "RainbowDelimiterRed",
      }
      local hooks = require("ibl.hooks")
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = "#56B6C2" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#E06C75" })
      end)

      vim.g.rainbow_delimiters = { highlight = highlight }
      require("ibl").setup({ scope = { highlight = highlight } })
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },

  { "nvim-treesitter/nvim-treesitter-textobjects", dependencies = "nvim-treesitter/nvim-treesitter" }, -- not really used for colors, but this is here cuz treesitter is here.
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        -- A list of parser names, or "all" (the five listed parsers should always be installed)
        ensure_installed = { "go", "typescript", "javascript", "rust", "vim", "vimdoc" },
        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        auto_install = true,

        -- List of parsers to ignore installing (or "all")
        ignore_install = { "markdown", "gitignore", "markdown_inline" },
        ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
        -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
        highlight = {
          enable = true,
          -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
          -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
          -- the name of the parser)
          -- list of language that will be disabled
          -- disable = { "rust" },
          -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
          disable = function(lang, buf)
            local highlight_disable_languages = { "rust", "bash" }
            for _, hd_lang in ipairs(highlight_disable_languages) do
              if hd_lang == lang then
                return true
              end
            end
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@call.outer",
              ["if"] = "@call.inner",
              ["aF"] = "@function.outer",
              ["iF"] = "@function.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["al"] = "@loop.outer",
              ["il"] = "@loop.inner",
              ["ad"] = "@conditional.outer",
              ["id"] = "@conditional.inner",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
        },
      })
    end,
  },
}
