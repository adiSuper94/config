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
  'airblade/vim-gitgutter',
  'tpope/vim-fugitive',
  'tpope/vim-commentary',
  'preservim/vim-markdown',
  'jghauser/follow-md-links.nvim',
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
    opts = {}
  },

  {
    'junegunn/fzf.vim',
    dependencies = {'junegunn/fzf'},
    config = function()
      vim.keymap.set('n', '<C-p>', '<cmd>GitFiles <CR>', keymap_opts)
      vim.keymap.set('n', '<leader>/', '<cmd>Rg <CR>', keymap_opts)
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

}