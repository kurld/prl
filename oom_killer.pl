#!/usr/bin/env perl
#
use strict;
use warnings;


use POSIX 'setsid';
#use File::Basename;

#my $sname = basename($0);
#print $sname;
#system("ps -ef|grep vms.pl|grep -v grep") && die('ad');
#print $?;

defined (my $kid = fork) or die "Cannot fork: $!\n";
if ($kid) {
    # Parent runs this block
    exit(0);
} else {

    close STDIN;
    close STDOUT;
    close STDERR;
    setsid or die "Can't start a new session: $!";
    umask(0027); # create files with perms -rw-r----- 
    chdir '/' or die "Can't chdir to /: $!";

    open STDIN,  '<', '/dev/null' or die $!;
    open STDOUT, '>', '/dev/null' or die $!;
    open STDERR, '>>', '/root/zzz';

    defined (my $grandkid = fork) or die "Cannot fork: $!\n";
    if($grandkid){
        exit(0);
    } else {
	mainf()
      }
}
    
sub mainf {

sub oom;
sub adj_score;

my $iter = 3;
#my $swapused = 10000000;
#my $free = 1500000;
#my $iowait = 10;
#my $trashing = 1000000;
my $score = 0;

my $swapused = 0;
my $free = 150000;
my $iowait = 0;
my $trashing = 0;

sub oom {
    my $count = 0;
    for my $n (qx#ps -ef|awk '{print \$2}'#) {
	chomp $n;
	my $mscore = qx#cat /proc/$n/oom_score 2>/dev/null#;
	if ($mscore =~ m/\d+/ && $mscore > 10) {
	   $count += 1;
	}
    } 
   if ($count > 0) {
	   adj_score;
	  # system("echo f > /proc/sysrq-trigger");
    	   system("logger -p kern.crit manual OOM triggered, stat: @_");
	   #sleep 15;
   }
   else {
    	   system("logger -p kern.crit OOM condition met but not killed, scores to low, stat: @_");
	   print("no processes to kill\n");
   }
}

sub adj_score {

my @list = ('sshd', 'init', 'mingetty', 'rsyslog');
my @pids;
foreach (@list) {
        push @pids, qx/pgrep $_/;
}
chomp (@pids);
foreach (@pids) {
         system("echo -1000 > /proc/$_/oom_score_adj") ;
	 system("logger -p kern.crit Adjusted scores before OOM trigger for $_");

}
}


while (1) {
    my @arr = qx/vmstat -t -n 1 $iter/;
    shift @arr;
    shift @arr;
    $score = 0;
    my @line;

    for my $i (@arr) {
        @line = split (/\s+/, $i);
        if ($line[3] >= $swapused && $line[4] + $line[6] < $free && $line[7] * $line[8] >= $trashing && $line[16] >= $iowait) {
            $score += 1;
        }
    }   
    if ($score == $iter) {
    	oom(@line);
    }
    sleep 1;
}
}
