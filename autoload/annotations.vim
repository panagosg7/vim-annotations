" qfnotes.vim
" Create file notes in quickfix format
" Last Change: $HGLastChangedDate$
" Maintainer: Sergey Khorev <sergey.khorev@gmail.com>
" Based on qfn.vim by Will Drewry <redpig@dataspill.org>: http://www.vim.org/scripts/script.php?script_id=2216
" License: See qfnotes.txt packaged with this file.

if exists("g:loaded_qfnotes_auto")
  finish
endif
let g:loaded_qfnotes_auto = 1

" Arguments:
" * range is a list with 4 elements: [startLine, startCol, endLine, endCol]
" * position is a list with 2 elements: [line, col]
function Contains(range, position) 
  if a:position[0] < a:range[0] 
    return 0 
  endif
  if a:position[0] == a:range[0]
    if a:position[1] < a:range[1]
      return 0
    endif
  endif
  if a:position[0] > a:range[2] 
    return 0
  endif
  if a:position[0] == a:range[2]
    if a:position[1] > a:range[3]
      return 0
    endif
  endif
  return 1 
endfunction

let s:hdevtools_info_buffer = -1

function qfnotes#LoadAnns(fileName)
  let b:file = readfile(a:fileName)
  let b:spans = []
  echo "Loaded annotation file: " . a:fileName
  for line in b:file
    let div = stridx(line, "::")
    let llmatch = matchlist(line, '\(\d\+\):\(\d\+\)-\(\d\+\):\(\d\+\)::\(.*\)')
    let l:ss = [llmatch[1], llmatch[2], llmatch[3], llmatch[4]]
    let val0 = llmatch[5]
    let val1 = substitute(val0, '"', '', 'g') 
    let val2 = substitute(val1, '\\n', '\n', 'g') 
    call add(b:spans, [l:ss, val2])
  endfor
  let b:spans_length = len(b:spans)
  let b:spans_cur_pos = 0
  let b:ann_file_loaded = 1

  " Enable mappings
  nnoremap <buffer> <F1> :LQType<CR>
  nnoremap <buffer> <F2> :ClearLQType<CR>
  
endfunction

function! qfnotes#clear_highlight()
  if exists('w:ann_matchid')
    call matchdelete(w:ann_matchid)
    unlet w:ann_matchid
  endif
endfunction


function qfnotes#Type(...)

  if !b:ann_file_loaded
    echoerr "You need to load annotation file first." 
    return
  endif

  " Clear previous highlights
  call qfnotes#clear_highlight()
  let curPos = [line("."), col(".")]

  " Cycle through available annotations - do at most b:spans_length steps
  let i = 0
  while i < b:spans_length
    let i = i + 1
    let b:spans_cur_pos = (b:spans_cur_pos + 1) % b:spans_length
    let range = b:spans[b:spans_cur_pos][0]

    if Contains(range, curPos)
      " Clear previous highlights
      call qfnotes#clear_highlight()

      " Highlight the expression we're looking for
      let group = get(g:, 'highlight', 'Visual')
      let w:ann_matchid = matchadd(group, '\%' . range[0] . 'l\%' . range[1] . 'c\_.*\%' . range[2] . 'l\%' . range[3] . 'c')

      echo b:spans[b:spans_cur_pos][1]
      syntax sync fromStart

      return
    endif
  endwhile
  echo "No annotation found"
  
endfunction

" vim: set ft=vim ts=8 sts=2 sw=2:
