#!/usr/bin/perl

use strict;
use integer;

sub rotate($$$) {
    my ($dx, $dy, $right_turns) = @_;
    while ($right_turns--) {
        ($dx, $dy) = ($dy, -$dx);
    }
    return ($dx, $dy);
}

my ($dx, $dy) = (1, 0);
my ($x, $y) = (0, 0);

my @instructions = <>;
for (@instructions) {
    chomp;
    /N(\d+)/ and $y += $1;
    /S(\d+)/ and $y -= $1;
    /E(\d+)/ and $x += $1;
    /W(\d+)/ and $x -= $1;
    /F(\d+)/ and ($x, $y) = ($x + $dx * $1, $y + $dy * $1);
    /R(\d+)/ and ($dx, $dy) = rotate($dx, $dy, $1 / 90);
    /L(\d+)/ and ($dx, $dy) = rotate($dx, $dy, 4 - $1 / 90);
    # print "$_ ->($x, $y)\n";
}

print abs($x) + abs($y), "\n";

($x, $y, $dx, $dy) = (0, 0, 10, 1);

for (@instructions) {
    /N(\d+)/ and $dy += $1;
    /S(\d+)/ and $dy -= $1;
    /E(\d+)/ and $dx += $1;
    /W(\d+)/ and $dx -= $1;
    /F(\d+)/ and ($x, $y) = ($x + $dx * $1, $y + $dy * $1);
    /R(\d+)/ and ($dx, $dy) = rotate($dx, $dy, $1 / 90);
    /L(\d+)/ and ($dx, $dy) = rotate($dx, $dy, 4 - $1 / 90);
}

print abs($x) + abs($y), "\n";
