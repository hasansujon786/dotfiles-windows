augroup vimrcEx
  autocmd!
  " Vertically center document when entering insert mode
  autocmd InsertEnter * norm zz

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

  " Vim/tmux layout rebalancing
  " automatically rebalance windows on vim resize
  autocmd VimResized * :wincmd =
augroup END

" Only show the cursor line in the active buffer.
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

" Neovim terminal
if has('nvim')
  augroup Terminal
    au!
    au TermOpen * setfiletype terminal | set bufhidden=hide | :startinsert
    au BufEnter * if &buftype == 'terminal' | :startinsert | endif
    au FileType terminal setlocal nonumber norelativenumber signcolumn=no
  augroup END
endif
