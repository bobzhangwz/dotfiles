function! myspacevim#before() abort
  augroup tsx_filetype
    autocmd!
    autocmd BufNewFile,BufRead *.tsx set filetype=typescript.tsx
  augroup END

  let g:coc_global_extensions = ['coc-json', 'coc-git', 'coc-html', 'coc-prettier', 'coc-eslint', 'coc-tsserver']
  let g:better_whitespace_enabled=1
  let g:strip_whitespace_on_save=1
endfunction

function! myspacevim#after() abort
  " Use <c-space> to trigger completion.
  inoremap <silent><expr> <c-space> coc#refresh()

  " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
  " Coc only does snippet and additional edit on confirm.
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

  " Use `[g` and `]g` to navigate diagnostics
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)

  " Used to expand decorations in worksheets
  nmap <Leader>ws <Plug>(coc-metals-expand-decoration)

  " Use K to either doHover or show documentation in preview window
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  " Highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Remap for rename current word
  nmap <leader>rn <Plug>(coc-rename)

  " Remap for format selected region
  xmap <leader>f  <Plug>(coc-format-selected)
  nmap <leader>f  <Plug>(coc-format-selected)

  augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType scala setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

    " Remap keys for gotos
    autocmd FileType scala nmap <silent> gd <Plug>(coc-definition)
    autocmd FileType scala nmap <silent> gy <Plug>(coc-type-definition)
    autocmd FileType scala nmap <silent> gi <Plug>(coc-implementation)
    autocmd FileType scala nmap <silent> gr <Plug>(coc-references)
  augroup end

  " Remap for do codeAction of current line
  xmap <leader>a  <Plug>(coc-codeaction-line)
  nmap <leader>a  <Plug>(coc-codeaction-line)

  " Fix autofix problem of current line
  nmap <leader>qf  <Plug>(coc-fix-current)

  " Use `:Format` to format current buffer
  command! -nargs=0 Format :call CocAction('format')

  " Use `:Fold` to fold current buffer
  command! -nargs=? Fold :call     CocAction('fold', <f-args>)

  " Trigger for code actions
  " Make sure `"codeLens.enable": true` is set in your coc config
  nnoremap <leader>cl :<C-u>call CocActionAsync('codeLensAction')<CR>

  " Show all diagnostics
  nnoremap <silent> <space>la  :<C-u>CocList diagnostics<cr>
  " Manage extensions
  nnoremap <silent> <space>le  :<C-u>CocList extensions<cr>
  " Show commands
  nnoremap <silent> <space>lc  :<C-u>CocList commands<cr>
  " Find symbol of current document
  nnoremap <silent> <space>lo  :<C-u>CocList outline<cr>
  " Search workspace symbols
  nnoremap <silent> <space>ls  :<C-u>CocList -I symbols<cr>
  " Do default action for next item.
  nnoremap <silent> <space>lj  :<C-u>CocNext<CR>
  " Do default action for previous item.
  nnoremap <silent> <space>lk  :<C-u>CocPrev<CR>
  " Resume latest coc list
  " nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

  " Notify coc.nvim that <enter> has been pressed.
  " Currently used for the formatOnType feature.
  inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
        \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  " Toggle panel with Tree Views
  nnoremap <silent> <space>lt :<C-u>CocCommand metals.tvp<CR>
  " Toggle Tree View 'metalsPackages'
  nnoremap <silent> <space>ltp :<C-u>CocCommand metals.tvp metalsPackages<CR>
  " Toggle Tree View 'metalsCompile'
  nnoremap <silent> <space>ltc :<C-u>CocCommand metals.tvp metalsCompile<CR>
  " Toggle Tree View 'metalsBuild'
  nnoremap <silent> <space>ltb :<C-u>CocCommand metals.tvp metalsBuild<CR>
  " Reveal current current class (trait or object) in Tree View 'metalsPackages'
  nnoremap <silent> <space>ltf :<C-u>CocCommand metals.revealInTreeView metalsPackages<CR>
endfunction

