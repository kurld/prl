#!/usr/bin/env perl

use strict;
use warnings;
sub croak {die "@_ $!\n\n"}

use File::Find;
use File::Spec;

unless ($#ARGV == 0) { croak "\nUzycie:\n perl $0 [katalog]"; }

#my $dirr = $ARGV[0];
my $dir = File::Spec->rel2abs( $ARGV[0] ) ;

find(\&search_php, $dir);

sub search_php {
        
    my $file = $File::Find::name;
    if ((-f $file) && ($file =~ m/\.php$/)) {
        open(IN, '<', $file) or die $!;
        open(OUT, '>>', $file."\.bk") or die $!;
        while (<IN>) {
            s#<\?(\s)#<?php$1#g;
            #print $1, "\n";
            
            print OUT $_;
        }
            
    close IN;  
    close OUT;
    rename "$file\.bk", $file;
    }
        
        
}
