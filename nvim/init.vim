" This file can be symlinked to ~/.vimrc
let g:ale_completion_enabled = 1
let g:ale_lint_delay = 1000
let g:ale_disable_lsp = 1 

call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'octol/vim-cpp-enhanced-highlight'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'dense-analysis/ale'
Plug 'christoomey/vim-tmux-navigator'
Plug 'kyazdani42/nvim-tree.lua' " file explorer util
Plug 'kyazdani42/nvim-web-devicons' " optional, for file icons
Plug 'base16-project/base16-vim'

Plug 'neovim/nvim-lspconfig' " Completion framework
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'simrat39/rust-tools.nvim'
Plug 'rust-lang/rust.vim'
Plug 'williamboman/mason.nvim'
call plug#end()

" Custom visuals
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_section_z = '%p%% %l:%c'
set termguicolors
let base16colorspace=256
colorscheme base16-monokai
hi Normal guibg=None ctermbg=None 
set signcolumn=yes
" Custom Editor settings
set mouse=a
set number
set ignorecase
set cursorline
set relativenumber
set autoindent expandtab tabstop=2 shiftwidth=2

luafile /home/adisuper/.config/nvim/lua/nvim-tree-config.lua

" Key Bindings
let mapleader = " " " map leader to Space
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <tab> :bnext<CR>
nnoremap <C-p> :GFiles<CR>
nnoremap <leader>t :NvimTreeToggle<CR>
nnoremap F :Rg<CR>
" vim pane resize bindings
autocmd VimResized * :wincmd =
nnoremap <leader>= :wincmd =<CR>
nnoremap <leader>+ :wincmd \|<CR>
wincmd _

luafile /home/adisuper/.config/nvim/lua/lsp-config.lua
" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c

" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
" Show diagnostic popup on cursor hover
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>
