" qfnotes.vim
" Create file notes in quickfix format
" Last Change: $HGLastChangedDate$
" Maintainer: Sergey Khorev <sergey.khorev@gmail.com>
" Based on qfn.vim by Will Drewry <redpig@dataspill.org>: http://www.vim.org/scripts/script.php?script_id=2216
" License: See qfnotes.txt packaged with this file.

if exists("g:loaded_qfnotes")
  finish
endif
let g:loaded_qfnotes = 1


if v:version < 700
  echo "QFXotes requires version 7.0 or higher"
  finish
endif

noremap <SID>LQType :call qfnotes#Type()<CR>
noremap <SID>ClearLQType :call qfnotes#clear_highlight()<CR>
noremap <SID>LoadAnns :call qfnotes#LoadAnns(1)<CR>

command! -nargs=0 LQType :call qfnotes#Type()
command! -nargs=0 ClearLQType :call qfnotes#clear_highlight()
command! -nargs=1 -complete=file LoadAnns :call qfnotes#LoadAnns(<f-args>)

finish

" vim: set ft=vim ts=8 sts=2 sw=2:
