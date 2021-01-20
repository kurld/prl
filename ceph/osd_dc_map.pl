#!/usr/bin/env perl
#Checks if all copies of PG are it the same DC or not

use strict;
use warnings;

my @dc1 = qx@ceph osd crush ls dc-des1@;
my @dc2 = qx@ceph osd crush ls dc-dest@;

my @osd_in_dc1;
my @osd_in_dc2;


foreach (@dc1) {
  my @t = qx#ceph osd crush ls $_#;
  foreach my $line (@t) {
    if ($line =~ m/(\d+)/) {
        push (@osd_in_dc1, $1);
    }
  }
}
foreach (@dc2) {
  my @t = qx#ceph osd crush ls $_#;
  foreach my $line (@t) {
    if ($line =~ m/(\d+)/) {
        push (@osd_in_dc2, $1)
    }
  }
}

my @pg;


open (my $in, "ceph pg dump pgs 2>/dev/null |");

while (my $line = <$in>)
{
    if ($line =~ /\[/)
    {
        push @pg, $line;
    }
}
close($in);


foreach my $line(@pg) {
   my @s = split(' ', $line);
   next if (scalar(@s) < 16);
   print "$s[0] ";
   $s[16] =~ s/[\[\]]//g ;
   my @osds = split(',', $s[16]);
   foreach my $osd(@osds) {
     print "OSD:$osd ";
       if ($osd ~~ @osd_in_dc1) {
          print ("DC1 ");
       }
       elsif ($osd ~~ @osd_in_dc2) {
          print ("DC2 ");
       }
   }
   print "\n";
}


