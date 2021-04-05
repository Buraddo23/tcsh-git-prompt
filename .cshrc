if ($?prompt && -x /usr/bin/git && -x $HOME/bin/git-prompt.pl ) then
	alias precmd 'set prompt="`$HOME/bin/git-prompt.pl`"'
else
	set prompt="%{\033[0;32m%}[%n%{\033[1;34m%}@%M] %{\033[1;37m%}%c3%{\033[0m%}> "
endif
