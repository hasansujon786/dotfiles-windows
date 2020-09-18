" => coc-settings ---------------------------------- {{{
" Always show the signcolumn,
" otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes
" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
" Highlighting same symbols in the buffer at the current cursor position.
highlight CocHighlightText ctermbg=gray guibg=#3B4048

augroup mygroup
  autocmd!
  " Highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  " Ope CocSearch window on the left
  autocmd BufRead,BufNewFile __coc_refactor__* wincmd H
augroup end

" }}}
" => coc-mappings ---------------------------------- {{{
" Use K to show documentation in preview window. {{{
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
" }}}
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Use `[d` and `]d` to navigate diagnostics
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gD <Plug>(coc-declaration)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gI <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gR <Plug>(coc-refactor)
" Search world in whole project
nnoremap gcs :CocSearch <C-R>=expand("<cword>")<CR><CR>
xnoremap gcs y:CocSearch -F <C-r>"<Home><C-right><C-right><C-right>\<C-right>
" Symbol renaming
nmap <silent> <F2> <Plug>(coc-rename)
" Quick format
nmap <silent> gq <Plug>(coc-format)
nmap <silent> gQ <Plug>(coc-format-selected)
vmap <silent> gQ <Plug>(coc-format-selected)

" Introduce function text object
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)
" Class text object
xmap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ic <Plug>(coc-classobj-i)
omap ac <Plug>(coc-classobj-a)
" Use v/V for selections ranges. Require coc-tsserver, coc-python etc.
nmap <silent> <A-i> <Plug>(coc-range-select)
xmap <silent> <A-i> <Plug>(coc-range-select)

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <A-.> coc#refresh()
inoremap <silent><expr> <A-,> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" => coc-commands ===============================
" Save current buffer without saving the file.
command! -nargs=0 SaveWithoutFormat :noa w
" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')
" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call CocAction('fold', <f-args>)
" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

" }}}
" => coc-extensions-list --------------------------- {{{
let g:coc_global_extensions = [
      \ 'coc-tsserver',
      \ 'coc-snippets',
      \ 'coc-json',
      \ 'coc-html',
      \ 'coc-css',
      \ 'coc-emmet',
      \ 'coc-prettier',
      \ 'coc-yank'
      \ ]

" https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
" coc-pairs coc-syntax coc-word coc-tag coc-dictionary
" => JavaScript
" coc-vetur coc-styled-components

" => HTML
" coc-tailwindcss

" => Ediort Support
" coc-bookmark coc-actions coc-lists coc-spell-checker coc-vimlsp

" => CLang
" coc-clangd

" }}}
" => coc-extensions-configs ------------------------ {{{

"##### coc-snippets  #####
" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)
" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)
" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'
" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'
" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" }}}

" Modern TypeScript and React Development in Vim
" https://thoughtbot.com/blog/modern-typescript-and-react-development-in-vim
