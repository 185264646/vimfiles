function! os_detect#is_windows_native()
	return has('win32') || has('win64') || has('win16') || has('win95')
endfunction

function! os_detect#is_windows_msys2()
	return has('win32unix')
endfunction

function! os_detect#is_android_termux()
	return has('termux')
endfunction

function! os_detect#is_macos()
	return has('mac')
endfunction

function! os_detect#is_gnu_linux()
	" Android is not ordinary GNU/Linux distro, exclude it
	return has('linux') && !has('android')
endfunction
