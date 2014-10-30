#!/usr/bin/env perl
use strict;
use warnings;

#!usr/bin/perl 

use warnings;
use strict;

my $log = "/magazyn/access.log";
my %seen = ();

open (my $fh, "<", $log) or die "unable to open $log: $!"; 

while( my $line = <$fh> ) {
    chomp $line;

    if( $line =~ /(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/ ){
        my $ln = $1;
        if (! $seen{$ln}) {
           $seen{$ln}++;
        }
               
    }
}
close $fh;

for my $key ( keys %seen ) {
    print "$key: $seen{$key}\n";
}
my $ha_ref = \%seen;

for my $keys (keys %{$ha_ref}){
    print $ha_ref -> {$keys}, "\n";
}
