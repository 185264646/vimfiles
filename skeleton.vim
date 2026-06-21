" This function returns a list, not a string
function skeleton#generate_c_skeleton() abort
	let l:rs = []

	call add(l:rs, '// SPDX-License-Identifier: GPL-2.0-or-later')
	call add(l:rs, '/*')
	let l:copyright_line = substitute(' * Copyright (c) <year> Yang Xiwen <forbidden405@outlook.com>', '<year>', strftime('%Y'), '')
	call add(l:rs, l:copyright_line)
	call add(l:rs, ' */')
	" An empty line
	call add(l:rs, '')

	return l:rs
endfunction

function skeleton#insert_c_skeleton() abort
	" append automatically translates all \n to NUL in the string. It's annoying.
	" This forces us to use a list rather than a string with \n
	call append(0, skeleton#generate_c_skeleton())
endfunction

augroup my_skeleton
	autocmd!
	autocmd BufNewFile *.{c,h,cpp,hpp,cc,hh,c++} call skeleton#insert_c_skeleton()
augroup END
