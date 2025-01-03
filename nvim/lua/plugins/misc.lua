-- if true then return {} end
keymap_opts = { noremap = true, silent = true }
return {
  {
    'airblade/vim-rooter',
    lazy = false,
    config = function()
      vim.g.rooter_patterns = {'.git', '_darcs', '.hg', '.bzr', '.svn'} --, 'Makefile', 'package.json'
    end
  },
  {
    'airblade/vim-gitgutter',
    config = function()
      vim.api.nvim_create_autocmd({"BufEnter","BufWritePre"}, { command = "GitGutter" })
    end
  },
  'tpope/vim-fugitive',
  -- 'github/copilot.vim',
  -- {'preservim/vim-markdown' , ft = {'markdown'}},
  -- {'godlygeek/tabular', ft = {'markdown'}},

  {
    'christoomey/vim-tmux-navigator',
    config = function()
      vim.keymap.set('n', '∂', '<Plug>NetrwRefresh') -- mapping random key to NetrwRefresh, so window navigation is easier
    end
  },

  -- {
  --   "folke/which-key.nvim",
  --   -- event = "VeryLazy",
  --   opts = {window = {border = "double"}}
  -- },

  -- {
  --   'junegunn/fzf.vim',
  --   dependencies = {'junegunn/fzf'},
  --   config = function()
  --     vim.keymap.set('n', '<C-p>', '<cmd>GitFiles <CR>', keymap_opts)
  --     vim.keymap.set('n', '<leader>g/', '<cmd>Rg <CR>', keymap_opts)
  --     vim.keymap.set('n', '<leader>/', '<cmd>BLines <CR>', keymap_opts)
  --     vim.keymap.set('n', '<leader>\'', '<cmd>Marks <CR>', keymap_opts)
  --   end
  -- },

  -- {
  --   'adiSuper94/hallebarde.vim', branch='extra-bits',
  --   config = function()
  --     vim.keymap.set('n', '<leader>hr', '<cmd>HallebardeRemove <CR>', keymap_opts) -- remove marked file
  --     vim.keymap.set('n', '<leader>ha', '<cmd>HallebardeAdd <CR>', keymap_opts) -- add marked file
  --     vim.keymap.set('n', '<leader><leader>', '<cmd>Hallebarde <CR>', keymap_opts) -- open marked files
  --     vim.keymap.set('n', '<up>', '<cmd>HallebardeNext <CR>', keymap_opts) -- next marked file
  --     vim.keymap.set('n', '<down>', '<cmd>HallebardePrevious <CR>', keymap_opts) -- previous marked file
  --     vim.keymap.set('n', '<leader>t', '<cmd>LexLuthor <CR>', keymap_opts)
  --   end
  -- },

  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-fzf-native.nvim' },
    config = function()
      require('telescope').setup({})
      local utils = require("telescope.utils")
      local builtin = require('telescope.builtin')
      local project_files = function()
        local _, ret, _ = utils.get_os_command_output({ 'git', 'rev-parse', '--is-inside-work-tree' })
        if ret == 0 then
            builtin.git_files()
        else
            builtin.find_files()
        end
      end
      vim.keymap.set('n', '<C-p>', project_files, keymap_opts)
      vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, keymap_opts)
      vim.keymap.set('n', '<leader>g/', builtin.live_grep, keymap_opts)
      vim.keymap.set('n', '<leader>tt', builtin.builtin, keymap_opts)
      vim.keymap.set('n', '<leader>\'', builtin.marks, keymap_opts)
      require('telescope').load_extension('fzf')
    end
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim","nvim-telescope/telescope.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
      vim.keymap.set('n', '<leader><leader>', function()harpoon.ui:toggle_quick_menu(harpoon:list()) end)
      vim.keymap.set('n', '<leader>ha', function() harpoon:list():add() end) -- add marked file
      vim.keymap.set('n', '<up>', function() harpoon:list():next() end) -- next marked file
      vim.keymap.set('n', '<down>', function()harpoon:list():prev() end)-- previous marked file
    end
  },

  { "stevearc/oil.nvim",
    config = function()
      require("oil").setup({})
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end
  },

  {
    'kevinhwang91/nvim-ufo', dependencies ={ 'kevinhwang91/promise-async', 'nvim-treesitter/nvim-treesitter'},
    config = function()
      require('ufo').setup({
        open_fold_hl_timeout = 200,
        provider_selector = function(bufnr, filetype, buftype)
            return {'treesitter', 'indent'}
        end
      })
      vim.opt.foldlevelstart = 99
    end
  }

}
