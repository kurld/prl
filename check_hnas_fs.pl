m0107872@dest-wotan01:~> cat check_hnas_fs.pl
#!/usr/bin/env perl
#Check file system utilization using SNMP on Fujitsu HHAS device
#Usage: check_hnas_fs.pl HNAS_HOST(string) FS_NAME(string) WARN_PERCENT(int) CRIT_PERCENT(int)
#Author: 
#Version: 1.0
#Date: 05.01.2021

use strict;
use warnings;

print("Usage: $0 \$HOSTADDRESS \$FS_LABEL \$WARN_TRSHD_PERCENT \$CRIT_TRSHD_PERCENT\n") and exit(3) if( scalar(@ARGV) != 4);

my ($host, $fs, $warn, $crit) = @ARGV;
my @rawFS;
my %parsedFS;
my %numbers;
my $fsID;
use constant MAX_INT => 4294967295;


#remove slashes from $fs if present

$fs =~ s/^\///;
$fs =~ s/\/$//;


#get all fs names on NAS and fs->id mappings

@rawFS =  qx#snmpwalk -On -v 2c -c public $host  1.3.6.1.4.1.11096.6.1.1.6.3.2.1.2# or exit(3);
foreach(@rawFS) {
        if ($_ =~ m/\.(\d\d\d\d)\s=\sSTRING:\s"(\S+)"$/) {
                $parsedFS{"$2"} = $1; }
}


#set fsID for $fs

$fsID = $parsedFS{"$fs"};
print('UNKNOWN: No such filesystem') and exit(3) unless defined($fsID);


#get numbers

$numbers{'totalUpper'} = qx#snmpwalk -On -v 2c -c public $host  1.3.6.1.4.1.11096.6.1.1.6.3.2.1.3.$fsID|awk \'{print \$4}\'# or exit(3);
$numbers{'totalLower'} = qx#snmpwalk -On -v 2c -c public $host  1.3.6.1.4.1.11096.6.1.1.6.3.2.1.4.$fsID|awk \'{print \$4}\'# or exit(3);
$numbers{'usedUpper'} = qx#snmpwalk -On -v 2c -c public $host  1.3.6.1.4.1.11096.6.1.1.6.3.2.1.5.$fsID|awk \'{print \$4}\'# or exit(3);
$numbers{'usedLower'} = qx#snmpwalk -On -v 2c -c public $host  1.3.6.1.4.1.11096.6.1.1.6.3.2.1.6.$fsID|awk \'{print \$4}\'# or exit(3);


#Combine upper and lower bytes if needed
#Final value = upper * 4294967295 + lower

if ( $numbers{'usedUpper'} > 0 ) {
        $numbers{'used'} = $numbers{'usedUpper'} * MAX_INT + $numbers{'usedLower'}; }
elsif ($numbers{'usedUpper'} == 0) {
         $numbers{'used'} = $numbers{'usedLower'}; }
else {
        print('UNKNOWN STATUS') and exit(3); }
if ( $numbers{'totalUpper'} > 0 ) {
        $numbers{'total'} = $numbers{'totalUpper'} * MAX_INT + $numbers{'totalLower'}; }
elsif ($numbers{'totalUpper'} == 0) {
         $numbers{'total'} =  $numbers{'totalLower'}; }
else {
        print('UNKNOWN STATUS') and exit(3); }



#calculate

$numbers{'usedPercent'} = $numbers{'used'} * 100 / $numbers{'total'};
$numbers{'free'} = $numbers{'total'} - $numbers{'used'};


#print result and exit with Nagios exit coded
#3->UNKNOWN
#2->CRIT
#1->WARN
#0->OK

if ($numbers{'usedPercent'} > $crit) {
        print(sprintf("CRITICAL: FILESYSTEM $fs usage is at %.1f%%  TOTAL %.1f GB  FREE: %.1f GB", $numbers{'usedPercent'}, $numbers{'total'} >> 30,  $numbers{'free'} >> 30)) and exit(2);
} elsif ($numbers{'usedPercent'} >= $warn) {
        print(sprintf("WARNING: FILESYSTEM $fs usage is at %.1f%%  TOTAL %.1f GB  FREE: %.1f GB", $numbers{'usedPercent'}, $numbers{'total'} >> 30,  $numbers{'free'} >> 30)) and exit(1);
} elsif ($numbers{'usedPercent'} < $warn) {
        print(sprintf("OK: FILESYSTEM $fs usage is at %.1f%%", $numbers{'usedPercent'})) and exit(0);
} else {
        print('UNKNOWN STATUS') and exit(3)

}

