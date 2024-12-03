#!/usr/bin/perl

use strict;

my ($part1, $part2, $disable);
undef $/;
$_ = <>;
while (/(?:do\(\)|don't\(\)|mul\((\d+),(\d+)\))/g) {
    if ($& eq "do()") {
        undef $disable;
    } elsif ($& eq "don't()") {
        $disable++;
    } else {
        $part1 += $1 * $2;
        $part2 += $1 * $2 if !$disable;
    }
}

print "$part1 $part2\n"
