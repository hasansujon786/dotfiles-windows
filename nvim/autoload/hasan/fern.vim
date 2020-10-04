function! hasan#fern#open_drawer() abort
  if expand('%:t') == ''
    Fern . -drawer -toggle | wincmd =
  else
    Fern . -drawer -toggle -reveal=% | wincmd =
  endif
endfunction

" Fern select last file {{{
function! hasan#fern#smart_path() abort
  if !empty(&buftype) || bufname('%') =~# '^[^:]\+://'
    return fnamemodify('.', ':p')
  endif
  return fnamemodify(expand('%'), ':p:h')
endfunction

function! hasan#fern#try_To_select_last_file() abort
  if s:fern_last_file !=# ''
    call search('\v<' . s:fern_last_file . '>')
  endif
endfunction

function! hasan#fern#before_Try_To_select_last_file() abort
  let s:fern_last_file=expand('%:t')
endfunction
" }}}

" Fern mappings {{{
function! hasan#fern#FernInit() abort
  " fern-custom-actions {{{
  nnoremap <Plug>(fern-close-drawer) :<C-u>FernDo close -drawer -stay<CR>
  nmap <buffer><silent> <Plug>(fern-action-open-and-close)
        \ <Plug>(fern-action-open:select)
        \ <Plug>(fern-close-drawer)
  nmap <buffer><expr>
        \ <Plug>(fern-custom-openAndClose-expand-collapse)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open-and-close)",
        \   "\<Plug>(fern-action-expand)",
        \   "\<Plug>(fern-action-collapse)",
        \ )

  " }}}

  " Open file
  nmap <buffer> <2-LeftMouse> <Plug>(fern-custom-openAndClose-expand-collapse)
  nmap <buffer> <CR> <Plug>(fern-custom-openAndClose-expand-collapse)
  nmap <buffer> o <Plug>(fern-custom-openAndClose-expand-collapse)
  nmap <buffer> O <Plug>(fern-action-open:tabedit)
  nmap <buffer> t <Plug>(fern-action-open:tabedit)
  nmap <buffer> T <Plug>(fern-action-open:tabedit)gT
  nmap <buffer> e <Plug>(fern-action-open:edit)
  nmap <buffer> go <Plug>(fern-action-open:edit)<C-w>p
  nmap <buffer> s <Plug>(fern-action-open:split)
  nmap <buffer> gs <Plug>(fern-action-open:split)<C-w>p
  nmap <buffer> v <Plug>(fern-action-open:vsplit)
  nmap <buffer> gv <Plug>(fern-action-open:vsplit)<C-w>p
  nmap <buffer> E <Plug>(fern-action-open:side)
  nmap <buffer> S <Plug>(fern-action-open:system)

  " Mark file & folders
  nmap <buffer> m <Plug>(fern-action-mark:toggle)
  vmap <buffer> m <Plug>(fern-action-mark:toggle)
  nmap <buffer> Q <Plug>(fern-action-mark:clear)

  " Create, Delete, Copy, Move, Rename
  nmap <buffer> A <Plug>(fern-action-new-path)
  nmap <buffer> N <Plug>(fern-action-new-file)
  nmap <buffer> K <Plug>(fern-action-new-dir)
  nmap <buffer> M <Plug>(fern-action-move)
  nmap <buffer> C <Plug>(fern-action-copy)
  nmap <buffer> R <Plug>(fern-action-rename)
  nmap <buffer> D <Plug>(fern-action-remove)

  " Various instant mappings
  nmap <buffer> r <Plug>(fern-action-reload)
  nmap <buffer> x <Plug>(fern-action-collapse)
  nmap <buffer> I <Plug>(fern-action-hidden:toggle)
  nmap <buffer> W <Plug>(fern-action-cd)
  nmap <buffer> B <Plug>(fern-action-save-as-bookmark)
  nmap <buffer> q <C-w>c
  nmap <buffer> <BAR> <Plug>(fern-action-zoom)<C-w>=
  nmap <buffer> <nowait> < <Plug>(fern-action-leave)
  nmap <buffer> <nowait> - <Plug>(fern-action-leave)
  nmap <buffer> <nowait> > <Plug>(fern-action-enter)

  " nmap <buffer> K <Plug>(fern-action-mark-children:leaf)

endfunction
" }}}
