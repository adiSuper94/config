" This file can be symlinked to ~/.vimrc

call plug#begin()

" Theme
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'base16-project/base16-vim' ",  { 'commit': '88a1e73e5358fefe0288538e6866f99d5487c5a0' }

" Syntax highlighting
Plug 'sheerun/vim-polyglot'

" Bells and whistles
Plug 'airblade/vim-rooter'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'kyazdani42/nvim-tree.lua' " file explorer util
Plug 'kyazdani42/nvim-web-devicons' " optional, for file icons
Plug 'luochen1990/rainbow'
Plug 'tpope/vim-commentary'
Plug 'adiSuper94/hallebarde.vim'

" Completion framework
Plug 'neovim/nvim-lspconfig' " neovim lsp configs
Plug 'hrsh7th/cmp-nvim-lsp' " auto completion source for nvim built in lsp
Plug 'hrsh7th/cmp-buffer' " auto completion source for buffer
Plug 'hrsh7th/cmp-path' " auto completion source for filesystem paths
Plug 'hrsh7th/cmp-vsnip' " auto completion source for vim-vsnip
Plug 'hrsh7th/vim-vsnip' 
Plug 'hrsh7th/nvim-cmp' " auto completion sink 
Plug 'ray-x/lsp_signature.nvim'
"Plug 'lewis6991/gitsigns.nvim'

" Rust easy config from https://github.com/sharksforarms/neovim-rust 
Plug 'simrat39/rust-tools.nvim'
Plug 'rust-lang/rust.vim'

Plug 'williamboman/mason.nvim' " tool to install LSPs and related shiz
Plug 'KabbAmine/zeavim.vim'

" Debug
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'

call plug#end()

" Custom visuals
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_section_z = '%p%% %l:%c'
let base16colorspace=256
colorscheme base16-monokai
hi Normal guibg=None ctermbg=None 
let g:rainbow_active = 1

" Custom Editor settings
set signcolumn=yes " For Git Gutter to not flicker
set termguicolors
set mouse=a
set number
set ignorecase
set cursorline
set relativenumber
set autoindent
set wrap linebreak " wrap lines without breakig words
set expandtab softtabstop=2 " use space instead of tabs, and backspace deletes 2 chars instead of 1
set tabstop=2 " width of tab char
set shiftwidth=2 " witdth used for indetation commands (<<, >>)
set textwidth=100 " line width/ column width before line wraps
set autoread

" Key Bindings
let mapleader = " " " map leader to Space
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <Tab> :Files<CR>
nnoremap <C-p> :GFiles<CR>
nnoremap <C-x> :bd<CR>
nnoremap <C-w> :w<CR>
nnoremap <leader>, <C-w><
nnoremap <leader>. <C-w>>
nnoremap <leader>t :NvimTreeToggle<CR>
nnoremap <leader>g :Rg<CR>
nnoremap <silent> <Leader><Leader> <CMD>Hallebarde<CR>
nnoremap <leader>hr  <cmd>HallebardeRemove<CR>
nnoremap <leader>ha  <cmd>HallebardeAdd<CR>
" Move by displayed line
nnoremap j gj
nnoremap k gk

"I'm gonna regret this
nnoremap <Up> <cmd>HallebardeNext <CR>
nnoremap <Down> <cmd>HallebardePrevious <CR>
nnoremap <Right> :bn<CR>
nnoremap <Left> :bp<CR>

inoremap <Up> <Nop>
inoremap <Down> <Nop>

" vim pane resize bindings
autocmd VimResized * :wincmd =
nnoremap <leader>= :wincmd =<CR>
nnoremap <leader>+ :wincmd \|<CR>
wincmd _

vnoremap <leader>z <Plug>ZVVisSelection
"nnoremap gz <Plug>ZVOperator
nnoremap <leader>z <Plug>Zeavim

let g:rooter_patterns = ['.git', '_darcs', '.hg', '.bzr', '.svn'] ", 'Makefile', 'package.json']

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
autocmd CursorHoldI *rs,*.c,*.h,*js,*.json lua vim.lsp.buf.signature_help()
nnoremap <F12> <cmd> lua vim.lsp.buf.definition() <CR>
nnoremap <F24> <cmd> lua vim.lsp.buf.declaration() <CR>
nnoremap ga <cmd> lua vim.lsp.buf.code_action() <CR>
"nnoremap gs <cmd> lua vim.lsp.buf.signature_help() <CR>
nnoremap <F11> <cmd> lua vim.lsp.buf.implementation() <CR>
nnoremap <F10> <cmd> lua vim.lsp.buf.rename()<CR>
autocmd BufWritePre *.rs,*.c,*.h,*.js,*.json lua vim.lsp.buf.format({async = true})
autocmd CursorHold * GitGutter
nnoremap <leader>k <cmd> lua vim.lsp.buf.hover() <CR>
" Debug shortcuts
nnoremap <F5> <cmd> lua require'dap'.restart() <CR>
nnoremap <F6> <cmd> lua require'dap'.continue() <CR>
nnoremap <F18> <cmd> lua require'dap'.pause <CR> " Shift + F6
nnoremap <F7> <cmd> lua require'dap'.toggle_breakpoint() <CR>
nnoremap <F8> <cmd> lua require'dap'.step_over() <CR>
nnoremap <F9> <cmd> lua require'dap'.step_into() <CR>
nnoremap <F21> <cmd> lua require'dap'.step_out() <CR> " Shift + F9

nnoremap <F2> :nohlsearch<return> 

nnoremap <leader>c <cmd>:edit /home/adisuper/.config/nvim/init.vim<CR>
" Trying Shiz out from vim cast

" Shortcut to rapidly toggle `set list`
nnoremap <leader>l :set list! <CR>
set listchars=tab:▸\ ,eol:¬ 

luafile /home/adisuper/.config/nvim/lua/nvim-tree-config.lua
luafile /home/adisuper/.config/nvim/lua/lsp-config.lua
"luafile /home/adisuper/.config/nvim/lua/java-lsp-config.lua

"Plugins not being used but might be helpful

"Plug 'octol/vim-cpp-enhanced-highlight'
"Plug 'uiiaoo/java-syntax.vim'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'dense-analysis/ale'
"Plug 'hrsh7th/cmp-cmdline'
"Plug 'fatih/vim-go'
"Plug 'sunaku/vim-dasht'
"Plug 'mfussenegger/nvim-jdtls' " Debug
"Plug 'tpope/vim-fugitive'

" Configs for those unused plugins (I guess I am a hoarder) 
"let g:ale_completion_enabled = 0 
"let g:ale_lint_on_text_changed = 1
"let g:ale_lint_delay = 1000
"let g:ale_disable_lsp = 1 
"let g:go_highlight_functions = 1
"let g:go_highlight_function_calls = 1
"let g:go_highlight_extra_types = 1
"let g:go_gopls_enabled = 0
