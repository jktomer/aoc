#!/usr/bin/perl

use strict;

my ($part1, $part2);

sub joltage($@) {
    my $len = shift;
    my $res;

    for my $i (1..$len) {
        my $max = (sort { $b <=> $a } @_[0..$#_-($len-$i)])[0];
        $res .= $max;
        1 while shift @_ != $max;
    }
    return $res;
}

while (<>) {
    chomp;
    my @digits = split(//);
    $part1 += joltage 2, @digits;
    $part2 += joltage 12, @digits;
}

print "$part1 $part2\n";
