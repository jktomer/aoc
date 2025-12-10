#!/usr/bin/perl

use strict;

my @map = map { [split //] } <>;
my ($startCol) = grep { $map[$0][$_] eq 'S' } 0..$#{$map[0]};
my %cols = ($startCol => 1);

my $part1;

for my $row (1..$#map) {
    my %newCols = ();
    for my $col (keys %cols) {
        if ($map[$row][$col] eq '^') {
            $newCols{$col - 1} += $cols{$col};
            $newCols{$col + 1} += $cols{$col};
            $part1++;
        } else {
            $newCols{$col} += $cols{$col};
        }
    }
    %cols = %newCols;
}

my $part2;
$part2 += $_ for values %cols;

print "$part1 $part2\n";
