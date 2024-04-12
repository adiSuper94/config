" This file can be symlinked to ~/.vimrc
function FormatAndSave()
  lua vim.lsp.buf.format({async = false})
  w
  if &filetype == "python"
    silent! !black --quiet %
    sleep 150m
    silent! e
  endif
endfunction

call plug#begin()

" Theme
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'base16-project/base16-vim' ",  { 'commit': '88a1e73e5358fefe0288538e6866f99d5487c5a0' }

" Better Syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Bells and whistles
Plug 'airblade/vim-rooter'
Plug 'airblade/vim-gitgutter'
Plug 'j-hui/fidget.nvim', { 'tag': 'legacy' }
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-commentary'
Plug 'adiSuper94/hallebarde.vim', {'branch': 'extra-bits'}
Plug 'github/copilot.vim'
Plug 'jghauser/follow-md-links.nvim'
Plug 'preservim/vim-markdown'
Plug 'tpope/vim-fugitive'
Plug 'godlygeek/tabular'
Plug 'folke/which-key.nvim'
Plug 'kyazdani42/nvim-tree.lua' " file explorer util
Plug 'kyazdani42/nvim-web-devicons' " optional, for file icons

" Completion framework
Plug 'neovim/nvim-lspconfig' " neovim lsp configs
Plug 'hrsh7th/cmp-nvim-lsp' " auto completion source for nvim built in lsp
Plug 'hrsh7th/cmp-path' " auto completion source for filesystem paths
Plug 'hrsh7th/nvim-cmp' " auto completion sink
Plug 'ray-x/lsp_signature.nvim'
Plug 'lvimuser/lsp-inlayhints.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'hiphish/rainbow-delimiters.nvim'

Plug 'williamboman/mason.nvim' " tool to install LSPs and related shiz

call plug#end()

" Custom visuals
" let g:airline#extensions#tabline#enabled = 0
" let g:airline_powerline_fonts = 0
let g:airline_section_z = '%p%% %l:%c'
let g:airline_theme = 'ayu_dark'
let base16colorspace=256
colorscheme base16-ayu-dark
hi Normal guibg=None ctermbg=None
hi LspInlayHint guifg=#aaaaaa guibg=None ctermfg=grey ctermbg=black
" let g:rainbow_active = 1

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
set clipboard+=unnamedplus
set noshowmode

" Key Bindings
let mapleader = " " " map leader to Space
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <Tab> :tabnext <CR>
nnoremap <C-p> :GFiles<CR>
nnoremap <A-x> :bd<CR>
nnoremap ≈ :bd<CR>" option + x for mac
nnoremap <C-x> :bp \| bd #<CR>
nnoremap <A-w> :call FormatAndSave() <CR>
nnoremap ∑  <CMD> call FormatAndSave() <CR> " Option + w for mac
nnoremap <C-n> :tabnew <CR>
nnoremap <leader>, <C-w><
nnoremap <leader>. <C-w>>
nnoremap <leader>t :NvimTreeToggle<CR>
" nnoremap <leader>t :LexLuthor<CR>
nnoremap <leader>/ :Rg<CR>
nnoremap <silent> <Leader><Leader> <CMD>Hallebarde<CR>
nnoremap <leader>hr  <cmd>HallebardeRemove<CR>
nnoremap <leader>ha  <cmd>HallebardeAdd<CR>
" Move by displayed line

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
nnoremap <leader>z :wincmd \|<CR>
wincmd _

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
autocmd BufWritePre *.rs,*.c,*.h,*.js,*.ts,*.go,*.json lua vim.lsp.buf.format({async = false})
autocmd CursorHold * GitGutter
nnoremap <leader>df <cmd> lua vim.diagnostic.open_float(nil, { focusable = false }) <CR>
nnoremap <Esc> :nohlsearch<return>

nnoremap <leader>c <cmd>:edit ~/.config/nvim/init.vim<CR>
" Trying Shiz out from vim cast

" Shortcut to rapidly toggle `set list`
nnoremap <leader>l :set list! <CR>
set listchars=tab:▸\ ,eol:¬

" let g:loaded_netrw = 1
" let g:loaded_netrwPlugin = 1

let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_winsize = 20
let g:netrw_liststyle = 3
let g:netrw_keepdir = 0

luafile ~/.config/nvim/lua/lsp/config.lua
luafile ~/.config/nvim/lua/nvim-tree-config.lua
" luafile ~/.config/nvim/lua/java-lsp-config.lua

"Plugins not being used but might be helpful

" Plug 'octol/vim-cpp-enhanced-highlight'
" Plug 'blazkowolf/gruber-darker.nvim'
" Plug 'uiiaoo/java-syntax.vim'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'dense-analysis/ale'
" Plug 'hrsh7th/cmp-cmdline'
" Plug 'fatih/vim-go'
" Plug 'sunaku/vim-dasht'
" Plug 'mfussenegger/nvim-jdtls' " Debug
" " Rust easy config from https://github.com/sharksforarms/neovim-rust
" Plug 'simrat39/rust-tools.nvim'
" Plug 'rust-lang/rust.vim'
" Plug 'hrsh7th/cmp-vsnip' " auto completion source for vim-vsnip
" Plug 'hrsh7th/vim-vsnip'
" Plug 'hrsh7th/cmp-buffer' " auto completion source for buffer
" Plug 'sheerun/vim-polyglot'
" Plug 'luochen1990/rainbow'
" Plug 'editorconfig/editorconfig-vim'

" Debug
" Plug 'mfussenegger/nvim-dap'
" Plug 'rcarriga/nvim-dap-ui'
