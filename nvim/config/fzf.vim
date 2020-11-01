" nnoremap <silent> - :Files <C-R>=expand('%:h')<CR><CR>
nnoremap <silent> <C-p>      :ProjectRecentFiles<CR>
nnoremap <silent> <C-k>p     :Files<CR>
nnoremap <silent> <C-k><C-p> :History<CR>

nnoremap <silent> <C-k>b :Buffers<CR>
nnoremap <silent> <C-k>w :Windows<CR>
nnoremap <silent> <C-k>m :Filetypes<CR>

nnoremap <silent> <C-k>' :Marks<CR>
nnoremap <silent> <C-k>? :GFile?<CR>
nnoremap <silent> <C-k>/ :History/<CR>
nnoremap <silent> <C-k>k :History:<CR>
nnoremap <silent> <C-k><C-k> :History:<CR>

nnoremap <A-/> :RG!<space>
vnoremap <A-/> y:RG!<space><C-r>"
nnoremap <silent> // :BLines<CR>
nnoremap <silent> <C-k>l :Lines<CR>

" Enhanced RipGrep integration with fzf
command! -nargs=* -bang RG call hasan#fzf#_ripgrep(<q-args>, <bang>0)
" Project recent & git filet togather
command! -bang ProjectRecentFiles call hasan#fzf#_project_recent_files(s:p(<bang>0), <bang>0)

" let g:fzf_layout = { 'down': '~70%' }
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.7 } }
" let g:fzf_files_options = '--reverse --preview "(cat {})"'
" let g:fzf_preview_window = 'right:60%'

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
      \ 'ctrl-q': function('s:build_quickfix_list'),
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit',
      \ 'q': 'normal <C-c>',
      \}

" Requires ripgrep
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!.git/*"'
let $FZF_DEFAULT_OPTS =
      \'--bind ctrl-a:select-all'

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Directory'],
  \ 'fg+':     ['fg', 'Type', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'Visual','CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Directory'],
  \ 'info':    ['fg', 'Keyword'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Directory'],
  \ 'gutter':  ['fg', 'Search'],
  \ 'pointer': ['fg', 'Type'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

function! s:p(bang, ...)
  let preview_window = get(g:, 'fzf_preview_window', a:bang && &columns >= 80 || &columns >= 120 ? 'right': '')
  if len(preview_window)
    return call('fzf#vim#with_preview', add(copy(a:000), preview_window))
  endif
  return {}
endfunction

