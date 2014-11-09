#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use XML::Feed;
use utf8;


my $url = XML::Feed->parse(URI->new('http://allegro.pl/rss.php?feed=search&?bmatch=seng-v6-p-3-e-1021&order=m&string=rolleiflex'));

#print $url->title;
my %ha;

for my $item ($url->entries) {
   # print $item->title, "\n";
   # print my $itm = $item->title.$item->content->body;
   my $title = $item->title;
   my $body = $item->content->body;
   #$title =~ s/[^[:ascii:]]+//g;
   #$body =~ s/[^[:ascii:]]+//g;
   if ($body =~ m/http.*?("http.*")/) {
   print $1;
   }
    $ha{$title} = $body;
  #  Dumper @itm;
}

binmode(STDOUT, ":utf8");
#for my $key (keys %ha) {
 #   print "$key \n", %ha{$key}, "\n\n";
#}

# print Dumper %ha;


