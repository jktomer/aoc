#!/usr/bin/perl

use strict;

my $pos = 50;
my $part1 = 0;
my $part2 = 0;

while (<>) {
    my ($dir, $clicks) = /^([LR])(\d+)$/ or die;

#    print "$pos $dir $clicks ";

    $part2 += int($clicks / 100);
    $clicks = $clicks % 100;

    $part2++ if ($dir eq 'L' and $pos != 0 and $clicks >= $pos)
        or ($dir eq 'R' and ($pos + $clicks) >= 100);

    $clicks = -$clicks if $dir eq 'L';
    $pos = ($pos + $clicks) % 100;

#    print "$pos $part2\n";

    $part1++ if $pos == 0;
}

print "$part1 $part2\n";
