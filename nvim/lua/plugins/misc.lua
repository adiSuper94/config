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
  'preservim/vim-markdown',
  'godlygeek/tabular',
  'github/copilot.vim',

  {
    'christoomey/vim-tmux-navigator',
    config = function()
      vim.keymap.set('n', '∂', '<Plug>NetrwRefresh') -- mapping random key to NetrwRefresh, so window navigation is easier
    end
  },

  {
    "folke/which-key.nvim",
    -- event = "VeryLazy",
    opts = {window = {border = "double"}}
  },

  {
    'junegunn/fzf.vim',
    dependencies = {'junegunn/fzf'},
    config = function()
      vim.keymap.set('n', '<C-p>', '<cmd>GitFiles <CR>', keymap_opts)
      vim.keymap.set('n', '<leader>g/', '<cmd>Rg <CR>', keymap_opts)
      vim.keymap.set('n', '<leader>/', '<cmd>Blines <CR>', keymap_opts)
      vim.keymap.set('n', '<leader>\'', '<cmd>Marks <CR>', keymap_opts)
    end
  },

  {
    'adiSuper94/hallebarde.vim', branch='extra-bits',
    config = function()
      vim.keymap.set('n', '<leader>hr', '<cmd>HallebardeRemove <CR>', keymap_opts) -- remove marked file
      vim.keymap.set('n', '<leader>ha', '<cmd>HallebardeAdd <CR>', keymap_opts) -- add marked file
      vim.keymap.set('n', '<leader><leader>', '<cmd>Hallebarde <CR>', keymap_opts) -- open marked files
      vim.keymap.set('n', '<up>', '<cmd>HallebardeNext <CR>', keymap_opts) -- next marked file
      vim.keymap.set('n', '<down>', '<cmd>HallebardePrevious <CR>', keymap_opts) -- previous marked file
      vim.keymap.set('n', '<leader>t', '<cmd>LexLuthor <CR>', keymap_opts)
    end
  },

  -- {
  --   'nvim-telescope/telescope.nvim', tag = '0.1.6',
  --   dependencies = { 'nvim-lua/plenary.nvim' },
  --   config = function()
  --     require('telescope').setup({})
  --     local builtin = require('telescope.builtin')
  --     vim.keymap.set('n', '<C-p>', builtin.git_files, keymap_opts)
  --     vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, keymap_opts)
  --     vim.keymap.set('n', '<leader>g/', builtin.live_grep, keymap_opts)
  --     vim.keymap.set('n', '<leader>tt', builtin.builtin, keymap_opts)
  --     vim.keymap.set('n', '<leader>\'', builtin.marks, keymap_opts)
  --   end
  -- },

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
