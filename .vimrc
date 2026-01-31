" vim-plug auto installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.vim/plugged')

" File explorer
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'

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

" TypeScript development
Plug 'leafgarland/typescript-vim'
Plug 'pangloss/vim-javascript'
Plug 'HerringtonDarkholme/yats.vim'

" Svelte development
Plug 'evanleck/vim-svelte'
Plug 'leafOfTree/vim-svelte-plugin'
Plug 'Shougo/context_filetype.vim'
Plug 'preservim/nerdcommenter'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

" Auto completion (nvim-cmp)
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'L3MON4D3/LuaSnip', {'tag': 'v2.*', 'do': 'make install_jsregexp'}
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

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
Plug 'scalameta/nvim-metals', { 'for': ['scala', 'sbt', 'java'] }
Plug 'derekwyatt/vim-scala', { 'for': 'scala' }
Plug 'nvim-lua/plenary.nvim'

" Debugging
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'theHamsta/nvim-dap-virtual-text'

" Better file navigation
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-dap.nvim'

" Test runner
Plug 'nvim-neotest/neotest'
Plug 'nvim-neotest/neotest-vim-test'
Plug 'vim-test/vim-test'

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

" nvim-tree
nnoremap <leader>n :NvimTreeToggle<CR>
nnoremap <leader>nf :NvimTreeFindFile<CR>
nnoremap <leader>nc :NvimTreeCollapse<CR>

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

" Telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fm <cmd>Telescope metals commands<cr>

" Save and quit shortcuts
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>wq :wq<CR>

" LSP keybindings are configured in Lua below

" Airline configuration
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_powerline_fonts = 1
let g:airline_theme='gruvbox'

" ALE configuration
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'typescript': ['eslint', 'tsserver'],
\   'typescriptreact': ['eslint', 'tsserver'],
\   'svelte': ['eslint'],
\   'python': ['flake8', 'pylint'],
\   'rust': ['rustc'],
\   'scala': ['scalac', 'sbtserver'],
\}
let g:ale_fixers = {
\   'javascript': ['prettier'],
\   'typescript': ['prettier'],
\   'typescriptreact': ['prettier'],
\   'svelte': ['prettier'],
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
  autocmd FileType typescript,typescriptreact setlocal tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType javascript,javascriptreact setlocal tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType svelte setlocal tabstop=2 shiftwidth=2 softtabstop=2
  " TypeScript/JavaScript file extensions
  autocmd BufNewFile,BufRead *.tsx setlocal filetype=typescriptreact
  autocmd BufNewFile,BufRead *.jsx setlocal filetype=javascriptreact
  autocmd BufNewFile,BufRead *.ts setlocal filetype=typescript
  autocmd BufNewFile,BufRead *.js setlocal filetype=javascript
  " Svelte file extensions
  autocmd BufNewFile,BufRead *.svelte setlocal filetype=svelte
augroup END

" Svelte configuration
let g:vim_svelte_plugin_load_full_syntax = 1
let g:vim_svelte_plugin_use_sass = 1
let g:vim_svelte_plugin_use_typescript = 1

" NERDCommenter configuration for Svelte
let g:NERDCustomDelimiters = {
\   'svelte': { 'left': '<!-- ', 'right': ' -->', 'leftAlt': '// ', 'rightAlt': '' }
\}

" Context filetype for Svelte
if !exists('g:context_filetype#same_filetypes')
  let g:context_filetype#same_filetypes = {}
endif
let g:context_filetype#same_filetypes.svelte = 'html,javascript,typescript,css,scss'

" nvim-tree configuration
lua << EOF
-- Disable netrw (recommended by nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Setup nvim-tree with recommended settings (only if plugin is installed)
local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

nvim_tree.setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 35,
  },
  renderer = {
    group_empty = true,
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
    },
  },
  filters = {
    dotfiles = false,  -- Show hidden files by default
    custom = { "^\\.git$", "^\\.DS_Store$" },  -- But hide these
  },
  git = {
    enable = true,
    ignore = false,
  },
  actions = {
    open_file = {
      quit_on_open = false,
      window_picker = {
        enable = true,
      },
    },
  },
  filesystem_watchers = {
    enable = true,
    ignore_dirs = {
      ".bloop",
      ".metals",
      ".scala-build",
      "node_modules",
      "target",
      ".git",
    },
  },
  -- Auto-open nvim-tree when opening a directory
  on_attach = function(bufnr)
    local api = require('nvim-tree.api')

    -- Default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- Custom mappings
    local function opts(desc)
      return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
  end,
})

-- Auto-open nvim-tree when starting Neovim with a directory
if status_ok then
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function(data)
      -- Check if the argument is a directory
      local directory = vim.fn.isdirectory(data.file) == 1

      if directory then
        -- Change to the directory
        vim.cmd.cd(data.file)
        -- Open nvim-tree
        local api_ok, api = pcall(require, "nvim-tree.api")
        if api_ok then
          api.tree.open()
        end
      end
    end,
  })
end
EOF

" Mason and LSP configuration
lua << EOF
-- Mason setup (LSP server manager)
local mason_ok, mason = pcall(require, "mason")
if mason_ok then
  mason.setup({
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
      }
    }
  })
end

local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if mason_lspconfig_ok then
  mason_lspconfig.setup({
    ensure_installed = {
      "ts_ls",
      "terraformls",
      "jsonls",
      "svelte",
      "eslint",
      "sqlls",
    },
    automatic_installation = true,
  })
end

-- nvim-cmp setup
local cmp_ok, cmp = pcall(require, "cmp")
local luasnip_ok, luasnip = pcall(require, "luasnip")

if cmp_ok and luasnip_ok then
  -- Load friendly-snippets
  require("luasnip.loaders.from_vscode").lazy_load()

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    }, {
      { name = 'buffer' },
      { name = 'path' },
    }),
    formatting = {
      format = function(entry, vim_item)
        vim_item.menu = ({
          nvim_lsp = "[LSP]",
          luasnip = "[Snippet]",
          buffer = "[Buffer]",
          path = "[Path]",
        })[entry.source.name]
        return vim_item
      end,
    },
  })

  -- Cmdline setup
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
end

-- LSP configuration (Neovim 0.11+ native API)
-- Capabilities for nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_lsp_ok then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- LSP keybindings (set via LspAttach autocmd)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<leader>ld', vim.diagnostic.setloclist, opts)
    vim.keymap.set('n', '<leader>fo', function() vim.lsp.buf.format { async = true } end, opts)
  end,
})

-- Configure LSP servers using vim.lsp.config (Neovim 0.11+)
vim.lsp.config('ts_ls', {
  capabilities = capabilities,
  filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact", "javascript.jsx" },
})

vim.lsp.config('terraformls', {
  capabilities = capabilities,
  filetypes = { "terraform", "tf", "terraform-vars" },
})

vim.lsp.config('jsonls', {
  capabilities = capabilities,
})

vim.lsp.config('svelte', {
  capabilities = capabilities,
})

vim.lsp.config('eslint', {
  capabilities = capabilities,
})

vim.lsp.config('sqlls', {
  capabilities = capabilities,
})

-- Enable LSP servers
vim.lsp.enable('ts_ls')
vim.lsp.enable('terraformls')
vim.lsp.enable('jsonls')
vim.lsp.enable('svelte')
vim.lsp.enable('eslint')
vim.lsp.enable('sqlls')

-- ESLint auto-fix on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.svelte" },
  callback = function()
    vim.cmd("silent! EslintFixAll")
  end,
})

-- Diagnostic signs
local signs = { Error = "✘", Warn = "⚠", Hint = "💡", Info = "ℹ" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Diagnostic configuration
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
EOF

" Metals (Scala LSP) configuration
lua << EOF
local metals_ok, metals = pcall(require, "metals")
if metals_ok then
  local metals_config = metals.bare_config()
  metals_config.settings = {
    showImplicitArguments = true,
    showImplicitConversionsAndClasses = true,
    showInferredType = true,
    superMethodLensesEnabled = true,
    excludedPackages = {"akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl"},
  }

  -- Use capabilities from nvim-cmp
  local cmp_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if cmp_lsp_ok then
    metals_config.capabilities = cmp_nvim_lsp.default_capabilities()
  end

  -- Enable DAP
  metals_config.init_options.statusBarProvider = "on"

  -- Setup DAP
  local dap_ok, dap = pcall(require, "dap")
  if dap_ok then
    dap.configurations.scala = {
      {
        type = "scala",
        request = "launch",
        name = "RunOrTest",
        metals = {
          runType = "runOrTestFile",
        },
      },
      {
        type = "scala",
        request = "launch",
        name = "Test Target",
        metals = {
          runType = "testTarget",
        },
      },
    }
  end

  -- Setup DAP on attach
  metals_config.on_attach = function(client, bufnr)
    metals.setup_dap()
  end

  -- Autocmd to start Metals
  vim.api.nvim_create_autocmd("FileType", {
    pattern = {"scala", "sbt", "java"},
    callback = function()
      metals.initialize_or_attach(metals_config)
    end,
    group = vim.api.nvim_create_augroup("nvim-metals", {clear = true}),
  })
end

-- Metals keybindings (only if metals is loaded)
if metals_ok then
  vim.keymap.set("n", "<leader>mc", function() require("metals").compile_cascade() end, { desc = "Metals compile cascade" })
  vim.keymap.set("n", "<leader>mi", function() require("metals").toggle_setting("showImplicitArguments") end, { desc = "Toggle implicit args" })
  vim.keymap.set("n", "<leader>md", function() require("metals").doctor() end, { desc = "Metals doctor" })
  vim.keymap.set("n", "<leader>mw", function() require("metals").hover_worksheet() end, { desc = "Hover worksheet" })
end

-- Debugging keybindings
local dap_ok, dap = pcall(require, "dap")
if dap_ok then
  vim.keymap.set("n", "<leader>dc", function() dap.continue() end, { desc = "Debug continue" })
  vim.keymap.set("n", "<leader>dr", function() dap.repl.toggle() end, { desc = "Debug REPL" })
  vim.keymap.set("n", "<leader>dK", function() require("dap.ui.widgets").hover() end, { desc = "Debug hover" })
  vim.keymap.set("n", "<leader>dt", function() dap.toggle_breakpoint() end, { desc = "Toggle breakpoint" })
  vim.keymap.set("n", "<leader>dso", function() dap.step_over() end, { desc = "Step over" })
  vim.keymap.set("n", "<leader>dsi", function() dap.step_into() end, { desc = "Step into" })
  vim.keymap.set("n", "<leader>dl", function() dap.run_last() end, { desc = "Run last" })
end

-- Telescope extensions
pcall(require('telescope').load_extension, 'metals')
pcall(require('telescope').load_extension, 'dap')
EOF

" Scala-specific keybindings
augroup scala_bindings
  autocmd!
  autocmd FileType scala nnoremap <buffer> <leader>si :MetalsImportBuild<CR>
  autocmd FileType scala nnoremap <buffer> <leader>sb :MetalsBuildConnect<CR>
  autocmd FileType scala nnoremap <buffer> <leader>sc :MetalsCompileCascade<CR>
  autocmd FileType scala nnoremap <buffer> <leader>sr :MetalsRestartServer<CR>
  autocmd FileType scala nnoremap <buffer> <leader>so :MetalsOrganizeImports<CR>
  " Scala用LSPキーマッピング（Metals使用）
  autocmd FileType scala nnoremap <buffer> gd <cmd>lua vim.lsp.buf.definition()<CR>
  autocmd FileType scala nnoremap <buffer> gy <cmd>lua vim.lsp.buf.type_definition()<CR>
  autocmd FileType scala nnoremap <buffer> gi <cmd>lua vim.lsp.buf.implementation()<CR>
  autocmd FileType scala nnoremap <buffer> gr <cmd>lua vim.lsp.buf.references()<CR>
  autocmd FileType scala nnoremap <buffer> K <cmd>lua vim.lsp.buf.hover()<CR>
  autocmd FileType scala nnoremap <buffer> <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
  autocmd FileType scala nnoremap <buffer> <leader>ca <cmd>lua vim.lsp.buf.code_action()<CR>
augroup END