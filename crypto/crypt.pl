#!/usr/bin/env perl
use strict;
use warnings;
use Digest::MD5 qw(md5_base64);
use Digest::SHA qw(sha512_base64 sha1_base64);
use Crypt::PasswdMD5;
use Term::ReadKey;

sub main {   
    while (1) {
	print "Hasło: \n";
        my $rands = &salt;
	ReadMode("noecho");
	chomp (my $input = <STDIN>);
	ReadMode ("original");
            if ($input =~ m/\A[\s]?$/) {
                print "Cos poszło nie tak. Pusta linia?\n";
                next;
            }
        print "MD5: ", md5_base64($input), "\n";
        print "SHA1: ", sha1_base64($input), "\n";
        print "SHA512: ", sha512_base64($input), "\n";
        print "APACHE MD5: ", apache_md5_crypt($input, $rands), "\n";
        print "UNIX MD5: ", unix_md5_crypt($input, $rands), "\n";
        last
    }
}

sub salt {
    open (my $rand, '<', '/dev/urandom') or die $!;
    read ($rand, my $seed, 8);
    close $rand;
    my $rands = unpack("H*", $seed);  
}

main;
