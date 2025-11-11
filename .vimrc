" vim-plug auto installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.vim/plugged')

" File explorer
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'

" Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Git integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Syntax highlighting and language support
Plug 'sheerun/vim-polyglot'
Plug 'dense-analysis/ale'

" Auto completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Comments
Plug 'tpope/vim-commentary'

" Surround
Plug 'tpope/vim-surround'

" Color schemes
Plug 'morhetz/gruvbox'
Plug 'joshdick/onedark.vim'

" Auto pairs
Plug 'jiangmiao/auto-pairs'

" Multiple cursors
Plug 'terryma/vim-multiple-cursors'

" Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

" Scala development
Plug 'scalameta/nvim-metals', { 'for': 'scala' }
Plug 'derekwyatt/vim-scala', { 'for': 'scala' }
Plug 'natebosch/vim-lsc', { 'for': 'scala' }
Plug 'hrsh7th/nvim-compe'

call plug#end()

" Basic Settings
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set bomb
set binary
set ttyfast

" Visual Settings
syntax enable
set number
set relativenumber
set ruler
set title
set showcmd
set showmode
set laststatus=2
set cursorline
set colorcolumn=80
set signcolumn=yes

" Color scheme
set background=dark
colorscheme gruvbox

" Search Settings
set hlsearch
set incsearch
set ignorecase
set smartcase

" Indentation
set autoindent
set smartindent
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

" File handling
set nobackup
set noswapfile
set autoread
set hidden

" UI Config
set wildmenu
set wildmode=list:longest,full
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite
set completeopt=menuone,noselect
set pumheight=10

" Behavior
set backspace=indent,eol,start
set clipboard=unnamed
set mouse=a
set splitbelow
set splitright
set scrolloff=5

" Performance
set lazyredraw
set updatetime=300

" Key mappings
let mapleader = " "

" NERDTree
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>nf :NERDTreeFind<CR>
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.git$', '\.DS_Store$']

" FZF
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>g :Rg<CR>
nnoremap <leader>h :History<CR>

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Buffer navigation
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bd :bdelete<CR>

" Terminal
nnoremap <leader>t :terminal<CR>

" Clear search highlight
nnoremap <leader><space> :nohlsearch<CR>

" Save and quit shortcuts
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>wq :wq<CR>

" CoC.nvim configuration
" Use tab for trigger completion
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <cr> to confirm completion
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Airline configuration
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_powerline_fonts = 1
let g:airline_theme='gruvbox'

" ALE configuration
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'typescript': ['eslint', 'tsserver'],
\   'python': ['flake8', 'pylint'],
\   'rust': ['rustc'],
\   'scala': ['scalac', 'sbtserver'],
\}
let g:ale_fixers = {
\   'javascript': ['prettier'],
\   'typescript': ['prettier'],
\   'css': ['prettier'],
\   'python': ['black', 'isort'],
\   'rust': ['rustfmt'],
\   'scala': ['scalafmt'],
\}
let g:ale_fix_on_save = 1
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'

" GitGutter
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'

" Auto commands
augroup general_config
  autocmd!
  " Remove trailing whitespaces
  autocmd BufWritePre * :%s/\s\+$//e
  " Return to last edit position
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END

" File type specific settings
augroup filetype_config
  autocmd!
  autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4
  autocmd FileType markdown setlocal wrap linebreak
  autocmd FileType scala setlocal tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType sbt setlocal tabstop=2 shiftwidth=2 softtabstop=2
augroup END

" Metals (Scala LSP) configuration
lua << EOF
local metals_config = require'metals'.bare_config()
metals_config.settings = {
  showImplicitArguments = true,
  excludedPackages = {"akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl"},
}

-- Autocmd to start Metals
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"scala", "sbt", "java"},
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
  group = vim.api.nvim_create_augroup("nvim-metals", {clear = true}),
})

-- Metals keybindings
vim.keymap.set("n", "<leader>mc", function() require("metals").compile_cascade() end, { desc = "Metals compile cascade" })
vim.keymap.set("n", "<leader>mi", function() require("metals").toggle_setting("showImplicitArguments") end, { desc = "Toggle implicit args" })
vim.keymap.set("n", "<leader>md", function() require("metals").doctor() end, { desc = "Metals doctor" })
vim.keymap.set("n", "<leader>mw", function() require("metals").hover_worksheet() end, { desc = "Hover worksheet" })
EOF

" Scala-specific keybindings
augroup scala_bindings
  autocmd!
  autocmd FileType scala nnoremap <buffer> <leader>si :MetalsImportBuild<CR>
  autocmd FileType scala nnoremap <buffer> <leader>sb :MetalsBuildConnect<CR>
  autocmd FileType scala nnoremap <buffer> <leader>sc :MetalsCompileCascade<CR>
  autocmd FileType scala nnoremap <buffer> <leader>sr :MetalsRestartServer<CR>
  autocmd FileType scala nnoremap <buffer> <leader>so :MetalsOrganizeImports<CR>
augroup END