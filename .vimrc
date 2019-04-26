" 基本的には以下のページを写経しただけ.
" https://qiita.com/kooooooooooooooooohe/items/fb106e0a0f0969b4ee38

set encoding=utf-8
scriptencoding utf-8

" 保存時の文字コード
set fileencoding=utf-8

" 読み込み時の文字コードの自動判別. 左側が優先される
set fileencodings=ucs-boms,utf-8,euc-jp,cp932

" 改行コードの自動判別. 左側が優先される
set fileformats=unix,dos,mac
" □や○文字が崩れる問題を解決"
set ambiwidth=double

" backspaceが効かない場合はこれが効くらしい
" https://qiita.com/omega999/items/23aec6a7f6d6735d033f
"set backspace=indent,eol,start

"ヤンクした時にクリップボードにコピーする
set clipboard=unnamed,autoselect

" タブ入力を複数の空白入力に置き換える
set expandtab

" 画面上でタブ文字が占める幅
set tabstop=4

" 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set softtabstop=4

" 改行時に前の行のインデントを継続する
set autoindent

" 改行時に前の行の構文をチェックし次の行のインデントを増減する
set smartindent

" smartindentで増減する幅"
set shiftwidth=4

" インクリメンタルサーチ. １文字入力毎に検索を行う
set incsearch
" 検索パターンに大文字小文字を区別しない
set ignorecase
" 検索パターンに大文字を含んでいたら大文字小文字を区別する
set smartcase
" 検索結果をハイライト"
set hlsearch

" 不可視文字を可視化(タブが「▸-」と表示される)
set list listchars=tab:\▸\-

" カーソルの左右移動で行末から次の行の行頭への移動が可能になる
" set whichwrap=b,s,h,l,<,>,[,],~

" カーソルラインをハイライト"
set cursorline

" vim-quickrunで常に右側にコンソール窓が開くように.
" https://github.com/thinca/vim-quickrun/issues/157
set splitright

" yankされる最大行数の指定だったような
set viminfo='20,\"1000

"=================dein================
" プラグインが実際にインストールされるディレクトリ
let s:dein_dir = expand('~/.cache/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'


" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" 設定開始
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイル（後述）を用意しておく
  let g:rc_dir    = expand('~/.vim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  " let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  " call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " 設定終了
  call dein#end()
  call dein#save_state()
endif

" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif

" syntaxハイライト関連、だったような
filetype plugin indent on
" colorscheme molokai
set background=light
colorscheme PaperColor
syntax on

" leader
let mapleader = "\<Space>"

nnoremap <Leader>w :w<CR>
nnoremap <Leader>qa :qa<CR>
nnoremap <Leader>q :q<CR>

"==============プラグイン関係の設定==============

let g:vimfiler_as_default_explorer = 1

" For vim-go
inoremap <C-L> <C-x><C-o>

" QuickRun
nmap <Leader>r :QuickRun<CR>
nmap <Leader>b :GoBuild<CR>
nmap <Leader>i :GoImports<CR>
nmap <Leader>ta :GoTest<CR>
nmap <Leader>tf :GoTestFunc<CR>
nmap <Leader>tc :GoTestCompile<CR>
nmap <Leader>jq :%!jq '.'<CR>

" NERDTree
nmap <C-n> :NERDTreeFind<CR>
nmap <C-m> :NERDTreeToggle<CR>

"==============ファイルタイプごとの設定==============
autocmd FileType html setlocal shiftwidth=2 tabstop=2
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2
autocmd FileType yml setlocal shiftwidth=2 tabstop=2
