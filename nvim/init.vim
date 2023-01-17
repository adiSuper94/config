" This file can be symlinked to ~/.vimrc

call plug#begin()

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Syntax highlighting
"Plug 'octol/vim-cpp-enhanced-highlight'
"Plug 'uiiaoo/java-syntax.vim'
Plug 'sheerun/vim-polyglot'

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-rooter'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'dense-analysis/ale'
Plug 'christoomey/vim-tmux-navigator'
Plug 'kyazdani42/nvim-tree.lua' " file explorer util
Plug 'kyazdani42/nvim-web-devicons' " optional, for file icons
Plug 'base16-project/base16-vim'

" Completion framework
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
"Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
"Plug 'ray-x/lsp_signature.nvim'
Plug 'simrat39/rust-tools.nvim'
Plug 'rust-lang/rust.vim'

Plug 'williamboman/mason.nvim'
Plug 'KabbAmine/zeavim.vim'
"Plug 'fatih/vim-go'
"Plug 'sunaku/vim-dasht'

" Debug
Plug 'mfussenegger/nvim-jdtls'
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
call plug#end()

"let g:ale_completion_enabled = 0 
"let g:ale_lint_delay = 1000
"let g:ale_disable_lsp = 1 

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

"vim zeal bindings
vnoremap <leader>z <Plug>ZVVisSelection
"nnoremap gz <Plug>ZVOperator
nnoremap <leader>z <Plug>Zeavim

luafile /home/adisuper/.config/nvim/lua/lsp-config.lua
"luafile /home/adisuper/.config/nvim/lua/java-lsp-config.lua
" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect
" Avoid showing extra messages when using completion
set shortmess+=c
set updatetime=300
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
autocmd CursorHoldI *.go,*rs,*.c,*.h lua vim.lsp.buf.signature_help()
nnoremap gd <cmd> lua vim.lsp.buf.definition() <CR>
nnoremap gD <cmd> lua vim.lsp.buf.declaration() <CR>
nnoremap ga <cmd> lua vim.lsp.buf.code_action() <CR>
nnoremap gs <cmd> lua vim.lsp.buf.signature_help() <CR>
nnoremap gi <cmd> vim.lsp.buf.implementation() <CR>
nnoremap gn <cmd>lua vim.lsp.buf.rename()<CR> 
autocmd BufWritePre *.go,*.rs,*.c,*.h lua vim.lsp.buf.formatting()
"let g:go_highlight_functions = 1
"let g:go_highlight_function_calls = 1
"let g:go_highlight_extra_types = 1
"let g:go_gopls_enabled = 0
" Debug shortcuts
nnoremap <leader>b <cmd>:lua require'dap'.toggle_breakpoint()<CR>
nnoremap <leader>o <cmd>:lua require'dap'.step_over()<CR>
nnoremap <leader>i <cmd>:lua require'dap'.step_into()<CR>
nnoremap <leader>c <cmd>:lua require'dap'.continue()<CR>
nnoremap // :noh<return> " clear highlighting
