" ============================================================
" Universal source file header template (SPDX + Copyright, configurable comment style)
" ============================================================

" ---- Global config: author, license, header order ----
" order can be "spdx-first" or "copyright-first"
let g:header_config = get(g:, 'header_config', {
  \ 'author':  'Yang Xiwen',
  \ 'license': 'GPL-2.0-or-later',
  \ 'order':   'spdx-first',
  \ })

" ---- Style table: configure comment style by file glob ----
" Fields:
"   comment : 'line' or 'block'
"   line    : line comment prefix (used when comment=='line'; no trailing space needed, it is added automatically)
"   start   : block comment start line (used when comment=='block')
"   middle  : block comment middle-line prefix (including indentation, e.g. ' * ' or '  ')
"   end     : block comment end line
"   shebang : optional; if present, inserted as line 1, and SPDX moves to line 2
let g:header_styles = get(g:, 'header_styles', {
  \ '*.c':    {'comment': 'line',  'line': '//'},
  \ '*.h':    {'comment': 'block', 'start': '/*',  'middle': ' * ', 'end': ' */'},
  \ '*.cpp':  {'comment': 'line',  'line': '//'},
  \ '*.cc':   {'comment': 'line',  'line': '//'},
  \ '*.hpp':  {'comment': 'block', 'start': '/*',  'middle': ' * ', 'end': ' */'},
  \ '*.py':   {'comment': 'line',  'line': '#', 'shebang': '#!/usr/bin/env python3'},
  \ '*.sh':   {'comment': 'line',  'line': '#', 'shebang': '#!/usr/bin/env bash'},
  \ '*.pl':   {'comment': 'line',  'line': '#', 'shebang': '#!/usr/bin/env perl'},
  \ '*.rb':   {'comment': 'line',  'line': '#', 'shebang': '#!/usr/bin/env ruby'},
  \ '*.lua':  {'comment': 'line',  'line': '--'},
  \ '*.vim':  {'comment': 'line',  'line': '"'},
  \ '*.js':   {'comment': 'line',  'line': '//'},
  \ '*.ts':   {'comment': 'line',  'line': '//'},
  \ '*.java': {'comment': 'line',  'line': '//'},
  \ '*.sql':  {'comment': 'line',  'line': '--'},
  \ '*.css':  {'comment': 'block', 'start': '/*',   'middle': ' * ', 'end': ' */'},
  \ '*.html': {'comment': 'block', 'start': '<!--', 'middle': '  ',  'end': '-->'},
  \ 'Makefile':    {'comment': 'line', 'line': '#'},
  \ 'makefile':    {'comment': 'line', 'line': '#'},
  \ 'GNUmakefile': {'comment': 'line', 'line': '#'},
  \ '*.mk':        {'comment': 'line', 'line': '#'},
  \ })

" ---- Internal functions ----

function! s:GlobToReg(glob) abort
  return exists('*glob2regpat') ? glob2regpat(a:glob) : '^' . a:glob . '$'
endfunction

function! s:FindStyle(filename) abort
  let name = fnamemodify(a:filename, ':t')
  for pattern in keys(g:header_styles)
    if name =~# s:GlobToReg(pattern)
      return g:header_styles[pattern]
    endif
  endfor
  return {}
endfunction

function! s:LineComment(prefix, text) abort
  let p = a:prefix
  if p !~# '\s$'
    let p .= ' '
  endif
  return p . a:text
endfunction

function! s:BuildHeader(style) abort
  let cfg  = g:header_config
  let year = strftime('%Y')

  let spdx      = 'SPDX-License-Identifier: ' . cfg.license
  let copyright = 'Copyright (c) ' . year . ' ' . cfg.author

  let content = cfg.order ==# 'copyright-first'
        \ ? [copyright, spdx]
        \ : [spdx, copyright]

  let lines = []
  if a:style.comment ==# 'block'
    call add(lines, a:style.start)
    for text in content
      call add(lines, a:style.middle . text)
    endfor
    call add(lines, a:style.end)
  else
    for text in content
      call add(lines, s:LineComment(a:style.line, text))
    endfor
  endif
  return lines
endfunction

function! s:InsertHeader() abort
  if &buftype !=# '' | return | endif          " Skip terminal / quickfix, etc.
  if exists('b:no_auto_header') | return | endif
  if line('$') != 1 || getline(1) !=# '' | return | endif  " Only handle empty new files

  let style = s:FindStyle(expand('%'))
  if empty(style) | return | endif

  let lines = []
  if has_key(style, 'shebang')
    call add(lines, style.shebang)
  endif
  call extend(lines, s:BuildHeader(style))
  call add(lines, '')  " Leave one blank line between the header and the code

  call append(0, lines)
  setlocal nomodified
  normal! G
endfunction

" ---- Automatic trigger & manual command ----

augroup UniversalHeaderTemplate
  autocmd!
  autocmd BufNewFile * call s:InsertHeader()
augroup END

command! HeaderInsert call s:InsertHeader()
