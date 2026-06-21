" Source defaults.vim, which sets up a lot of default settings.
source $VIMRUNTIME/defaults.vim

" For K and :Man
source $VIMRUNTIME/ftplugin/man.vim

runtime os_detect.vim

if os_detect#is_android_termux()
	runtime vimrc_termux
elseif os_detect#is_gnu_linux()
	runtime vimrc_gnu
endif
