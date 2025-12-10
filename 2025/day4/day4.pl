#!/usr/bin/perl

use strict;
use Clone 'clone';

my @map = map { [split //] } <>;

sub remove() {
    my $ret;

    my @newmap = @{clone \@map};
    for my $r (0..$#map) {
        for my $c (0..$#{$map[$r]}) {
            next unless $map[$r][$c] eq '@';
            my $neighbors = -1;     # don't count center
            for my $dr (-1..1) {
                for my $dc (-1..1) {
                    $neighbors++ if $r + $dr >= 0 and $c + $dc >= 0 and $map[$r+$dr][$c+$dc] eq '@';
                }
            }
            next if $neighbors >= 4;
            $ret++;
            $newmap[$r][$c] = 'x';
        }
    }
    @map = @newmap;
    return $ret;
}

my $part1 = remove;
my $part2 = $part1;
while (my $step = remove) {
    $part2 += $step;
}

print "$part1 $part2\n";
