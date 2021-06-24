"dein Scripts-----------------------------
if &compatible
  set nocompatible " Be iMproved
endif

" Required:
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
call dein#begin('~/.cache/dein')

" Let dein manage dein
" Required:
call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')

" Add or remove your plugins here like this:
"call dein#add('Shougo/neosnippet.vim')
"call dein#add('Shougo/neosnippet-snippets')

call dein#load_toml('~/.config/nvim/dein.toml', {'lazy': 0})
call dein#load_toml('~/.config/nvim/dein_lazy.toml', {'lazy': 1})

" Required:
call dein#end()

" Required:
filetype plugin indent on " ファイル形式別プラグインとインデントを有効にする
syntax enable " シンタックスを有効にする

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

" plugin remove check
let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
  call map(s:removed_plugins, "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endif

"End dein Scripts-------------------------

" オプション {{{
set number
set ts=4 sts=4 sw=4 expandtab
set wrap " 画面の端で行を折り返す
set nobackup noswapfile " バックアップファイル swpファイル 出力無効
set autoread " 外部でファイルに変更がされた場合は読みなおす
set belloff=all " ミュート
set smartindent autoindent " 改行時自動インデント
set incsearch " インクリメントサーチを有効にする
set ignorecase " 検索時大文字小文字を区別しない
set smartcase " 検索時に大文字を入力した場合ignorecaseが無効になる
set hlsearch " ハイライトサーチを有効にする
set undolevels=100 " undoできる最大数
set lazyredraw " コマンド実行中は再描画しない
set ttyfast " 高速ターミナル接続を行う
set cursorline " カーソルラインを表示する
set wildmenu " wildmenuを有効にする
set helplang=ja " ヘルプの言語を日本語優先にする
set noshowmode " 左下のインサートモードなどの文字を非表示にする
set laststatus=2 " 下部のステータスラインを常に表示
set list " 不可視文字を表示する
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:% " listの設定
set clipboard+=unnamed " クリップボードを共有
set mouse=a " スクロール
set inccommand=split
" }}}

" Colors {{{
if (has("termguicolors"))
  set termguicolors
endif
" }}}

" Completion {{{
set completeopt=menuone,noinsert,noselect " 入力モードでの補完についてのオプション
" }}}

" カーソルラインの位置を保存する {{{
augroup cursorlineRestore
  autocmd!
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g'\"" |
        \ endif
augroup END
" }}}

" undoを編集前に戻せるように設定 {{{
if has('persistent_undo')
  let undo_path = expand('~/.config/nvim/undo')
  if !isdirectory(undo_path)
    call mkdir(undo_path, 'p')
  endif
  exec 'set undodir=' .. undo_path
  set undofile
endif
" }}}

" ファイラ {{{
let g:netrw_liststyle=1 " ファイルツリーの表示形式、1にするとls -laのような表示
let g:netrw_banner=0 " ヘッダを非表示にする
let g:netrw_sizestyle="H" " サイズを(K,M,G)で表示する
let g:netrw_timefmt="%Y/%m/%d(%a) %H:%M:%S" " yyyy/mm/dd(曜日) hh:mm:ss で表示
let g:netrw_preview=1 " プレビューウィンドウを垂直分割で表示する
" }}}

" テキストオブジェクトキーマッピング {{{
let g:mapleader = ";" " Leaderキーを設定

" オペレータ待機
onoremap 8 i(
onoremap 2 i"
onoremap 7 i'
onoremap @ i`
onoremap [ i[
onoremap { i{

onoremap a8 a(
onoremap a2 a"
onoremap a7 a'
onoremap a@ a`
onoremap a[ a[
onoremap a{ a{

" visual
nnoremap v8 vi(
nnoremap v2 vi"
nnoremap v7 vi'
nnoremap v@ vi`
nnoremap v[ vi[
nnoremap v{ vi{

nnoremap va8 va(
nnoremap va2 va"
nnoremap va7 va'
nnoremap va@ va`
nnoremap va[ va[
nnoremap va{ va{

" タブ切り替え
nnoremap <C-l> gt

" 囲う
nnoremap <silent> gw[ cw``<Esc>P
vnoremap <silent> gw[ c``<Esc>P

" コマンドラインで単語移動
cnoremap <c-b> <Left>
cnoremap <c-f> <Right>
cnoremap <c-a> <Home>
" }}}
