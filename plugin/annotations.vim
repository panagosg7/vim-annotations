" annotations.vim

if exists("g:loaded_qfnotes")
  finish
endif
let g:loaded_qfnotes = 1


if v:version < 700
  echo "QFXotes requires version 7.0 or higher"
  finish
endif

noremap <SID>LQType :call annotations#Type()<CR>
noremap <SID>ClearLQType :call annotations#clear_highlight()<CR>
" noremap <SID>LoadAnns :call annotations#LoadAnns(1)<CR>
noremap <SID>LoadAnnsDefault :call annotations#LoadAnnsDefault()<CR>

command! -nargs=0 LQType                  :call annotations#Type()
command! -nargs=0 ClearLQType             :call annotations#clear_highlight()
command! -nargs=1 -complete=file LoadAnns :call annotations#LoadAnns(<f-args>)
command! -nargs=0 LoadAnnsDefault         :call annotations#LoadAnnsDefault()

finish

Vimball filelist

doc/vim-annotations.txt
autoload/annotations.vim
plugin/annotations.vim

" vim: set ft=vim ts=8 sts=2 sw=2:
