" annotations.vim

if !exists("g:vim_annotations_offset")
  let g:vim_annotations_offset = ''
endif

if !exists("g:vim_annotations_suffix")
  let g:vim_annotations_suffix = '.vim.annot' 
endif

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

function annotations#LoadAnns(fileName)
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

function annotations#LoadAnnsDefault()
  " let annFile = expand("%") . ".vim.annot"
  " let annFile = expand('%:p:h') . '/.liquid/' . expand('%:t') . '.vim.annot'
  let off  = g:vim_annotations_offset
  let suf  = g:vim_annotations_suffix 
  let file = expand('%:p:h') . off . expand('%:t') . suf
  call annotations#LoadAnns(file) 
endfunction

function! annotations#clear_highlight()
  if exists('w:ann_matchid')
    call matchdelete(w:ann_matchid)
    unlet w:ann_matchid
  endif
endfunction


function annotations#Type(...)
  if !b:ann_file_loaded
    echoerr "You need to load annotation file first." 
    return
  endif

  " Clear previous highlights
  call annotations#clear_highlight()
  let curPos = [line("."), col(".")]

  " Cycle through available annotations - do at most b:spans_length steps
  let i = 0
  while i < b:spans_length
    let i = i + 1
    let b:spans_cur_pos = (b:spans_cur_pos + 1) % b:spans_length
    let range = b:spans[b:spans_cur_pos][0]

    if Contains(range, curPos)
      " Clear previous highlights
      call annotations#clear_highlight()

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


function LookupAnnotation(curPos)
  let i = 0
  while i+1 < b:spans_length
    let i     = i + 1
    let range = b:spans[i][0]

    if Contains(range, a:curPos)
      return b:spans[i][1]
    endif
  endwhile
  return ""
endfunction

function! AnnotBalloonExpr()
  
  if !exists("b:ann_file_loaded") 
    return ""
  endif

  
  " if !b:ann_file_loaded
  "   " echoerr "You need to load annotation file first." 
  "   return ""
  " endif
  
  let curPos = [v:beval_lnum, v:beval_col]
  
  return LookupAnnotation(curPos)

  " return 'Cursor is at line ' . v:beval_lnum . "\n" . 
  "       \', column ' . v:beval_col . "\n" .
  "       \ ' of file ' .  bufname(v:beval_bufnr) . "\n" .
  "       \ ' on word "' . v:beval_text . '"'
endfunction


if has("gui")
  set bexpr=AnnotBalloonExpr()
  set ballooneval
endif

" vim: set ft=vim ts=8 sts=2 sw=2:
