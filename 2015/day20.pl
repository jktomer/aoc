#!/usr/bin/perl

use strict;

my $target = shift;

my @houses;
for my $elf (1..($target / 10)) {
    for (my $mul = 1; $elf * $mul <= $target / 10; $mul++) {
        my $house = $elf * $mul;
        $houses[$house] += 10 * $elf;
    }
}

for my $i (0..$#houses) {
    if ($houses[$i] >= $target) {
        print "$i\n";
        last;
    }
}
                               
@houses =();
for my $elf (1..$target / 10) {
    for my $mul (1..50) {
        my $house = $elf * $mul;
        $houses[$house] += 11 * $elf;
    }
}

for my $i (0..$#houses) {
    if ($houses[$i] >= $target) {
        print "$i\n";
        last;
    }
}
                               
