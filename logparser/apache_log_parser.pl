#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Std;
sub croak {die "$0: @_: $!\n"}
my %ha;
my %opts;
my $pattern;
my $info = "To moze chwile potrwac...";
getopts("abc", \%opts);

sub ip_num {
    print STDERR $info, "\n";
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
    print STDERR $info, "\n";
    while (my $files = shift) {
	open(FILE, $files) or croak;
	while (my $line = <FILE>) {
	    if ($line =~ m/$pattern/) {
		$ha{$1}++ ; 
	    }
	}
	close FILE;
    }
    foreach my $key (sort {$ha{$a} <=> $ha{$b}} keys %ha) {
	print "$key: $ha{$key}\n";
    }
}  

sub browser {
    print STDERR $info, "\n";
    while (my $files = shift) {
	open(FILE, $files) or croak;
	while (my $line = <FILE>) {
	    if ($line =~ m/$pattern/) {
		$ha{$1}++ ; 
	    }
	}
	close FILE;
    }
    foreach my $key (sort {$ha{$a} <=> $ha{$b}} keys %ha) {
	print "$key: $ha{$key}\n";
    }
}  


sub help {
    print "\nUzycie: perl $0 param plik(i)\n";
    print "   -a podsumowanie IP\n   -b podsumowanie przeglarek\n\n";
}

if (defined $opts{b}) { $pattern = '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}.*((MSIE|Mozilla).*?);'; ip_num @ARGV }
elsif (defined $opts{a}) { $pattern = '(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})'; ip_num @ARGV }
elsif (defined $opts{c}) { $pattern = '(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})'; ip_max @ARGV }
else { help }


  
