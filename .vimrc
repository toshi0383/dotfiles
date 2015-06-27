set hlsearch
set expandtab
set tabstop=2
set shiftwidth=2
set noautoindent

" タイムライン選択用の Unite を起動する
 nnoremap <silent> t :Unite tweetvim<CR>
" " 発言用バッファを表示する
 nnoremap <silent> s :TweetVimSay<CR>
" NeoBundle
     " Note: Skip initialization for vim-tiny or vim-small.
     if !1 | finish | endif

     if has('vim_starting')
       if &compatible
         set nocompatible               " Be iMproved
       endif

       " Required:
       set runtimepath+=~/.vim/bundle/neobundle.vim/
     endif

     " Required:
     call neobundle#begin(expand('~/.vim/bundle/'))

     " Let NeoBundle manage NeoBundle
     " Required:
     NeoBundleFetch 'Shougo/neobundle.vim'

     " My Bundles here:
     " Refer to |:NeoBundle-examples|.
     " Note: You don't set neobundle setting in .gvimrc!
     NeoBundle 'basyura/TweetVim'
     NeoBundle 'mattn/webapi-vim'
     NeoBundle 'basyura/twibill.vim'
     NeoBundle 'tyru/open-browser.vim'
     NeoBundle 'h1mesuke/unite-outline'
     NeoBundle 'basyura/bitly.vim'
     NeoBundle 'Shougo/unite.vim'

     call neobundle#end()

     " Required:
     filetype plugin indent on

     " If there are uninstalled bundles found on startup,
     " this will conveniently prompt you to install them.
     NeoBundleCheck

command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
  " Building a hash ensures we get each buffer only once
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let bufnr = quickfix_item['bufnr']
    " Lines without files will appear as bufnr=0
    if bufnr > 0
      let buffer_numbers[bufnr] = bufname(bufnr)
    endif
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction
