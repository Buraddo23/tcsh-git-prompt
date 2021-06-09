#!/usr/bin/env perl
#Put this script in $HOME/bin/git-prompt.pl and add these lines to your .tcshrc
#if ($?prompt && -x /usr/bin/git && -x $HOME/bin/git-prompt.pl ) then
#	alias precmd 'set prompt="`$HOME/bin/git-prompt.pl`"'
#else
#	set prompt="%{\033[0;32m%}[%n%{\033[1;34m%}@%M] %{\033[1;37m%}%c3%{\033[0m%}> "
#endif

use strict;
#use warnings;

my $red   ="%{\033[0;31m%}";
my $green ="%{\033[0;32m%}";
my $boldgr="%{\033[1;32m%}";
my $yellow="%{\033[0;33m%}";
my $blue  ="%{\033[1;34m%}";
my $cyan  ="%{\033[0;36m%}";
my $white ="%{\033[0;37m%}";
my $end   ="%{\033[0m%}";

my $prompt="${boldgr}[%n${blue}@%M] ${white}%B%c3%b";
my $git_branch=`/usr/bin/env git rev-parse --abbrev-ref HEAD 2> /dev/null`;
chomp $git_branch;

my %index = ('M', 0,
             'A', 0,
             'D', 0);
my %work_dir = ('M', 0,
                'A', 0,
                'D', 0);
my %extra = ('?', 0,
             '!', 0);

if ($git_branch ne "") {
	$prompt .= " ${cyan}{${git_branch} ";
	
	open IF, "/usr/bin/env git status --branch --porcelain 2> /dev/null|" or exit;
	
	$_ = <IF>;
	if ($_ =~ /\[ahead (\d+)\]/) {
		$prompt .= "^$1";
	} elsif ($_ =~ /\[behind (\d+)\]/) {
		$prompt .= ".$1";
	} else {
		$prompt .= "=";
	}

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
	}

	$prompt .= "${green}";
	$prompt .= " +$index{'A'} ~$index{'M'} -$index{'D'}" if (grep { $_ != 0 } values %index); 
	$prompt .= " ?$extra{'?'}" if ($extra{'?'});
	$prompt .= " !$extra{'!'}" if ($extra{'!'});
	$prompt .= " |" if ((grep { $_ != 0 } values %index) && (grep { $_ != 0 } values %work_dir));
	$prompt .= "${red} +$work_dir{'A'} ~$work_dir{'M'} -$work_dir{'D'}" if (grep { $_ != 0 } values %work_dir);
	$prompt .= "${cyan}}";
}
$prompt .= "${end}> ";
	
print $prompt;