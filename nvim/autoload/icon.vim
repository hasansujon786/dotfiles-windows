"!::exe [So]
"
" Powerline characters:
" "                
" 
let s:by_name = {
\ 'lock':     '',
\ 'checking': '',
\ 'warning':  '',
\ 'error':    '',
\ 'ok':       '',
\ 'info':     '',
\ 'hint':     '',
\ 'line':     '',
\ 'separator-right': '',
\}

let s:by_filetype = {
\  'default':      '',
\
\  'ai':           '',
\  'apache':       '',
\  'awk':          '',
\  'bash':         '',
\  'bat':          '',
\  'bazel':        '',
\  'bib':          '',
\  'bmp':          '',
\  'c':            '',
\  'c++':          '',
\  'cc':           '',
\  'clisp':        '',
\  'clj':          '',
\  'cljc':         '',
\  'cljs':         '',
\  'clojure':      '',
\  'cmake':        '',
\  'cobol':        '',
\  'coffee':       '',
\  'conf':         '',
\  'config':       '',
\  'coq':          '',
\  'cp':           '',
\  'cpp':          '',
\  'crystal':      '',
\  'cs':           '',
\  'csh':          '',
\  'csharp':       '',
\  'css':          '',
\  'cuda':         '',
\  'cxx':          '',
\  'cython':       '',
\  'd':            '',
\  'dart':         '',
\  'db':           '',
\  'diff':         '',
\  'dockerfile':   '',
\  'dump':         '',
\  'edn':          '',
\  'eex':          '',
\  'ejs':          '',
\  'elisp':        '',
\  'elixir':       '',
\  'elm':          '',
\  'erl':          '',
\  'ex':           '',
\  'exs':          '',
\  'f#':           '',
\  'fish':         '',
\  'fs':           '',
\  'fsi':          '',
\  'fsscript':     '',
\  'fsx':          '',
\  'gif':          '',
\  'git':          '',
\  'gnu':          '',
\  'go':           '',
\  'graphviz':     '',
\  'h':            '',
\  'hbs':          '',
\  'hh':           '',
\  'hpp':          '',
\  'hrl':          '',
\  'hs':           '',
\  'htm':          '',
\  'html':         '',
\  'hxx':          '',
\  'ico':          '',
\  'idris':        '',
\  'ini':          '',
\  'j':            '',
\  'jasmine':      '',
\  'java':         '',
\  'javascript':   '',
\  'jl':           '',
\  'jpeg':         '',
\  'jpg':          '',
\  'js':           '',
\  'json':         '',
\  'jsx':          '',
\  'julia':        '⛬',
\  'jupyter':      '',
\  'kotlin':       '',
\  'ksh':          '',
\  'labview':      '',
\  'leex':         '',
\  'less':         '',
\  'lhs':          '',
\  'lisp':         'λ',
\  'llvm':         '',
\  'lsp':          'λ',
\  'lua':          '',
\  'm':            '',
\  'markdown':     '',
\  'mathematica':  '',
\  'matlab':       '',
\  'max':          '',
\  'md':           '',
\  'mdx':          '',
\  'meson':        '',
\  'mjs':          '',
\  'mli':          'λ',
\  'ml':           'λ',
\  'mustache':     '',
\  'nginx':        '',
\  'nim':          '',
\  'nix':          '',
\  'nvcc':         '',
\  'nvidia':       '',
\  'octave':       '',
\  'opencl':       '',
\  'org':          '',
\  'patch':        '',
\  'perl6':        '',
\  'php':          '',
\  'pl':           '',
\  'pm':           '',
\  'png':          '',
\  'postgresql':   '',
\  'pp':           '',
\  'prolog':       '',
\  'ps':           '',
\  'ps1':          '',
\  'psb':          '',
\  'psd':          '',
\  'py':           '',
\  'pyc':          '',
\  'pyd':          '',
\  'pyo':          '',
\  'python':       '',
\  'rb':           '',
\  'react':        '',
\  'reason':       '',
\  'rkt':          '',
\  'rlib':         '',
\  'rmd':          '',
\  'rs':           '',
\  'rss':          '',
\  'ruby':         '',
\  'rust':         '',
\  'sass':         '',
\  'scala':        '',
\  'scheme':       'λ',
\  'scm':          'λ',
\  'scrbl':        '',
\  'scss':         '',
\  'sh':           '',
\  'slim':         '',
\  'sln':          '',
\  'sql':          '',
\  'styl':         '',
\  'suo':          '',
\  'svg':          '',
\  'swift':        '',
\  't':            '',
\  'tex':          '',
\  'toml':         '',
\  'ts':           '',
\  'tsx':          '',
\  'twig':         '',
\  'txt':          '',
\  'typescript':   '',
\  'vim':          '',
\  'vue':          '﵂',
\  'xcplayground': '',
\  'xul':          '',
\  'yaml':         '',
\  'yml':          '',
\  'zsh':          '',
\}

let s:by_filename = {
\  'gruntfile.coffee': '',
\  'gruntfile.js': '',
\  'gruntfile.ls': '',
\  'gulpfile.coffee': '',
\  'gulpfile.js': '',
\  'gulpfile.ls': '',
\  'mix.lock': '',
\  'dropbox': '',
\  '.ds_store': '',
\  '.git': '',
\  '.gitconfig': '',
\  '.gitignore': '',
\  '.gitlab-ci.yml': '',
\  '.env': '',
\  '.bashrc': '',
\  '.zshrc': '',
\  '.vimrc': '',
\  '.gvimrc': '',
\  '_vimrc': '',
\  '_gvimrc': '',
\  '.bashprofile': '',
\  'favicon.ico': '',
\  'license': '',
\  'node_modules': '',
\  'react.jsx': '',
\  'procfile': '',
\  'dockerfile': '',
\  'docker-compose.yml': '',
\}

let s:icons = {
\  'by_name': s:by_name,
\  'by_filename': s:by_filename,
\  'by_filetype': s:by_filetype
\}

function! icon#file(filename, filetype)
  return get(
  \ s:icons['by_filename'],
  \ a:filename,
  \ get(s:icons['by_filetype'], a:filetype, s:icons['by_filetype']['default'])
  \)
endfunction

function! icon#name(name)
  return get(
  \ s:icons['by_name'],
  \ a:name,
  \ '[INVALID_NAME]'
  \)
endfunction
