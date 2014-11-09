#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use List::Util 'sum';

my %ha;


open( my $file, '<', $ARGV[-1]) or die $!;
    
while (my $line = <$file>) { 
    if ($line =~ m#(?:")(?:[A-Z]+)\s+(\S+)\s+#) {
        print $1, "\n";
        #my $fs = $2;
        #$fs =~ s/"//g;
        #$ha{$1}++;
    } 
}

close $file;

#for my $key (sort keys %ha) {
#    print "$key ", $ha{$key}," req -> ", int($ha{$key} * 100 / sum values %ha), "%\n";  
#}


#print $sum;
