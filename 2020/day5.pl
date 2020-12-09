#!/usr/bin/perl

open INPUT, "day5.txt" or die $!;

my ($minseatid, $maxseatid) = (1025, 0);
my @usedSeats;
$usedSeats[$minseatid] = 1;
while (<INPUT>) {
    chomp;
    /^[BF]{7}[RL]{3}$/ or die "unrecognized input $_";
    y/BFRL/1010/;
    my $seatid = oct("0b$_");
    $maxseatid = $seatid if $maxseatid < $seatid;
    $minseatid = $seatid if $minseatid > $seatid;
    $usedSeats[$seatid]++;
}

print "max: $maxseatid\n";
print "open in [$minseatid, $maxseatid]: ", join(", ", grep { not $usedSeats[$_] } ($minseatid .. $maxseatid)), "\n";
