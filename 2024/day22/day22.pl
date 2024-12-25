#!/usr/bin/perl
use strict;

my $MASK = 0xffffff;

sub forward($) {
    my $secret = shift;
    $secret = ($secret << 6 ^ $secret) & $MASK;
    $secret = ($secret >> 5 ^ $secret) & $MASK;
    return ($secret << 11 ^ $secret) & $MASK;
}

my ($part1, $part2);
my %changeValues;
while (<>) {
    chomp;
    my $secret = $_;
    my @changes;
    my %seen;
    for my $round (1..2000) {
        push @changes, -($secret % 10);
        $secret = forward $secret;
        $changes[-1] += $secret % 10;
        if (@changes == 4) {
            my $changes = join(":", @changes);
            $changeValues{$changes} += $secret % 10 unless $seen{$changes}++;
            shift @changes;
        }
    }
    $part1 += $secret;
}

$_ > $part2 and $part2 = $_ for values %changeValues;

print "$part1\n$part2\n";
