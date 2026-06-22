" Source defaults.vim, which sets up a lot of default settings.
source $VIMRUNTIME/defaults.vim

" For K and :Man
source $VIMRUNTIME/ftplugin/man.vim

" C/C++ indentation setting
" (0: see :h cino-(
" =0: see :h cino-=
set cinoptions=(0=0

runtime os_detect.vim
runtime skeleton.vim

if os_detect#is_android_termux()
	runtime vimrc_termux
elseif os_detect#is_gnu_linux()
	runtime vimrc_gnu
endif

" This comes after vimrc so the global settings are updated before loading the
" package

" Debian sets this to the dist-bundled conf file
" override it to be empty, we don't need this
let g:ycm_global_ycm_extra_conf = ''
packadd! youcompleteme
