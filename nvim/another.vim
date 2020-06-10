" personal vimrc
" Author:       Jon Smithers <mail@jonsmithers.link>
" URL:          https://github.com/jonsmithers/dotfiles/blob/master/vim/vimrc
" Last Updated: 2020-04-21

:scriptencoding utf8

if !exists('s:os')
  if has('win64') || has('win32') || has('win16')
    let s:os = 'Windows'
  elseif has('mac')
    let s:os = 'MacOS'
  else
    let s:os = 'Linux'
  endif
endif

if (s:os ==# 'Windows')
  set encoding=utf-8
endif

:let g:mapleader = ' '

" ┌───────────────────┐
" │ download vim-plug │
" └───────────────────┘
" {{{
if (s:os !=# 'Windows')
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    augroup vimplug
      au!
      autocmd VimEnter * PlugInstall --sync | exec 'source ' . expand('<sfile>')
    augroup END
  endif
else
  if empty(glob('~\vimfiles\autoload\plug.vim'))
    set shell=C:\\WINDOWS\\sysnative\\WindowsPowerShell\\v1.0\\powershell.exe
    !md ~\vimfiles\autoload
    !(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim', $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath('~\vimfiles\autoload\plug.vim'))
    augroup vimplug
      au!
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    augroup END
  endif
endif
" }}}

" ┌─────────────────────────┐
" │ install missing plugins │
" └─────────────────────────┘
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q | echom "Installed new plugins"
  \| endif

" {{{ Personal vim-plug utils
com! -nargs=+ PlugIfNeovim call s:plugIfNeovim(<args>)
com! -nargs=+ PlugDevelop call s:plugDev(<args>)
fun! s:plugIfNeovim(repo, ...)
  if a:0 > 1
    return s:err('Invalid number of arguments (1..2)')
  endif
  let l:opts = a:0 == 1 ? a:1 : { }
  if (has('nvim'))
    call plug#(a:repo, l:opts)
  endif
endfun
fun! s:plugDev(repo, ...)
  if a:0 > 1
    return s:err('Invalid number of arguments (1..2)')
  endif
  let l:devPath = '~/git/' . split(a:repo, '/')[1]
  let l:opts = a:0 == 1 ? a:1 : { }
  if (!empty(glob(l:devPath)))
    call extend(l:opts, { 'dir': l:devPath })
    call plug#(a:repo, l:opts)
  else
    call plug#(a:repo, l:opts)
  endif
endfun
fun! s:err(msg)
  echohl ErrorMsg
  echom '[vimrc] '.a:msg
  echohl None
endfun
let s:nerdtree_triggers = ['NERDTreeFind', 'NERDTreeClose', 'NERDTreeToggle', 'NERDTreeRefreshRoot']
" }}}

" ┌─────────┐
" │ plugins │
" └─────────┘
call plug#begin('~/.vim/plugged')

  Plug 'AndrewRadev/splitjoin.vim'
  " gJ on first line to join object literal into one line
  " gS to split one-line object into multiple lines

  Plug 'airblade/vim-gitgutter', { 'on': 'GitGutterEnable'}
  " {{{
    " I use vim-signify in lieu of gitgutter because it's faster. However,
    " gitgutter has a killer feature to stage the hunk under cursor. So I
    " disable every aspect of gitgutter, and temporarily enable it just when I
    " want to use this feature.
    let g:gitgutter_enabled = 0
    let g:gitgutter_signs = 0
    let g:gitgutter_async = 0
    let g:gitgutter_map_keys = 0
    :nmap <silent> <Leader>ga :GitGutterEnable<cr>:GitGutterStageHunk<cr>:GitGutterDisable<cr>:SignifyRefresh<cr>:echo 'staged hunk'<cr>
  " }}}

  " {{{ security patch
    if !has('patch-8.1.1365')
      " mitigate modeline security vulnerability in older vims https://github.com/numirias/security/blob/master/doc/2019-06-04_ace-vim-neovim.md
      set nomodeline
      Plug 'ciaranm/securemodelines'
      let g:secure_modelines_verbose = 1
    endif
  " }}}

  Plug 'ciaranm/detectindent'
  " Analyze current buffer and configure tabbing to match.
  " {{{
    nnoremap <leader>di :DetectIndent<cr>
    :let g:detectindent_preferred_indent = 2
  " }}}

  Plug 'chrisbra/Colorizer'
  " Show hex colors by running :ColorHighlight or :ColorToggle
  " {{{
    let g:colorizer_fgcontrast = 0
    let g:colorizer_hex_pattern = ['#\?', '\%(\x\{6}\)', '']
  " }}}

  Plug 'editorconfig/editorconfig-vim'
  " Adhere to .editorconfig files

  Plug 'Houl/ExplainPattern-vim'
  " Use :ExplainPattern to explain a vim-flavored regex

  Plug 'itchyny/lightline.vim'
  " Highly customizable bottom status bar
  " {{{
    " Some inspiration for this configuration is taken from https://statico.github.io/vim3.html#lightline-powerline-airline-and-status-bars
    set laststatus=2 "always show status bar (even when there are no splits)
    set noshowmode   "lightline will show mode for me
    set showcmd      "shows size of visual selection BELOW lightline
    let g:lightline = {
    \   'active': {
    \     'left': [
    \       ['mode', 'paste'],
    \       ['filename', 'modified'],
    \       ['git_changes'],
    \     ],
    \     'right': [
    \       ['lineinfo'],
    \       ['percent'],
    \       ['readonly', 'linter_warnings', 'linter_errors', 'linter_ok'],
    \     ]
    \   },
    \   'component_function': {
    \     'git_changes': 'LightLineChanges',
    \   },
    \   'component_expand': {
    \     'linter_warnings': 'LightlineLinterWarnings',
    \     'linter_errors':   'LightlineLinterErrors',
    \     'linter_ok':       'LightlineLinterOK',
    \   },
    \   'component_type': {
    \     'readonly':        'error',
    \     'linter_warnings': 'warning',
    \     'linter_errors':   'error'
    \   },
    \   'separator': {
    \     'left': '',
    \     'right': ''
    \   },
    \   'enable': {
    \     'statusline': 1,
    \     'tabline': 0
    \   }
    \ }
    " let g:lightline.separator.right = ''
    " let g:lightline.separator.left =  ''
    fun! LightLineChanges()
      let l:hunkSummary = v:null
      if exists('g:loaded_signify') && sy#buffer_is_active()
        let l:hunkSummary = sy#repo#get_stats()
      elseif exists('*GitGutterGetHunkSummary')
        let l:hunkSummary = GitGutterGetHunkSummary()
      endif
      if (empty(l:hunkSummary))
        return ''
      else
        let [ l:added, l:modified, l:removed ] = l:hunkSummary
        let l:total = (l:added + l:modified + l:removed)
        let l:output = ''
        if (l:added != 0)
          let l:output .= printf('+%d ', l:added)
        endif
        if (l:modified != 0)
          let l:output .= printf('~%d ', l:modified)
        endif
        if (l:removed != 0)
          let l:output .= printf('-%d ', l:removed)
        endif
        return '(' . l:output . ')'
      endif
    endfun
    fun! LightlineLinterWarnings() abort
      if (&readonly)
        return ''
      endif
      let l:counts = ale#statusline#Count(bufnr(''))
      let l:all_errors = l:counts.error + l:counts.style_error
      let l:all_non_errors = l:counts.total - l:all_errors
      return l:all_non_errors == 0 ? '' : printf('%d ▲', l:all_non_errors)
    endfun
    fun! LightlineLinterErrors() abort
      if (&readonly)
        return ''
      endif
      let l:counts = ale#statusline#Count(bufnr(''))
      let l:all_errors = l:counts.error + l:counts.style_error
      let l:all_non_errors = l:counts.total - l:all_errors
      return l:all_errors == 0 ? '' : printf('%d ✗', l:all_errors)
    endfun
    fun! LightlineLinterOK() abort
      if (&readonly)
        return ''
      endif
      let l:counts = ale#statusline#Count(bufnr(''))
      let l:all_errors = l:counts.error + l:counts.style_error
      let l:all_non_errors = l:counts.total - l:all_errors
      return l:counts.total == 0 ? '✓' : ''
    endfun
    augroup LightlineColorscheme
      autocmd!
      autocmd ColorScheme * call s:matchLightlineColorscheme()
      autocmd User ALELint call s:maybeUpdateLightline()
    augroup END
    fun! s:maybeUpdateLightline()
      " Update and show lightline but only if it's visible (e.g., not in Goyo)
      if exists('#lightline')
        call lightline#update()
      end
    endfun
    fun! s:matchLightlineColorscheme() abort
      func! s:MatchesColorscheme(idx, val) abort
        let l:lightlineScheme = a:val
        let l:lightlineScheme = substitute(l:lightlineScheme, '_.*', '', '')
        let l:result = (-1 != match(g:colors_name, l:lightlineScheme))
        return l:result
      endfunc
      let l:colorschemes = s:getLightlineColorschemes()
      call filter(l:colorschemes, function('s:MatchesColorscheme'))
      if (len(l:colorschemes) > 0)
        " echom l:colorschemes[0] . ' matches ' . g:colors_name . '. ' . string(len(l:colorschemes))
        let g:lightline.colorscheme = l:colorschemes[0]
      else
        " echom 'no lightline colorscheme for ' . g:colors_name
        if (exists('g:lightline.colorscheme'))
          unlet g:lightline.colorscheme
        endif
      endif
      if (exists('g:loaded_lightline') && exists('#lightline'))
        "                                 ^ lightline is not disabled (e.g. by Goyo)
        call lightline#init()
        call lightline#colorscheme()
        call lightline#update()
      endif
    endfun
    fun! s:getLightlineColorschemes()
      return map(globpath(&runtimepath,'autoload/lightline/colorscheme/*.vim',1,1), "fnamemodify(v:val,':t:r')")
    endfun
    command! -nargs=1 -complete=custom,s:lightlineColorschemeCompletion LightlineColorscheme call s:setLightlineColorscheme(<q-args>)
    function! s:lightlineColorschemeCompletion(...) abort
      return join(s:getLightlineColorschemes(), "\n")
    endfunction
    function! s:setLightlineColorscheme(name) abort
      let g:lightline.colorscheme = a:name
      call lightline#init()
      call lightline#colorscheme()
      call lightline#update()
    endfunction
  " }}}

  Plug 'jonsmithers/apprentice-lightline-experimental'
  " A custom theme I made to go with the apprentice theme

  PlugDevelop 'jonsmithers/pivotal-tracker-fzf.vim', { 'for': 'gitcommit' }

  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
  " Incredible fuzzy search for all sorts of things.
  " {{{
    " customize fzf colors to match color scheme
    let g:fzf_colors =
    \ { 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }

    function! RipgrepFzf(query, fullscreen, preview)
      " let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s | awk --field-separator=: ''{ x=$1; sub("/.*/", "/.../", x); print (x":"$2":"$3":"$4); }'' || true'
      let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
      let initial_command = printf(command_fmt, shellescape(a:query))
      let reload_command = printf(command_fmt, '{q}')
      let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
      let spec = a:preview ? fzf#vim#with_preview(spec) : spec
      call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
    endfunction

    command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0, 1)
    command! -nargs=* -bang RGNoPreview call RipgrepFzf(<q-args>, <bang>0, 0)
    :nnoremap <leader>F     :RG<Enter>
    :nnoremap <C-F>         :RG<Enter>

    "search for word in working directory
    :nnoremap <Leader>sw    :Rg  <Enter>
    :vnoremap <Leader>s     y:Rg "<Enter>

    :nnoremap <silent> <C-k>         :Buffers<Enter>
    :nnoremap <silent> <C-p>         :Files<Enter>
    :nnoremap <silent> <Leader>or    :History<Enter>
    :nnoremap <silent> <Leader>ft    :Filetypes<enter>
    :nnoremap <silent> <Leader>f/    :History/<Enter>
    :nnoremap <silent> <Leader>f:    :History:<Enter>
    " (note - you can call histdel("cmd", "regexp") to delete mistaken history items)

    " fuzzy relative filepath completion!
    inoremap <expr> <c-x><c-f> fzf#vim#complete#path(
          \ "find . -path '*/\.*' -prune -o -print \| sed '1d;s:^..::'",
          \ fzf#wrap({'dir': expand('%:p:h')}))
    inoremap <c-x>F <c-x><c-f>
          " Ctrl-X Shift-F will provide native c-x c-f functionality
    if (has('patch-8.2.205')) " terminal popups!
      let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
    endif
  " }}}

  Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
  " Distraction free mode. Good for coding and as well as prose writing.
  " {{{
    let g:goyo_width = 81
    " make vim close the First time you do :quit
    " https://github.com/junegunn/goyo.vim/wiki/Customization
    function! s:goyo_enter()
      let b:quitting = 0
      let b:quitting_bang = 0
      augroup goyo_buffer
        au!
        autocmd QuitPre <buffer> let b:quitting = 1
      augroup END
      cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
    endfunction
    function! s:goyo_leave()
      " Quit Vim if this is the only remaining buffer
      if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
        if b:quitting_bang
          qa!
        else
          qa
        endif
      endif
    endfunction
    augroup goyo_stuff
      au!
      autocmd User GoyoEnter call <SID>goyo_enter()
      autocmd User GoyoLeave call <SID>goyo_leave()
    augroup END
  " }}}

  Plug 'junegunn/limelight.vim'
  " :Limelight for distraction-free fanciness

  Plug 'junegunn/rainbow_parentheses.vim'
  " :RainbowParentheses to color matching parens/brackets
  " {{{
    let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]
  " }}}

  Plug 'junegunn/gv.vim', { 'on': 'GV' }
  " :GV to open git view (commit browser)

  Plug 'junegunn/vader.vim', { 'on': 'Vader', 'for': 'vader' }
  " Testing framework for vim plugins

  Plug 'junegunn/vim-easy-align'
  " Vertically align code
  " {{{
    :xmap     ga <Plug>(EasyAlign)
    :nnoremap ga <Plug>(EasyAlign)
  " }}}

  Plug 'justinmk/vim-dirvish'
  " Directory viewer
  " {{{
    " sort folders at top
    let g:dirvish_mode = ':sort ,^.*[\/],'
    augroup dirvish_stuff
      au!
      autocmd FileType dirvish setlocal nonumber
      autocmd FileType dirvish silent! unmap <buffer> <C-p>
    augroup END
  " }}}

  Plug 'markonm/traces.vim'
  " Show a live preview of :substitute

  Plug 'mg979/vim-visual-multi'
  " Multiple cursors. Seems to be faster than 'terryma/vim-multiple-cursors'.
  " {{{
    " Ctrl-N on a word to multiply your cursor on subsequent matches for batch
    " editing. (Ctrl-S) to skip
    "
    " Ctrl-Up/Down to expand multiline cursor.
    "
    " \A to select all matches of word
    let g:VM_mouse_mappings = 1
    let g:VM_no_meta_mappings = 1
  " }}}

  Plug 'mhinz/vim-signify'
  " Git info in gutter
  " {{{
    " [c,]c jump to prev/next change
    " [C,]C jump to last/first change
  " }}}

  Plug 'mzlogin/vim-markdown-toc'
  " {{{
    " :GenTocGFM
    " :GenTocGitLab
    " :UpdateToc
    let g:vmt_auto_update_on_save = 1
  " }}}

  Plug 'nelstrom/vim-visual-star-search'
  " Bring "*" key behavior into visual mode. Extremely useful. (see ":help *").

  Plug 'pangloss/vim-javascript'
  " Vastly improved syntax highlighting.
  " {{{
    let g:javascript_plugin_jsdoc = 1
  " }}}

  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  " {{{
    " Use `[g` and `]g` to navigate diagnostics
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)
    nmap <leader>la  <Plug>(coc-codeaction)
    nmap <leader>lqf  <Plug>(coc-fix-current)
    nmap <leader>lr <Plug>(coc-rename)

    nnoremap <silent> <leader>fs  :<C-u>CocList -I symbols<cr>
    nnoremap <silent> <leader><f12> :<C-u>CocList outline<cr>

    nnoremap <leader>lh :call <SID>show_documentation()<CR>
    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      else
        call CocAction('doHover')
      endif
    endfunction

    " Introduce function text object
    " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
    xmap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap if <Plug>(coc-funcobj-i)
    omap af <Plug>(coc-funcobj-a)

    " https://github.com/neoclide/coc.nvim#example-vim-configuration
  " }}}

  Plug 'psliwka/vim-smoothie'

  Plug 'othree/eregex.vim'
  " Lets you use more standard regex within vim
  " {{{
    " Search with :M/[regex]
    " Substitute with <range> :S/regex/string/
    let g:eregex_default_enable = 0
    nnoremap <Leader>m/ :M/
  " }}}

  call plug#('scrooloose/nerdtree', { 'on': s:nerdtree_triggers })
  " Project tree explorer
  " {{{
    let g:NERDTreeHijackNetrw=0 " let dirvish replace netrw
    let g:NERDTreeMinimalUI=1

    :nnoremap <silent> <Leader>tt :NERDTreeToggle<enter><c-w>p
    :nnoremap <silent> <Leader>tf :NERDTreeFind<enter>
    :nnoremap <silent> <Leader>tF :NERDTreeFind<enter><c-w>p
    :nnoremap <silent> <Leader>tr :NERDTreeRefreshRoot<cr>
  " }}}

  Plug 'rbong/vim-flog'
  " GV.vim with more features
  " {{{
    " a           - toggle --all
    " <C-N>/<C-P> - next/preview next commit
    " ]r, [r      - next/prev ref
    " y<C-G>      - yank commit hash
  " }}}

  if ((has('python') || has('python3')) && !empty(glob($HOME.'/.vim/UltiSnips')))
    Plug 'SirVer/ultisnips'
    " Code snippets
    " {{{
      let g:UltiSnipsSnippetDirectories = [$HOME.'/.vim/UltiSnips', $HOME.'/.config/smithers/UltiSnips']
      " ^ workaround bug https://github.com/SirVer/ultisnips/issues/711
      let g:UltiSnipsExpandTrigger = '<tab>'
      let g:UltiSnipsJumpForwardTrigger = '<tab>'
      let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

      augroup ultisnip
        au!
        autocmd Filetype typescript :UltiSnipsAddFiletypes javascript
      augroup END
    " }}}
  endif

  Plug 'tomtom/tcomment_vim'
  " Toggle code comments. Mapped to Ctrl-//
  " {{{
    " NOTE: ctrl-// doesn't work in gvim. Instead use ctrl-__
    let g:tcomment#replacements_xml = {} " don't substitute weird characters when commenting html lines
  " }}}

  Plug 'tpope/vim-eunuch'
  ":Delete, :Chmod, :SudoWrite, :Rename, :Mkdir

  Plug 'tpope/vim-endwise'
  " Automatically insert endif/endfunction/end/fi/esac

  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'
  Plug 'shumphrey/fugitive-gitlab.vim'
  " Various integrated git tools. I use this a lot.
  " {{{
    nnoremap <Leader>gb :Gblame -w<cr>
    " ~        reblame at hovered commit
    " A        resize to author column
    " D        resize to date column
    " p        preview commit
    " o        open commit in split
    " O        open commit in tab
    nnoremap <leader>gs :vert Gstatus<cr>
    " http://vimcasts.org/episodes/fugitive-vim-working-with-the-git-index/
    " c-n, c-p jumps to files
    " p        runs add --patch
    " cc       runs commit
    " -        stages/unstages
    " D        diff
    nnoremap <leader>gd :Gvdiff<cr>
    "          (left is index (staged), right is working)
    "          dp      diffput
    "          do      diffget (think "obtain")
    "          :w      write to index/working copy
    "          [c,]c   jump to prev/next change
    "          c-w c-o nice way to exit
    "          c-w c-w goes between columns
  " }}}

  Plug 'tpope/vim-rsi'
  " Add readline keybindings http://readline.kablamo.org/emacs.html

  Plug 'tpope/vim-unimpaired'
  " Add lots of very useful pair-related keybindings. See :help unimpaired

  Plug 'tpope/vim-repeat'
  " Improve the versatility of the "." repeat command

  Plug 'tpope/vim-surround'
  " {{{
    " mappings to quickly modify surrounding chars like ",],),},',<tag>
    " NORMAL MODE:
    "   ds<SURROUND> to delete surround
    "   cs<SURROUND><SURROUND> to change surround from/to
    "   ys<TEXT-OBJECT><SURROUND> to surround text object
    "   yS<TEXT-OBJECT><SURROUND> to surround text object on new line
    " VISUAL MODE:
    "   S<SURROUND>
    " INSERT MODE:
    "   <C-g>s<SURROUND>
  " }}}

  if (!empty(glob('~/Dropbox/vimwiki')))
    Plug 'vimwiki/vimwiki'
    " Quick access to a personal wiki. In vim.
    " {{{
      " <space>ww to open wiki index
      " <space>wf to fuzzy find wiki filenames (with preview!)
      " <space>wF to fuzzy find wiki line contents (could use improvement)
      " WriteWikiNote to write a new wiki note
      let g:vimwiki_list = [
      \   {
      \     'path': glob('~/Dropbox/vimwiki/md'),
      \     'syntax': 'markdown',
      \     'ext': '.md',
      \   },
      \   {
      \     'path': glob('~/Dropbox/vimwiki')
      \   },
      \ ] " 'syntax': 'markdown', 'ext': '.md'}]

      " source vimwiki on ALL markdown files (this is default)
      let g:vimwiki_global_ext = 0

      augroup vimrc_vimwiki
        autocmd!

        autocmd BufEnter $HOME/Dropbox/vimwiki/md/*.md command! -buffer ArchiveNote :Move %:h/archive/%:t
        autocmd BufEnter $HOME/Dropbox/vimwiki/md/archive/*.md delcommand ArchiveNote

        " disable binding that conflicts with dirvish
        autocmd Filetype markdown nmap <silent><buffer> <leader>zxcv <Plug>VimwikiRemoveHeaderLevel

      augroup end

      nnoremap <leader>wf :FilesWithPreview ~/Dropbox/vimwiki/md<cr>
      nnoremap <leader>wF :call VimWikiLines()<cr>
      " nnoremap <leader>wF :call fzf#vim#grep('rg --column --line-number --no-heading --color=always . $HOME/Dropbox/vimwiki/md \| tr -d "\017"', 1, 0)<cr>

      command! -bang -nargs=? -complete=dir FilesWithPreview
            \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

      command! -nargs=+ WriteWikiNote call s:writeWikiNote(<q-args>)
      func! s:writeWikiNote(filename)
        let l:writePath = '$HOME/Dropbox/vimwiki/md/' . a:filename . '.md'
        exec ':save ' . expand(l:writePath)
      endfunc
      func! VimWikiLines()
        " load all vimwiki notes
        for l:filename in split(expand('$HOME/Dropbox/vimwiki/md/*'), '\n')
          exec 'badd '.l:filename
        endfor
        Lines
      endfunc
    " }}}
    endif

  call plug#('Xuyuanp/nerdtree-git-plugin', { 'on': s:nerdtree_triggers })
  " Show git indicators in nerdtree
  " {{{
    let g:NERDTreeIndicatorMapCustom = {
        \ "Modified"  : '*',
        \ "Staged"    : '+',
        \ "Untracked" : '✭',
        \ "Renamed"   : '➜',
        \ "Unmerged"  : '═',
        \ "Deleted"   : '✖',
        \ "Dirty"     : '*',
        \ "Clean"     : '✔︎',
        \ 'Ignored'   : '☒',
        \ "Unknown"   : '?'
        \ }
    " }}}


  Plug 'w0rp/ale'
  " Awesome asynchronous linting of all kinds
  " {{{
    let g:ale_linters = {
      \ 'html': ['eslint'],
      \ 'javascript': [],
      \ 'javascriptreact': [],
      \ 'java': [],
      \ 'typescript': [],
      \ 'typescriptreact': [],
      \ 'rust': ['rustc', 'cargo']
    \}
    let g:ale_linter_aliases = { 'html': ['html', 'javascript'] }
    let g:ale_echo_msg_format = '%linter%: %s (%code%)'
    let g:ale_fixers = {
          \ 'javascript': ['eslint'],
          \ 'javascriptreact': ['eslint'],
          \ 'typescript': ['eslint'],
          \ 'typescriptreact': ['eslint'],
          \ 'html': ['eslint'],
          \}
    let g:ale_completion_enabled = 0

    :nnoremap <Leader>an :ALENextWrap<Enter>
    :nnoremap <Leader>ah :ALEHover<Enter>
    :nnoremap <Leader>af :ALEFix<Enter>
  " }}}

  " Plug 'wellle/targets.vim'
  " Advanced vim text objects. Sometimes this is slow.

  Plug 'whiteinge/diffconflicts'
  " {{{
    " git config --global merge.tool diffconflicts
    " git config --global mergetool.diffconflicts.cmd 'vim -c DiffConflicts "$MERGED" "$BASE" "$LOCAL" "$REMOTE"'
    " git config --global mergetool.diffconflicts.trustExitCode true
    " git config --global mergetool.keepBackup false
    " git mergetool <file>
  " }}}

  Plug 'Yggdroot/indentLine'
  " {{{
    " more obvious visual depiction of indentation
    " let g:indentLine_char_list = ['|', '¦', '┆', '┊']
    let g:indentLine_enabled = 0
    nnoremap [o<tab> :IndentLinesEnable<cr>
    nnoremap ]o<tab> :IndentLinesDisable<cr>
    nnoremap yo<tab> :IndentLinesToggle<cr>
    let g:indentLine_char = '┊'
    augroup vimrc_indentline
      au!
      autocmd ColorScheme * call s:matchIndentLine()
    augroup END
    fun! s:matchIndentLine()
      let g:indentLine_color_gui = synIDattr(synIDtrans(hlID('Comment')), "fg#")
    endfun
  " }}}

  " language plugins {{{
  if !has('patch-8.1.1486')
    Plug 'leafgarland/typescript-vim'
    Plug 'peitalin/vim-jsx-typescript'
  endif
  Plug 'dag/vim-fish'
  Plug 'luan/vim-concourse'
  Plug 'posva/vim-vue'
  Plug 'tfnico/vim-gradle'
  Plug 'vim-scripts/groovyindent-unix'
  let g:concourse_tags_autosave = 0
  Plug 'MaxMEllon/vim-jsx-pretty'
  let g:vim_jsx_pretty_colorful_config = 1
  PlugDevelop 'jonsmithers/vim-html-template-literals'
  let g:html_indent_style1  = 'inc'
  let g:html_indent_script1 = 'inc'
  Plug 'rust-lang/rust.vim'
  Plug 'tpope/vim-markdown'
  let g:markdown_fenced_languages = ['rust', 'typescript', 'typescriptreact', 'javascript', 'bash']
  Plug 'fatih/vim-go'
  " }}}

  " colorscheme plugins {{{
  if &term == 'alacritty'
    let &term='xterm-256color'
  endif
  if (has('termguicolors'))
    set termguicolors
  else
    set t_Co=256
  endif
  Plug 'arcticicestudio/nord-vim'
  Plug 'ayu-theme/ayu-vim'
  Plug 'chriskempson/base16-vim'
  Plug 'cormacrelf/vim-colors-github'
  Plug 'dracula/vim'
  Plug 'junegunn/seoul256.vim'
  Plug 'kjssad/quantum.vim'
  Plug 'KKPMW/sacredforest-vim'
  Plug 'mhartington/oceanic-next'
  Plug 'morhetz/gruvbox'
  Plug 'nanotech/jellybeans.vim'
  Plug 'nightsense/snow'
  Plug 'NLKNguyen/papercolor-theme'
  Plug 'rakr/vim-one'
  Plug 'romainl/Apprentice'
  " }}}

call plug#end()

" ┌──────────────┐
" │ Key Mappings │
" └──────────────┘
" {{{
  nnoremap <leader>; :
  vnoremap <leader>; :

  " search and replace (works well with Traces.vim)
  vnoremap <c-r>A y:call <SID>ReplaceAppend()<cr>
  vnoremap <c-r>c y:call <SID>ReplaceChange()<cr>
  vnoremap <c-r>I y:call <SID>ReplaceInsert()<cr>
  fun! <SID>ReplaceAppend()
    let l:selection = escape(@0, '/\')
    call feedkeys(":%substitute/\\V\\C" . l:selection . '/' . l:selection . "/gc\<left>\<left>\<left>")
    return ''
  endfun
  fun! <SID>ReplaceChange()
    let l:selection = escape(@0, '/\')
    call feedkeys(":%substitute/\\V\\C" . l:selection . '/' . "/gc\<left>\<left>\<left>")
    return ''
  endfun
  fun! <SID>ReplaceInsert()
    let l:selection = escape(@0, '/\')
    call feedkeys(":%substitute/\\V\\C" . l:selection . '/' . l:selection . "/gc\<left>\<left>\<left>" . repeat("\<left>", len(l:selection)))
    return ''
  endfun

  inoremap jk <Esc>
  inoremap jl <Esc>:

  " https://castel.dev/post/lecture-notes-1/
  inoremap <c-l> <c-g>u<Esc>[s1z=`]a<c-g>u

  " reformat current paragraph without leaving insert mode
  inoremap <c-k> <c-o>gwip

  nnoremap <silent> <leader>sdf :let @/ = ''<cr>

  " horizontal scroll
  nnoremap <C-l> 5zl
  nnoremap <C-h> 5zh

  " disable confusing and near-obsolete ex mode
  nnoremap Q <nop>

  nnoremap <silent> <leader>x :call CloseBufferWithNerdTree(v:false)<cr>
  nnoremap <silent> <leader>X :call CloseBufferWithNerdTree(v:true)<cr>
  fun! CloseBufferWithNerdTree(force)
    let l:nerdtreeopen = exists("g:NERDTree") && g:NERDTree.IsOpen()
    if (l:nerdtreeopen)
      :NERDTreeClose
    endif
    if (a:force)
      bd!
    else
      bd
    end
    if (l:nerdtreeopen)
      :NERDTreeToggle
      :wincmd p
    endif
  endfun

  " quick save
  nnoremap <silent> <Leader><Leader> :w<Enter>

  " switch with most recent buffer
  nnoremap <Leader><Tab> :b#<enter>

  " refresh syntax if it gets out of whack (sometimes useful for large files of deeply-nested syntaxes (e.g. <script> tags)))
  nnoremap <Leader>ss :syntax sync fromstart<enter>

  nnoremap <F10> :echo map(synstack(line("."), col(".")), "synIDattr(v:val, 'name')")<cr>

  nnoremap <F6> :let $VIM_DIR=expand('%:p:h')<CR>:call <SID>ToggleTerminal(1)<CR>cd $VIM_DIR<CR>clear<CR>

  nnoremap <F4> :call <SID>ToggleTerminal(0)<CR>

  fun! <SID>ToggleTerminal(reset)
    " https://www.reddit.com/r/neovim/comments/3cu8fl/quick_visor_style_terminal_buffer/
    if (a:reset || !exists('s:termbuf'))
      let s:termbuf = 0
    endif

    " let l:OPEN_TERMINAL_WINDOW = 'botright 20 split'
    let l:OPEN_TERMINAL_WINDOW = '20 split'
    if (s:termbuf && bufexists(s:termbuf))
      let l:winnr = bufwinnr(s:termbuf)
      if (l:winnr == -1)
        exec l:OPEN_TERMINAL_WINDOW
        exe 'buffer' . s:termbuf
      else
        exe l:winnr . 'wincmd w'
      endif
    else
      exec l:OPEN_TERMINAL_WINDOW
      echom s:termbuf . ' does not exist'
      if has('nvim')
        terminal
        startinsert
      else
        terminal ++curwin
      endif
      let s:termbuf=bufnr('%')
      "tnoremap <buffer> <F4> <C-\><C-n>:close<cr>
      tmap <buffer> <F4> <C-w><C-q>
      nnoremap <buffer> <F4> i<C-w><C-q>
      vnoremap <buffer> <F4> <esc>i<C-w><C-q>
    endif
  endfun

  " window navigation {{{
    " If split in given direction exists - jump, else create new split
    " (code taken from https://github.com/zenbro/dotfiles/blob/master/.nvimrc#L151-L187)
    nnoremap <silent> <Leader>hh       :call JumpOrOpenNewSplit('h', ':leftabove  vsplit', 0)<CR>
    nnoremap <silent> <Leader>ll       :call JumpOrOpenNewSplit('l', ':rightbelow vsplit', 0)<CR>
    nnoremap <silent> <Leader>kk       :call JumpOrOpenNewSplit('k', ':leftabove  split',  0)<CR>
    nnoremap <silent> <Leader>jj       :call JumpOrOpenNewSplit('j', ':rightbelow split',  0)<CR>
    nnoremap <silent> <Leader>h<Space> :call JumpOrOpenNewSplit('h', ':leftabove  vsplit', 1)<CR>
    nnoremap <silent> <Leader>l<Space> :call JumpOrOpenNewSplit('l', ':rightbelow vsplit', 1)<CR>
    nnoremap <silent> <Leader>k<Space> :call JumpOrOpenNewSplit('k', ':leftabove  split',  1)<CR>
    nnoremap <silent> <Leader>j<Space> :call JumpOrOpenNewSplit('j', ':rightbelow split',  1)<CR>
    fun! JumpOrOpenNewSplit(key, cmd, fzf)
      let l:current_window = winnr()
      execute 'wincmd' a:key
      if l:current_window == winnr()
        execute a:cmd
        if a:fzf
          Files
        else
          Dirvish %:p:h
        endif
      else
        if a:fzf
          Files
        endif
      endif
    endfunction
  " }}}

  " https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
  nnoremap <expr> n  'Nn'[v:searchforward]
  nnoremap <expr> N  'nN'[v:searchforward]
  " https://github.com/mhinz/vim-galore#saner-command-line-history
  cnoremap <c-n>  <down>
  cnoremap <c-p>  <up>
  " Saner CTRL L: https://github.com/mhinz/vim-galore#saner-ctrl-l
  nnoremap <leader>l :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>
  " Quickly Move Current Line: https://github.com/mhinz/vim-galore#matchit
  nnoremap [e  :<c-u>execute 'move -1-'. v:count1<cr>
  nnoremap ]e  :<c-u>execute 'move +'. v:count1<cr>
  " Quickly Add Empty Lines: https://github.com/mhinz/vim-galore#quickly-add-empty-lines
  nnoremap [<space>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
  nnoremap ]<space>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>
  " Quickly Edit Your Macros:  https://github.com/mhinz/vim-galore#quickly-edit-your-macros
  nnoremap <leader>m  :<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>
" }}} keybindings

"be lenient with html comment syntax. This is a must-have for documented Polymer code.
let g:html_wrong_comments=1

" {{{ COMMANDS
  command! FormatJSON :%!python -m json.tool
  command! FormatXML :%!python -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"

  if (exists('$VIM_TERMINAL'))
    command Unwrap let g:file = expand('%') | bdelete | exec 'silent !echo -e "\033]51;[\"drop\", \"'.g:file.'\"]\007"' | q
  endif

  command! BufferDeleteHidden call BufferDeleteHidden()
  function! BufferDeleteHidden()
    let l:tpbl=[]
    call map(range(1, tabpagenr('$')), 'extend(l:tpbl, tabpagebuflist(v:val))')
    for l:buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(l:tpbl, v:val)==-1')
      silent execute 'bwipeout' l:buf
    endfor
  endfunction

  command! JV exec "edit ~/.vim/plugged"
  command! OpenInVSCode    exe "silent !code --goto '" . expand("%") . ":" . line(".") . ":" . col(".") . "'"                    | redraw!
  command! OpenCwdInVSCode exe "silent !code '" . getcwd() . "' --goto '" . expand("%") . ":" . line(".") . ":" . col(".") . "'" | redraw!
  command! OpenInIdea      exe "silent !idea '" . getcwd() . "' '" . expand("%") . ":" . line(".") . "'"                         | redraw!
  command! Quit2Idea       exe "silent !idea '" . getcwd() . "' '" . expand("%") . ":" . line(".") . "'"                         | redraw! | quit

  " open url on current line
  func! OpenUrl()
    exec 'silent !python -mwebbrowser '.(shellescape(matchstr (getline('.'), 'https\?://[a-zA-Z0-9\./\-?=\&+@,!:_#%*;:~]\+[^,.) \"]'), '#')).' 2> /dev/null > /dev/null' | redraw!
  endfu
  com! TestUrl exec 'echom            '.(shellescape(matchstr (getline('.'), 'https\?://[a-zA-Z0-9\./\-?=\&+@,!:_#%*;:~]\+[^,.) \"]'), '#'))
  nnoremap <Leader>ou :call OpenUrl()<Enter>

  func! HighlightTrailingSpace()
    highlight TrailingSpace ctermbg=red ctermfg=white guibg=#592929
    match TrailingSpace /\s\+\n/
  endfu
  command! TrailingSpaceHighlight call HighlightTrailingSpace()
  command! TrailingSpaceDeleteAll :%s/\s\+\n/\r/gc

  func! HighlightOverlength()
    highlight OverLength ctermbg=red ctermfg=white guibg=#592929
    match OverLength /\%81v.\+/
  endfu
" }}}

" Change Cursor Style Dependent On Mode: https://github.com/mhinz/vim-galore#change-cursor-style-dependent-on-mode {{{
  if (s:os ==? 'Linux')
    " https://stackoverflow.com/a/42118416/1480704
    let &t_SI = "\e[6 q"
    let &t_EI = "\e[2 q"
    let &t_SR = "\e[3 q"
  elseif (s:os ==? 'MacOS')
    if empty($TMUX)
      let &t_SI = "\<Esc>]50;CursorShape=1\x7"
      let &t_EI = "\<Esc>]50;CursorShape=0\x7"
      let &t_SR = "\<Esc>]50;CursorShape=2\x7"
    else
      let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
      let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
      let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
    endif
  endif
" }}}

" Prose
  set nojoinspaces  " prevent vim from inserting 2 spaces after periods.
  com! ProseMode    call js_prose#ProseMode()
  com! SoftWrapMode call js_prose#SoftWrappedProcessorMode()
  nnoremap [oP :ProseMode<cr>
  nnoremap ]oP :CodeMode<cr>
  nnoremap yoP :call js_prose#ToggleProseMode()<cr>

" GUI Settings {{{
  if has('gui_running')
    set background=dark
    set autoread        "auto-load changes from disk
    if (s:os ==? 'MacOS')
      set guifont=Monaco:h16
    elseif (s:os ==? 'Windows')
      set guifont=Courier_New:h12
    endif

    :set guioptions-=m  "remove menu bar
    :set guioptions-=T  "remove toolbar
    :set guioptions-=r  "remove right-hand scroll bar
    :set guioptions-=L  "remove left-hand scroll bar
  endif
" }}}

" Basics
  if filereadable($VIMRUNTIME . '/defaults.vim')
    if !exists(':DiffOrig') " avoid unnecessary re-sourcing. For some reason it takes about 600ms
      source $VIMRUNTIME/defaults.vim " new in vim 8
    endif
    packadd! matchit " bundled default plugin
  else
    set wildmenu      "show suggestions for vim commands
    set incsearch     "incremental search (something else also turns this on)
    syntax enable
    set backspace=indent,eol,start
    set history=200		" keep 200 lines of command line history
  endif
  set mouse=a       "already set in Vim 8 defaults.vim, but Fedora undoes it! (https://lists.fedoraproject.org/archives/list/users@lists.fedoraproject.org/thread/HZJVN3LVFS2YC3H7EZRPJEYEPAGKEVH2/)
  set ttimeoutlen=0 "timeout instantly when pressing esc during visual mode
  set foldmethod=syntax
  set foldlevelstart=99
  set nowrap
  set ignorecase    "search ignores case
  set smartcase     "unless there's a capital letter
  set number
  set autoindent
  set smartindent
  set hlsearch      " default in NeoVim
  set wildignore=**/node_modules/**

  set splitbelow    " more natural split behavior
  set splitright    " more natural split behavior

  set hidden        " leave buffers without saving

  set completeopt=menuone,longest,preview " make completion menu awesome

  set directory=/var/tmp//,/tmp//,.

  " local file history {{{
  if (s:os !=# 'Windows')

    set backupdir=~/.config/smithers/vimbackup/,~/.config/vimbackup//,/var/tmp//
    set backup
    " 'backupskip=/tmp/*' is set by default

    command! Backups     call <sid>DiffWithBackup()
    nnoremap <leader>bd :call <sid>DiffWithBackup()<cr>

    augroup vimrc_backup
      autocmd!
      au BufWritePre * let &backupext = '-' . strftime("%Y%m%d-%H%M%S") . '.vimbackup'
    augroup END

    fun! <sid>DiffWithBackup()
      let l:fzfSelectables = []
      for l:backupDir in split(&backupdir, ',')
        let l:basePath = l:backupDir
        if (l:backupDir[-2:] == '//')
          let l:basePath = l:basePath[:-2]
          let l:basePath .= substitute(expand('%:p'), '/', '%', 'g')
        else
          if (l:backupDir[-1:] != '/')
            let l:basePath .= '/'
          endif
          let l:basePath .= expand('%:t')
        endif
        let l:newBackupFiles = sort(split(glob(l:basePath . '-*.vimbackup'), '\n'))

        fun! s:toUserReadableFormat(filepath, basePath)
          let l:result = a:filepath
          let l:result = substitute(l:result, '\V' . a:basePath, '', '')
          let l:result = substitute(l:result, '^-', '', '')
          let l:result = substitute(l:result, '.vimbackup', '', '')
          let l:year   = l:result[0:3]
          let l:month  = l:result[4:5]
          let l:day    = l:result[6:7]
          let l:hour   = l:result[09:10]
          let l:minute = l:result[11:12]
          let l:second = l:result[13:14]
          let l:result = l:year . '-' . l:month . '-' . l:day . ' ' . l:hour . ':' . l:minute . ':' . l:second
          return l:result
        endfun
        let l:fzfSelectables += map(copy(l:newBackupFiles), {-> v:val . '<<fake-delimiter>>' . s:toUserReadableFormat(v:val, l:basePath)})
      endfor
      call reverse(l:fzfSelectables)
      fun! s:backupDiffSink(selectedBackupFile)
        let l:selectedBackupFile = escape(split(a:selectedBackupFile, '<<fake-delimiter>>')[0], '%')
        diffoff!
        exec 'vertical diffsplit ' . l:selectedBackupFile
        setlocal readonly nobuflisted bufhidden=wipe buftype=nowrite noswapfile
        autocmd QuitPre <buffer> diffoff!
        autocmd BufHidden <buffer> diffoff!
        wincmd p
      endfun
      call fzf#run(fzf#wrap({
            \ 'sink': funcref('s:backupDiffSink'),
            \ 'source': l:fzfSelectables,
            \ 'options': [
            \   '--prompt', 'backup file> ',
            \   '--preview', 'git diff --color=always {1} ' . s:currentFileInSingleQuotes() . s:omitDiffHeaders,
            \   '--with-nth=2',
            \   '--delimiter=<<fake-delimiter>>'
            \ ]
            \ }))
    endfun
  endif
  " }}}

  let s:omitDiffHeaders = ' | grep -v "^\[1m\(diff\|index\|+++\|---\) "'
  fun! s:currentFileInSingleQuotes()
    return "'"..escape(expand('%'), "'").."'"
  endfun

  " git file history {{{
    command! Versions call <sid>DiffWithGitVersion()
    nnoremap <leader>vd :call <sid>DiffWithGitVersion()<cr>
    fun! <sid>DiffWithGitVersion()
      " TODO handle file moves
      call fzf#run(fzf#wrap({
            \ 'source': 'git log --follow --oneline ' . s:currentFileInSingleQuotes(),
            \ 'sink': funcref('s:gitFileVersionSink'),
            \ 'options': [
            \   '--prompt', 'git version> ',
            \   '--preview', 'git show --color=always {1} --format="%n%Cblue%b%CresetAuthor: %an" ' . s:currentFileInSingleQuotes() . s:omitDiffHeaders . ' | grep -v "^\[36m@@"'
            \ ] }))
    endfun
    fun! s:gitFileVersionSink(selectedVersion)
      diffoff!
      let l:version = split(a:selectedVersion, ' ')[0]
      let l:currentFile = expand('%')
      let l:currentFileType = &filetype
      vertical new
      exec 'read ! git show ' . l:version . ':' . l:currentFile
      let &filetype=l:currentFileType
      setlocal readonly nomodified nobuflisted bufhidden=delete buftype=nofile noswapfile
      autocmd QuitPre <buffer> diffoff!
      autocmd BufHidden <buffer> diffoff!
      diffthis
      wincmd p
      diffthis
    endfun
  " }}}

  set sessionoptions-=options " for some reason, vim won't restore with syntax highlighting without this. https://stackoverflow.com/questions/9281438/syntax-highlighting-doesnt-work-after-restore-a-previous-vim-session

  " disable audible and visual bells set noerrorbells https://github.com/mhinz/vim-galore#disable-audible-and-visual-bells
  "set noerrorbells "this does not work
  "set novisualbell
  "set t_vb=
  set belloff=all

  " diffing
  if has('patch-8.1.0360')
    set diffopt+=algorithm:patience
    set diffopt+=indent-heuristic
  endif

  :cabbrev h vert h
                    " execute [:h QUERY] to open help page in vertical split buffer

  if !&scrolloff
    set scrolloff=3 " Show next 3 lines while scrolling.
  endif
  if !&sidescrolloff
    set sidescrolloff=5 " Show next 5 columns while side-scrolling.
  endif
  "(source: http://nerditya.com/code/guide-to-neovim/)

" Tabs
  set expandtab     " SPACES over TABS
  set smarttab      " delete multiple spaces at once (as if deleting a tab character)
  com! -nargs=1 Tab      set      tabstop=<args> | set      shiftwidth=<args> "| set softtabstop=<args>
  com! -nargs=1 LocalTab setlocal tabstop=<args> | setlocal shiftwidth=<args> "| set softtabstop=<args>
  :Tab 2
  " ^ to be overwritten by editorconfig whenever possible

" Colorscheme things
" {{{
  com! Default          set background=dark  | colorscheme default
  com! DarkAyu          set background=dark  | let ayucolor="dark" | colorscheme ayu
  com! DarkGruv         set background=dark  | colorscheme gruvbox
  com! DarkOcean        set background=dark  | colorscheme OceanicNext
  com! DarkPaper        set background=dark  | colorscheme PaperColor
  com! DarkOne          set background=dark  | colorscheme one
  com! DarkSeoul        set background=dark  | colorscheme seoul256
  com! DarkSacredForest set background=dark  | colorscheme sacredforest
  com! DarkApprentice   set background=dark  | colorscheme apprentice
  com! DarkSnow         set background=dark  | colorscheme snow
  com! DarkNord         set background=dark  | colorscheme nord
  com! DarkQuantum      set background=dark  | colorscheme quantum
  com! LightAyu         set background=light | let ayucolor="light" | colorscheme ayu
  com! LightOne         set background=light | colorscheme one
  com! LightGruv        set background=light | colorscheme gruvbox
  com! LightOcean       set background=light | colorscheme OceanicNextLight
  com! LightPaper       set background=light | colorscheme PaperColor
  com! LightSeoul       set background=light | colorscheme seoul256
  com! LightSnow        set background=light | colorscheme snow
  com! LightGitHub      set background=light | colorscheme github
  com! LightQuantum     set background=light | colorscheme quantum
  com! MirageAyu        set background=dark  | let ayucolor="mirage" | colorscheme ayu

  augroup vimrc_colorscheme
    au!
    " work around issue with iTerm rendering undercurl/underline badly
    autocmd ColorScheme * highlight SpellBad cterm=NONE
    " expose colorscheme colors to fish shell
    autocmd ColorScheme * call s:matchShellColors()
    fun! s:matchShellColors()
      if (&shell =~# 'fish')
        let l:fishColorMap = {
              \ 'fish_color_command': 'Normal',
              \ 'fish_color_error': 'ErrorMsg',
              \ 'fish_color_operator': 'PreProc',
              \ 'fish_color_selection': 'CursorLine' ,
              \ }
        for [l:fishVar, l:source] in items(l:fishColorMap)
          let l:normalBg = synIDattr(synIDtrans(hlID('Normal')), "bg#")
          let l:thisBg = synIDattr(synIDtrans(hlID(l:source)), "bg#")
          let l:color = ''
          if (empty(l:thisBg) || l:thisBg == l:normalBg)
            let l:color = synIDattr(synIDtrans(hlID(l:source)), 'fg#')
          else
            let l:color = l:thisBg
          endif
          let l:color = l:color[1:]
          " echom l:fishVar . ' --> ' . l:color . ' (' . l:source . ')'
          exec 'let $' . l:fishVar . '="' . l:color . '"'
        endfor
        " autocmd ColorScheme * let $fish_color_command='black'
      else
        let $vim_background=&background
        let $vim_colorscheme=g:colors_name
      endif
    endfun
  augroup end

  if (!has('gui_running'))
    set t_Cs=
    " vim has a bug that prevents undercurl from falling back to underline
    " when not supported https://github.com/vim/vim/issues/3471
  endif

  if (!exists('g:colors_name'))
    if (has('nvim'))
      silent! MirageAyu
    else
      silent! DarkApprentice
    endif
  endif
  if has('nvim')
    " let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    " ^ I don't know what this does
  end
" }}}

" simple session restoration http://vim.wikia.com/wiki/Go_away_and_come_back
  function! MakeSession()
    let b:sessiondir = $HOME . '/.vim/sessions' . getcwd()
    if (filewritable(b:sessiondir) != 2)
      exe 'silent !mkdir -p ' b:sessiondir
      redraw!
    endif
    let b:filename = b:sessiondir . '/session.vim'
    exe 'mksession! ' . b:filename
  endfunction

  function! LoadSession()
    let b:sessiondir = $HOME . '/.vim/sessions' . getcwd()
    let b:sessionfile = b:sessiondir . '/session.vim'
    if (filereadable(b:sessionfile))
      exe 'source ' b:sessionfile
    else
      echo 'No session loaded.'
    endif
  endfunction
  " au VimEnter * nested if argc() == 0 | :call LoadSession() | endif
  augroup session_saving
    au!
    if (s:os !=# 'Windows')
      au VimLeave * :call MakeSession()
    endif
  augroup END
  com! LoadSession call LoadSession()

" fix neovim's terminal behavior to match vim's {{{
" https://www.reddit.com/r/neovim/comments/cger8p/how_quickly_close_a_terminal_buffer/eupal7q/
  if has('nvim')
    augroup terminal_settings
      autocmd!
      autocmd TermOpen term://* set nonumber

      autocmd BufWinEnter,WinEnter term://* startinsert
      autocmd BufLeave term://* stopinsert
      " autocmd TermOpen term://* startinsert

      " Ignore various filetypes as those will close terminal automatically
      " Ignore fzf, ranger, coc
      autocmd TermClose term://*
            \ if (expand('<afile>') !~ "fzf") && (expand('<afile>') !~ "ranger") && (expand('<afile>') !~ "coc") |
            \   call nvim_input('<CR>')  |
            \ endif
    augroup END
  endif
" }}}

" Auto Commands
  augroup vimrc_autocomamnds
    autocmd!

    " custom filetype behaviors
    autocmd FileType gitcommit setlocal spell
    autocmd FileType gitcommit call s:StartInsertIfEmpty()
    autocmd FileType gitcommit set comments+=fb:-,fb:+,fb:*
    autocmd FileType gitcommit set formatoptions+=cq
    autocmd FileType gitcommit normal gg
    " ^ workaround weird issue where caret sometimes starts 2 lines down
    autocmd FileType text     setlocal spell
    autocmd Filetype markdown setlocal spell
    " correct formatting for checklists
    autocmd Filetype markdown set comments-=fb:-
    autocmd Filetype markdown set comments+=fb:-\ [\ ]
    autocmd Filetype markdown set comments+=fb:-\ [X]
    autocmd Filetype markdown set comments+=fb:-
    let g:markdown_folding = 1 " enable folding via vim's native markdown plugin
    " let g:vimsyn_folding = 'af' " is too slow

    autocmd Filetype sh set comments+=fb:#

    function! s:StartInsertIfEmpty()
      if (empty(getline(1)))
        startinsert!
      endif
    endfunction

    if (v:version >= 810)
      autocmd TerminalOpen * setlocal nonumber norelativenumber
    endif

    if has('nvim')
      :tnoremap <C-w> <C-\><C-n><C-w>
    endif

    " auto-reload vimrc whenever I save it
    autocmd BufWritePost vimrc,.vimrc, exec 'source ' . expand('<sfile>')
    " I used to additionally "call lightline#disable() | call lightline#enable()" here

    " disable syntax when editing huge files so vim stays snappy
    autocmd Filetype * if (getfsize(@%) > 500000) | setlocal syntax=OFF | endif

    autocmd Filetype javascript                 call s:ftplugin_javascript()
    autocmd Filetype javascript,html,typescript call s:ftplugin_javascripty()
    autocmd Filetype typescriptreact            call s:ftplugin_javascripty()
    autocmd Filetype python                     nnoremap <buffer> <space>py :!python %<cr>
    autocmd Filetype python                     set omnifunc=pythoncomplete#Complete
    autocmd Filetype vim                        call s:ftplugin_vim()

  augroup END

  fun! s:ftplugin_javascript()
    nnoremap <buffer> <space>js :call s:ftplugin_javascript_open_node_terminal()<cr><c-w>o
  endfun
  fun! s:ftplugin_javascripty()
    nnoremap <buffer> <Leader>il oconsole.log();F)i
    nnoremap <buffer> <Leader>iL oconsole.log('%c', 'font-size:15px');F,hi
    nnoremap <buffer> <Leader>liw yiwoconsole.log('0', 0);<Esc>
    nnoremap <buffer> <Leader>lif yiwoconsole.log('0()');<Esc>
    nnoremap <buffer> <Leader>liF yiwoconsole.log('%c0()', 'font-size:15px');<Esc>^2w
    nnoremap <buffer> <Leader>gif yiwf{oconsole.group('0');<Esc>]}Oconsole.groupEnd();<Esc>^

    " Example Usages:
    " :MakeEslint %
    " :MakeEslint src/ test/
    command! -nargs=? MakeEslint call s:MakeEslint(<q-args>)
  endfun
  fun! s:MakeEslint(targets)
    let l:targets = expand(a:targets)
    if (len(l:targets) == 0)
      let l:targets = './'
    endif
    set errorformat+=%f:\ line\ %l\\,\ col\ %c\\,\ %trror\ -\ %m
    set errorformat+=%f:\ line\ %l\\,\ col\ %c\\,\ %tarning\ -\ %m
    if (executable('yarn') && !empty(glob('yarn.lock')))
      set makeprg=yarn\ exec\ eslint\ --\ --format\ compact\ --ext\ '.js,.jsx,.ts,.tsx'
    elseif (executable('npx'))
      set makeprg=npx\ eslint\ --format\ compact\ --ext\ '.js,.jsx,.ts,.tsx'
    else
      echoerr 'Both yarn and npx are missing'
      return
    endif
    echom &makeprg . ' ' . l:targets
    exec 'make! ' . l:targets
    copen
  endfun
  fun! s:ftplugin_javascript_open_node_terminal()
    if (has('nvim'))
      " when I actually need this I'll have to read up on termopen()
      call feedkeys(':write !node
')
    else
      call term_start('node', { 'in_io': 'buffer', 'in_buf': bufnr('%'), 'vertical': 1, 'term_cols': 80, 'norestore': 1 })
    endif
  endfun

  function! s:ftplugin_vim()
    :nnoremap <buffer> <Leader>il oechom ''i
  endfunction

if !empty(glob('~/.config/smithers/.vimrc'))

  " HOW TO UNINVASIVELY USE MY VIM CONFIG ON SOMEONE ELSES COMPUTER:
  " curl --create-dirs -fLo ~/.config/smithers/.vimrc https://raw.githubusercontent.com/jonsmithers/dotfiles/master/vim/vimrc
  " vim -Nu ~/.config/smithers/.vimrc +RedownloadSmithersDotfiles
  " # ln -s ~/.config/smithers/.vimrc ~/.vimrc

  set runtimepath+=~/.config/smithers/.vim

  command! RedownloadSmithersDotfiles call RedownloadSmithersDotfilesFunc()
  function! RedownloadSmithersDotfilesFunc()

    silent !curl -fLo ~/.config/smithers/.vimrc                           https://raw.githubusercontent.com/jonsmithers/dotfiles/master/vim/vimrc                   --create-dirs
    silent !curl -fLo ~/.config/smithers/readme.txt                       https://raw.githubusercontent.com/jonsmithers/dotfiles/master/vim/dot_config_smithers.txt --create-dirs
    silent !curl -fLo ~/.config/smithers/.vim/plugin/shutter.vim          https://raw.githubusercontent.com/jonsmithers/dotfiles/master/vim/plugin/shutter.vim      --create-dirs
    silent !curl -fLo ~/.config/smithers/.vim/spell/en.utf-8.add          https://raw.githubusercontent.com/jonsmithers/dotfiles/master/vim/en.utf-8.add            --create-dirs
    silent !curl -fLo ~/.config/smithers/bin/git-tracker                  https://raw.githubusercontent.com/jonsmithers/dotfiles/master/git/git-tracker             --create-dirs
    silent !curl -fLo ~/.config/smithers/bin/git-website                  https://raw.githubusercontent.com/jonsmithers/dotfiles/master/git/git-website             --create-dirs

    silent !chmod +x  ~/.config/smithers/bin/git-tracker
    silent !chmod +x  ~/.config/smithers/bin/git-website

    silent !mkdir -p ~/.config/smithers/vimbackup

    silent !mkdir -p ~/.config/smithers/UltiSnips
    silent !curl -fLo ~/.config/smithers/UltiSnips/javascript.snippets    https://raw.githubusercontent.com/jonsmithers/dotfiles/master/vim/UltiSnips/javascript.snippets --create-dirs
    silent !curl -fLo ~/.config/smithers/UltiSnips/typescript.snippets    https://raw.githubusercontent.com/jonsmithers/dotfiles/master/vim/UltiSnips/typescript.snippets --create-dirs

    " clean up my old way of doing this
    if (!empty(glob('~/.config/smithers/.vim/autoload/dotfile_extras.vim')))
      silent !rm ~/.config/smithers/.vim/autoload/dotfile_extras.vim
    endif
    if (!empty(glob('~/.config/smithers/.vim/autoload/shutter.vim')))
      silent !rm ~/.config/smithers/.vim/autoload/shutter.vim
    endif

    redraw!
  endfunction
endif

if (s:os ==# 'Windows')
  function! DownloadWindowsVimrc(overwrite)
    set shell=C:\\WINDOWS\\system32\\WindowsPowerShell\\v1.0\\powershell.exe
    let l:destinationFile = $MYVIMRC
    if (!a:overwrite)
      let l:destinationFile .= '_LATEST'
    endif
    exec ":!(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/jonsmithers/dotfiles/master/vim/vimrc', $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath('" . l:destinationFile . "'))"
    if (!a:overwrite)
      :tabnew $MYVIMRC
      :exec ':vertical diffsplit ' . l:destinationFile
    endif
  endfunction

  command! DownloadWindowsVimrc call DownloadWindowsVimrc(<bang>0)
endif

" {{{ auto-update 'Last Updated' comment line in certain filetypes
  augroup vimrc_updatetimestamp
    au!
    autocmd BufWritePre vimrc,.vimrc                          call s:updateTimeStamp()
    autocmd BufWritePre misc.vim                              call s:updateTimeStamp()
    autocmd BufWritePre shutter.vim                           call s:updateTimeStamp()
    autocmd BufWritePre en.utf-8.add,ptracker,git-website     call s:updateTimeStamp()
    autocmd BufWritePre dotphile                              call s:updateTimeStamp()
  augroup END
  function! s:updateTimeStamp()
    " ignore for fugitive files
    if (match(expand('%'), '^fugitive') == 0)
      return
    endif
    let l:save_view = winsaveview()
    let l:now = strftime('%Y-%m-%d')

    call cursor(1, 1)
    let l:matchlist = matchlist(getline(search('Last Updated', 'W', 10)), 'Last Updated: \(.*\)')
    if (!len(l:matchlist))
      call winrestview(l:save_view)
      return
    endif
    let l:lastUpdated = l:matchlist[1]
    if (l:lastUpdated ==# l:now)
      call winrestview(l:save_view)
      return
    end

    " normal <c-o>
    if (line('$') <= 10)
      silent! keeppatterns    :%s/\(^\("\|#\) Last Updated:\)\zs.*/\=' ' . l:now
    else
      silent! keeppatterns :1,10s/\(^\("\|#\) Last Updated:\)\zs.*/\=' ' . l:now
    endif
    call winrestview(l:save_view)
  endfunction
" }}}

command! CheckForSmithers exec "silent! !echo This is Smithers\\' vimrc" | q

" vim:foldmethod=marker:
