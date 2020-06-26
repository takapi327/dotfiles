" 文字設定 "
set encoding=utf-8            " ファイル読み込み時の文字コードの設定
set fileencodings=utf-8       " 読み込み時の文字コードの自動判別
set fileencoding=utf-8        " 保存時の文字コード
set fileformats=unix,dos,mac  " 改行コードの自動判別. 左側が優先される

" ステータス表示
"----------------------------------------
set statusline=%{F}  " ファイル名表示
set statusline+=%{r} " 読み込み専用かどうか表示
set statusline+=%{m} " 変更チェック表示
"----------------------------------------

" コマンド設定
"----------------------------------------
set wildmenu      " コマンドモードの補完
set history=5000  " 保存するコマンド履歴の数
"----------------------------------------

" 検索
"----------------------------------------
set ignorecase  " 検索するときに大文字小文字を区別しない
set incsearch   " インクリメンタル検索 (検索ワードの最初の文字を入力した時点で検索が開始)
set hlsearch    " 検索結果をハイライト表示
"----------------------------------------

" 表示設定
"----------------------------------------
set noerrorbells                  " エラーメッセージの表示時にビープを鳴らさない
set expandtab                     " 入力モードでTabキー押下時に半角スペースを挿入
set shiftwidth=2                  " インデント幅
set autoindent                    " 改行時に前の行のインデントを継続する
set tabstop=2                     " ファイル内にあるタブ文字の表示幅
set showmatch                     " 対応する括弧を強調表示
set smartindent                   " 改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set noswapfile                    " スワップファイルを作成しない
set title                         " タイトルを表示
set number                        " 行番号を表示
set mouse=a                       " バッファスクロール
set clipboard=unnamed,autoselect  " ヤンクでクリップボードにコピー
syntax on                         " シンタックスハイライト
set cursorcolumn                  " 現在の行を強調表示(縦)
set cursorline                    " 現在の行を強調表示(横)

" Escの2回押しでハイライト消去
nnoremap <Esc><Esc> :nohlsearch<CR><ESC>
" コメントの色を水色
hi Comment ctermfg=3
"----------------------------------------

" その他設定
"----------------------------------------
set backspace=indent,eol,start  " 挿入モードでの <BS>, <Del>, CTRL-W, CTRL-U の働きに影響する
set nocompatible                " おまじない(もういらない？)
"----------------------------------------

" ペースト設定
"----------------------------------------
if &term =~ "xterm"
  let &t_SI .= "\e[?2004h"
  let &t_EI .= "\e[?2004l"
  let &pastetoggle = "\e[201~"

  function XTermPasteBegin(ret)
    set paste
    return a:ret
  endfunction

  inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif
"----------------------------------------

inoremap <C-> <ESC>

inoremap <C-Return> <ESC>

"プラグイン設定
"----------------------------------------
call plug#begin()
 Plug 'preservim/nerdtree'
 Plug 'blueshirts/darcula'
" Plug 'joshdick/onedark'
 Plug 'morhetz/gruvbox'
 Plug 'arcticicestudio/nord-vim'
 Plug 'haishanh/night-owl.vim'
 Plug 'alvan/vim-closetag'
 Plug 'gre/play2vim'
 Plug 'vim-airline/vim-airline'
 Plug 'vim-airline/vim-airline-themes'
 Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
 Plug 'junegunn/fzf.vim'
 "Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
 Plug 'neoclide/coc.nvim', {'branch': 'release'}
 Plug 'derekwyatt/vim-scala'
 "Plug 'neoclide/coc.vim', {'do': { -> coc#util#install()}}
 Plug 'airblade/vim-gitgutter'
 Plug 'tpope/vim-commentary'
 " :Gdiff
 Plug 'tpope/vim-fugitive'  
 Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }
call plug#end()
"----------------------------------------

autocmd ColorScheme * highlight markdownCode guifg=#DDDDDD
autocmd ColorScheme * highlight markdownCodeDelimiter guifg=#DDDDDD

"colorscheme onedark
colorscheme gruvbox

highlight Normal ctermbg=none
highlight NonText ctermbg=none
highlight LineNr ctermbg=none
highlight Folded ctermbg=none
highlight EndOfBuffer ctermbg=none

autocmd vimenter * NERDTree
autocmd TabNew * call timer_start(0,{ -> execute('NERDTree') })
autocmd bufenter * if (winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree()) |q| endif

nnoremap ff :Files<Return>
nnoremap <C-b> :Blines<Return>
nnoremap <C-h> :History<Return>
nnoremap <C-r> :Rg<Return>
nnoremap <C-n> :NERDTree<Return>

command! -bang -nargs=? -complete=dir Files
      \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

if (has("termguicolors"))
  set termguicolors
endif

if !has('gui_running')
  set t_Co=256
endif

inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap {<Enter> []<Left><CR><ESC><S-o>
inoremap {<Enter> ()<Left><CR><ESC><S-o>

au BufRead,BufNewFile *.sbt set filetype=scala

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gf <Plug>(coc-format)

""" ----[ markdown ]--------------------- 
let g:mkdp_auto_start = 1
let g:mkdp_auto_close = 1
let g:mkdp_refresh_slow = 1
"dein Scripts-----------------------------
"if &compatible
"  set nocompatible               " Be iMproved
"endif

"" Required:
"set runtimepath+=/Users/takapi327/.cache/dein/repos/github.com/Shougo/dein.vim

"" Required:
"if dein#load_state('/Users/takapi327/.cache/dein')
"  call dein#begin('/Users/takapi327/.cache/dein')

"  " Let dein manage dein
"  " Required:
"  call dein#add('/Users/takapi327/.cache/dein/repos/github.com/Shougo/dein.vim')

"  " Add or remove your plugins here like this:
"  "call dein#add('Shougo/neosnippet.vim')
"  "call dein#add('Shougo/neosnippet-snippets')
"  call dein#add('airblade/vim-gitgutter')   " git追加削除表示機能
"  call dein#add('tpope/vim-commentary')     " 複数コメントアウト機能

"  " Required:
"  call dein#end()
"  call dein#save_state()
"endif

"" Required:
"filetype plugin indent on
"syntax enable

"" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

"End dein Scripts-------------------------

function! s:get_syn_id(transparent)
  let synid = synID(line("."), col("."), 1)
  if a:transparent
    return synIDtrans(synid)
  else
    return synid
  endif
endfunction
function! s:get_syn_attr(synid)
  let name = synIDattr(a:synid, "name")
  let ctermfg = synIDattr(a:synid, "fg", "cterm")
  let ctermbg = synIDattr(a:synid, "bg", "cterm")
  let guifg = synIDattr(a:synid, "fg", "gui")
  let guibg = synIDattr(a:synid, "bg", "gui")
  return {
        \ "name": name,
        \ "ctermfg": ctermfg,
        \ "ctermbg": ctermbg,
        \ "guifg": guifg,
        \ "guibg": guibg}
endfunction
function! s:get_syn_info()
  let baseSyn = s:get_syn_attr(s:get_syn_id(0))
  echo "name: " . baseSyn.name .
        \ " ctermfg: " . baseSyn.ctermfg .
        \ " ctermbg: " . baseSyn.ctermbg .
        \ " guifg: " . baseSyn.guifg .
        \ " guibg: " . baseSyn.guibg
  let linkedSyn = s:get_syn_attr(s:get_syn_id(1))
  echo "link to"
  echo "name: " . linkedSyn.name .
        \ " ctermfg: " . linkedSyn.ctermfg .
        \ " ctermbg: " . linkedSyn.ctermbg .
        \ " guifg: " . linkedSyn.guifg .
        \ " guibg: " . linkedSyn.guibg
endfunction
command! SyntaxInfo call s:get_syn_info()
