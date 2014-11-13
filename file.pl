#!/usr/bin/env perl
use strict;
use warnings;



sub process {
    my @arr = split (/ \| /, shift);
    my $iter = pop @arr;
    @arr = split / /, $arr[0];
    for my $m (1..$iter) {
        for my $i (0..($#arr - 1)){
            if ($arr[$i] > $arr[$i+1]) {
                splice (@arr, $i, 0, (splice (@arr, $i+1, 1)));
            }            
        }       
    }
    print join (' ', @arr), "\n";
}

sub readlines {
    open (my $fh, '<', $ARGV[0]);
    while (my $line = <$fh>) {
        if ($line =~ m/^\n$/) {
            next;
        }
        chomp $line;
        process $line;
    }
    close $fh;
}

readlines;