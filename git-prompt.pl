#!/usr/bin/env perl
#Put this script in $HOME/bin/git-prompt.pl and add these lines to your .tcshrc
#if ($?prompt && -x /usr/bin/git && -x $HOME/bin/git-prompt.pl ) then
#	alias precmd 'set prompt="`$HOME/bin/git-prompt.pl`"'
#else
#	set prompt="%{\033[0;32m%}[%n%{\033[1;34m%}@%M] %{\033[1;37m%}%c3%{\033[0m%}> "
#endif

use strict;
use warnings;

my $red  ="%{\033[0;31m%}";
my $green="%{\033[0;32m%}";
my $blue ="%{\033[1;34m%}";
my $white="%{\033[0;37m%}";
my $end  ="%{\033[0m%}";

my $prompt="${green}[%n${blue}@%M] ${white}%B%c3%b";
my $git_branch=`/usr/bin/env git rev-parse --abbrev-ref HEAD 2> /dev/null`;
chomp $git_branch;

my $git_status=0;
if ($git_branch ne "") {
	open IF, "/usr/bin/env git status --porcelain 2> /dev/null|" or exit;
	while (<IF>) {
		$git_status++;
	}
	
	if ($git_status > 0) {
		$prompt .= "${red} ";
	} else {
		$prompt .= "${green} ";
	}
	$prompt .= "{${git_branch}}"
}
$prompt .= "${end}> ";
	
print $prompt;