" This function returns a list, not a string
function s:generate_c_skeleton() abort
	let l:rs = []

	call add(l:rs, '// SPDX-License-Identifier: GPL-2.0-or-later')
	call add(l:rs, '/*')
	let l:copyright_line = printf(' * Copyright (c) %s Yang Xiwen <forbidden405@outlook.com>', strftime('%Y'))
	call add(l:rs, l:copyright_line)
	call add(l:rs, ' */')
	" An empty line
	call add(l:rs, '')

	return l:rs
endfunction

function s:insert_c_skeleton() abort
	" append automatically translates all \n to NUL in the string. It's annoying.
	" This forces us to use a list rather than a string with \n
	call append(0, s:generate_c_skeleton())
endfunction

function s:generate_makefile_skeleton() abort
	let l:rs = []

	call add(l:rs, '# SPDX-License-Identifier: GPL-2.0-or-later')
	let l:copyright_line = printf('# Copyright (c) %s Yang Xiwen <forbidden405@outlook.com>', strftime('%Y'))
	call add(l:rs, l:copyright_line)
	" An empty line
	call add(l:rs, '')

	return l:rs
endfunction

function s:insert_makefile_skeleton() abort
	" append automatically translates all \n to NUL in the string. It's annoying.
	" This forces us to use a list rather than a string with \n
	call append(0, s:generate_makefile_skeleton())
endfunction

augroup my_skeleton
	autocmd!
	autocmd BufNewFile *.{c,h,cpp,hpp,cc,hh,c++} call s:insert_c_skeleton()
	autocmd BufNewFile GNUmakefile,Makefile,makefile,Makefile.* call s:insert_makefile_skeleton()
augroup END
