" ------------------------------------------------------------

" ------------------------------------------------------------
"  " ======================================= [ Reader ]
let mapleader = "\<Space>"

" Normal Mode
cnoremap init :<C-u>edit $MYVIMRC<CR>                           " init.vim呼び出し
noremap <Space>s :source $MYVIMRC<CR>                           " init.vim読み込み
noremap <Space>w :<C-u>w<CR>                                    " ファイル保存

" ＜追加＞分割画面移動
noremap <silent><C-h> <C-w>h
noremap <silent><C-j> <C-w>j
noremap <silent><C-k> <C-w>k
noremap <silent><C-l> <C-w>l

"Needtree tab chenge
noremap  <Leader>v <C-v>
noremap  <Leader>t :tabnew<Enter>
nnoremap <Leader>vs :vsplit<Return>
nnoremap <Leader>s  :split<Return>

" Insert Mode
inoremap <silent> jj <ESC>:<C-u>w<CR>:" InsertMode抜けて保存
" Insert mode movekey bind
inoremap <C-d> <BS>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <C-k> <Up>
inoremap <C-j> <Down>

" encode setting
" edita setting
set number          " 行番号表示
set splitbelow      " 水平分割時に下に表示
set splitright      " 縦分割時を右に表示
set noequalalways   " 分割時に自動調整を無効化
set wildmenu        " コマンドモードの補完
" cursorl setting
set ruler           " カーソルの位置表示
set cursorline      " カーソルハイライト
" tab setting
set expandtab       " tabを複数のspaceに置き換え
set tabstop=2       " tabは半角2文字
set shiftwidth=2    " tabの幅

" metals 
set updatetime=300
set nocursorline
set norelativenumber
set termguicolors

"dein Scripts-----------------------------

" プラグインの設定ファイルPath
let s:plugin = '~/.config/nvim/dein.toml'

if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
" Pluginディレクトリのパス
let s:dein_dir = expand('~/.cache/dein/')

" dein.vimのパス
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

" tomlのディレクトリへのパス
let s:toml_dir = expand('~/.config/nvim')

" Required:
"execute 'set runtimepath^=' . s:dein_repo_dir

" Required:
if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

   " 起動時に読み込むプラグイン群のtoml
  call dein#load_toml('~/.config/nvim/dein.toml', {'lazy': 0})

   " 利用時に読み込むプラグインのtoml
  call dein#load_toml('~/.config/nvim/lazy.toml', {'lazy': 1})

  " Add or remove your plugins here like this:
  call dein#add('posva/vim-vue')

  "call dein#add('Shougo/neosnippet.vim')
  "call dein#add('Shougo/neosnippet-snippets')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

autocmd BufWritePost * call defx#redraw()
autocmd BufEnter * call defx#redraw()

" ====================================== [ defx[tree] ]
"【n x 2】defx.nvimを起動
autocmd VimEnter * execute 'Defx'
nnoremap <silent> nn :<C-u> Defx <CR>

autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
  " Define mappings
  nnoremap <silent><buffer><expr> <CR>
  \ defx#do_action('open')
  nnoremap <silent><buffer><expr> c
  \ defx#do_action('copy')
  nnoremap <silent><buffer><expr> m
  \ defx#do_action('move')
  nnoremap <silent><buffer><expr> t
  \ defx#do_action('multi',[['open','tabnew'],'quit'])
  nnoremap <silent><buffer><expr> p
  \ defx#do_action('paste')
  nnoremap <silent><buffer><expr> l
  \ defx#is_directory() ?
  \  defx#do_action('open_directory') :
  \ defx#do_action('multi',[['drop'], 'quit'])
  nnoremap <silent><buffer><expr> v
  \ defx#do_action('multi',[['open', 'vsplit'],'quit'])
  nnoremap <silent><buffer><expr> s
  \ defx#do_action('multi',[['open', 'split'],'quit'])
  nnoremap <silent><buffer><expr> P
  \ defx#do_action('open', 'pedit')
  nnoremap <silent><buffer><expr> o
  \ defx#do_action('open_or_close_tree')
  nnoremap <silent><buffer><expr> K
  \ defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> a
  \ defx#do_action('new_file')
  nnoremap <silent><buffer><expr> M
  \ defx#do_action('new_multiple_files')
  nnoremap <silent><buffer><expr> C
  \ defx#do_action('toggle_columns',
  \                'mark:indent:icon:filename:type:size:time')
  nnoremap <silent><buffer><expr> S
  \ defx#do_action('toggle_sort', 'time')
  nnoremap <silent><buffer><expr> d
  \ defx#do_action('remove')
  nnoremap <silent><buffer><expr> r
  \ defx#do_action('rename')
  nnoremap <silent><buffer><expr> !
  \ defx#do_action('execute_command')
  nnoremap <silent><buffer><expr> x
  \ defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> yy
  \ defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> .
  \ defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> ;
  \ defx#do_action('repeat')
  nnoremap <silent><buffer><expr> h
  \ defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~
  \ defx#do_action('cd')
  nnoremap <silent><buffer><expr> q
  \ defx#do_action('quit')
  nnoremap <silent><buffer><expr> <Space>
  \ defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> *
  \ defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr> j
  \ line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k
  \ line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> <C-l>
  \ defx#do_action('redraw')
  nnoremap <silent><buffer><expr> <C-g>
  \ defx#do_action('print')
  nnoremap <silent><buffer><expr> cd
  \ defx#do_action('change_vim_cwd')
endfunction

" Config for defx-git
call defx#custom#column('git', 'indicators', {
  \ 'Modified'  : '✹',
  \ 'Staged'    : '✚',
  \ 'Untracked' : '✭',
  \ 'Renamed'   : '➜',
  \ 'Unmerged'  : '═',
  \ 'Ignored'   : '☒',
  \ 'Deleted'   : '✖',
  \ 'Unknown'   : '?'
  \ })

" Color scheme
set background=dark
colorscheme hybrid

" Required:
filetype plugin indent on
syntax enable

"End dein Scripts-------------------------
"========================================== [ fzf ]
" fzf commands "
nnoremap <Leader><C-f> :GFiles<Enter>
nnoremap <Leader><C-l> :BLines<Return>
nnoremap <Leader><C-h> :History<Enter>
nnoremap <Leader>ss :Rg<Enter>

" ff
command! -bang -nargs=? -complete=dir GFiles
\ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" Rg
command! -bang -nargs=* Rg
\ call fzf#vim#grep(
\ 'rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
\ <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
\ : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
\ <bang>0)

function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

"========================================== [ metals ]
" metals
nmap <silent> <Leader>ws <Plug>(coc-metals-expand-decoration)
nmap <silent> <Leader>gd <Plug>(coc-definition)
nmap <silent> <Leader>gy :<C-u>call CocAction('doHover')<cr>
nmap <silent> <Leader>gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> K :call <SID>show_documentation()<CR>
nmap <Leader>ws <Plug>(coc-metals-expand-decoration)
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
nmap <Leader>ws <Plug>(coc-metals-expand-decoration)

" metals build
nnoremap call :call CocRequestAsync('metals', 'workspace/executeCommand', { 'command': 'build-import' })


"---------------------------------"
" Coc設定
"---------------------------------"
"スペース2回でCocList
nmap <silent> <space><space> :<C-u>CocList<cr>
"hvでHover
nmap <silent> hv :<C-u>call CocAction('doHover')<cr>
"dfでDefinition
nmap <silent> df <Plug>(coc-definition)
"rfでReferences
nmap <silent> rf <Plug>(coc-references)
"rnでRename
nmap <silent> rn <Plug>(coc-rename)
"fmtでFormat
nmap <silent> fmt <Plug>(coc-format)

"htmlの設定
autocmd Filetype html inoremap <buffer> </ </<C-x><C-o><ESC>F<i

"---------------------------------"
" ターミナル設定
"---------------------------------"
"下部分にターミナルウィンドウを作る
function! Myterm()
    split
    wincmd j
    resize 10
    terminal
    wincmd k
endfunction
command! Myterm call Myterm()

nnoremap <silent> tt :Myterm <CR>
"起動時にターミナルウィンドウを設置
"if has('vim_starting')
"    Myterm
"endif

"上のエディタウィンドウと下のターミナルウィンドウ(ターミナル挿入モード)を行き来
tnoremap <C-t> <C-\><C-n><C-w>k
nnoremap <C-t> <C-w>ji
"ターミナル挿入モードからターミナルモードへ以降
tnoremap <Esc> <C-\><C-n>
