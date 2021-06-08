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

my $git_status = 0;
my %index = ('M', 0,
             'A', 0,
             'D', 0);
my %work_dir = ('M', 0,
                'A', 0,
                'D', 0);
my %extra = ('?', 0,
             '!', 0);

if ($git_branch ne "") {
	open IF, "/usr/bin/env git status --porcelain 2> /dev/null|" or exit;
	while (<IF>) {
		$index{'M'}++ if ($_ =~ /^.M/);
		$index{'A'}++ if ($_ =~ /^.A/);
		$index{'D'}++ if ($_ =~ /^.D/);
		$index{'M'}++ if ($_ =~ /^.R/);
		$work_dir{'M'}++ if ($_ =~ /^M/);
		$work_dir{'A'}++ if ($_ =~ /^A/);
		$work_dir{'D'}++ if ($_ =~ /^D/);
		$work_dir{'M'}++ if ($_ =~ /^R/);
		$extra{'?'}++ if ($_ =~ /^\?\?/);
		$extra{'!'}++ if ($_ =~ /^!!/);
		$git_status++;
	}
	
	if ($git_status > 0) {
		$prompt .= "${red} ";
	} else {
		$prompt .= "${green} ";
	}
	$prompt .= "{${git_branch} +$index{'A'} ~$index{'M'} -$index{'D'}";
	$prompt .= " ?$extra{'?'}" if ($extra{'?'});
	$prompt .= " !$extra{'!'}" if ($extra{'!'});
	$prompt .= " | +$work_dir{'A'} ~$work_dir{'M'} -$work_dir{'D'}}";
}
$prompt .= "${end}> ";
	
print $prompt;