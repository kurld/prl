#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use List::Util 'sum';

my %ha;


open( my $file, '<', 'auth.log') or die;
    
while (my $line = <$file>) { 
    if ($line =~ m/(\d\d:)/) {
        $ha{$1}++;
    } 
}

close $file;

my $sum = sum values %ha;

for my $key (keys %ha) {
    $ha{$key} = $ha{$key} * 100 / $sum;   
}

for my $key (sort keys %ha) {
    print "$key ", int($ha{$key}), "%\n";  
}


#print $sum;
