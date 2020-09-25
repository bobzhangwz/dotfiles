function! myspacevim#before() abort
  augroup tsx_filetype 
    autocmd!
    autocmd BufNewFile,BufRead *.tsx set filetype=typescript
  augroup END
endfunction

function! myspacevim#after() abort
endfunction

