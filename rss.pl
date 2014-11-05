#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use XML::Feed;

my $url = XML::Feed->parse(URI->new('http://allegro.pl/rss.php?feed=search&?bmatch=seng-v6-p-3-e-1021&order=m&string=rolleiflex'));

print $url->title;
my @arr;

for my $item ($url->entries) {
   # print $item->title, "\n";
    print my $itm = $item->title.$item->content->body;
  push @arr, $itm;
  #  Dumper @itm;
}


print $#arr;
