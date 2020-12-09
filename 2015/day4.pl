#!/usr/bin/perl

use Digest::MD5 qw(md5_hex);

my $key = shift;
my $start = '0' x shift;
my $regex = qr/^$start/;
my $n = 1;
$n++ until md5_hex("$key$n") =~ /$regex/;

print "$n\n";
