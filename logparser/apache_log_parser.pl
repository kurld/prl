#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Std;
use List::Util 'sum';
sub croak {die "$0: @_: $!\n"}

my %ha;
my %opts;
my $pattern;
my $info = "To moze chwile potrwac...";
getopts("abc", \%opts);

sub ip_num {
    #print STDERR $info, "\n";
    while (my $files = shift) {
	open(FILE, $files) or croak;
	while (my $line = <FILE>) {
	    if ($line =~ m/$pattern/) {
		$ha{$1}++ if (!$ha{$1});
	    }
	}
	close FILE;
    }
    print my $size = keys %ha, " unikalnych IP\n";
}  
  
sub ip_max {
    #print STDERR $info, "\n";
    while (my $files = shift) {
	open(FILE, $files) or croak;
	while (my $line = <FILE>) {
	    if ($line =~ m/$pattern/) {
		$ha{$1}++ ; 
	    }
	}
	close FILE;
    }
    my @val = sort( {$ha{$a} <=> $ha{$b}} keys %ha);
    for my $i (-20..-1) {
	my $hostname = qx/nslookup $val[$i]/;
	$hostname =~ s/[\s\n]+/ /g;
	if ($hostname =~ m/name\ =\ (\S+)/ ){
	    print $val[$i], "\t", $ha{$val[$i]},"\t", "$1", "\n";
	}
	else {
	    print $val[$i], "\t", $ha{$val[$i]}, "\n";
	}
    }  
}


sub time_of_day {
    open (my $file, '<', $ARGV[0]) or die $!;
    while (my $line = <$file>) { 
	if ($line =~ m/[^\d](\d\d:)/) {
	    $ha{$1}++;
	} 
    }
    close $file;
    for my $key (sort keys %ha) {
	print "$key ", $ha{$key},"req\t->\t", int($ha{$key} * 100 / sum values %ha), "%\n";  
    }    
}




sub help {
    print "\nUzycie: perl $0 param plik(i)\n";
    print "   -a podsumowanie IP\n   -b podsumowanie przeglarek\n\n";
}




if (defined $opts{a}) { $pattern = '(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})'; ip_num @ARGV }
elsif (defined $opts{b}) { $pattern = '(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})'; time_of_day }
elsif (defined $opts{c}) { $pattern = '(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})'; ip_max @ARGV }
else { help }


  
