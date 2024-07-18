-- if true then return {} end

return{
  {'wincent/base16-nvim', lazy = false, config = function() vim.cmd.colorscheme('base16-gruvbox-dark-hard') end},
  -- Both grubers have issues, with gitgutter color, and inlay hint colors :(
  -- {'thimc/gruber-darker.nvim', lazy= false, config = function() require('gruber-darker').setup({ transparent = true }) vim.cmd.colorscheme('gruber-darker') end },
  -- {'blazkowolf/gruber-darker.nvim', lazy= false, config = function() vim.cmd.colorscheme('gruber-darker') end },
  -- {'base16-project/base16-vim', config = function() vim.cmd.colorscheme('base16-ayu-dark') end },
  -- {
  --   'Shatur/neovim-ayu',
  --   lazy = false,
  --   config = function()
  --     require('ayu').setup({
  --       overrides = {
  --         -- Normal = { bg = "None" }
  --       }
  --     })
  --     vim.cmd.colorscheme('ayu-dark')
  --   end
  -- },

  {
    'itchyny/lightline.vim',
    lazy = false,
    config = function()
      vim.g.lightline = {
        active = {
          left = {
            { 'mode', 'paste' },
            { 'gitbranch', 'readonly', 'filename', 'modified' }
          },
          right = {
            { 'lineinfo' },
            { 'percent' },
            { 'fileencoding', 'filetype' }
          },
        },
        component_function = {
          gitbranch= 'FugitiveHead',
          filename = 'v:lua.LightlineFilename'
        },
      }
      function LightlineFilename(opts)
        if vim.fn.expand('%:t') == '' then
          return '[No Name]'
        else
          return vim.fn.getreg('%')
        end
      end
    end
  },

  {
    "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {},
    dependencies = { 'hiphish/rainbow-delimiters.nvim'},
    config= function()
      local highlight = {
        "RainbowDelimiterYellow",
        "RainbowDelimiterGreen",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
        "RainbowDelimiterRed",
      }
      local hooks = require "ibl.hooks"
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
      require("ibl").setup { scope = { highlight = highlight } }
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
      end
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    config = function()
      require'nvim-treesitter.configs'.setup {
        -- A list of parser names, or "all" (the five listed parsers should always be installed)
        ensure_installed = {"go", "typescript", "javascript" },
        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        auto_install = false,

        -- List of parsers to ignore installing (or "all")
        -- ignore_install = { "javascript" },
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
      }
    end
  }

}
