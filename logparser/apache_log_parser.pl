e strict;
use warnings;
use Getopt::Std;
sub croak {die "$0: @_: $!\n"}
my %ha = ();
my %ha2 = ();
my %opts = ();
getopts("ab", \%opts);

sub read_file {

    my $file = shift;
    open(FILE, $file) or croak;
    while (my $line = <FILE>) {
        if ($line =~ m/$main::pattern/) {
            if ( !$ha{$1}) {
                $ha{$1}++;
            }
        }
    }
    close FILE;
}    
 
sub openx {
    while (my $files = shift) {

        read_file $files;
    }
}

sub help {
    print "\nUzycie: perl $0 param plik(i)\n";
    print "   -a podsumowanie IP\n   -b podsumowanie przeglarek\n\n";
}

if (defined $opts{b}) {
    our $pattern = '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}.*((MSIE|Mozilla).*?);';
    openx @ARGV
}

elsif (defined $opts{a}) {
    our $pattern = '(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})';
    openx @ARGV
}

else {
    help
}

foreach my $key (sort {$ha{$a} <=> $ha{$b}} keys %ha) {
	print "$key: $ha{$key}\n";
}  
  
  
