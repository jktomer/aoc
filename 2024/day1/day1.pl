#!/usr/bin/perl

use strict;

my (@a, @b, %b);

while (<>) {
    my ($a, $b) = split;
    push @a, $a;
    push @b, $b;
    $b{$b}++;
}

@a = sort { $a <=> $b } @a;
@b = sort { $a <=> $b } @b;

my ($part1, $part2);
for my $i (0..$#a) {
    $part1 += abs($a[$i] - $b[$i]);
    $part2 += $a[$i] * $b{$a[$i]}
}

print "$part1 $part2\n";
