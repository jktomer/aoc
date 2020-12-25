#!/usr/bin/perl

use strict;
use feature 'say';

my @pubKeys = <>;

my $v = 1;
my $subj = 7;
my $mod = 20201227;

my $l;
for ($l = 1; $l <= $mod; $l++) {
    $v = $v * $subj % $mod;
    if (grep { $_ == $v } @pubKeys) {
        say "$l, $v";
        last;
    }
}

my ($other) = grep { $_ != $v } @pubKeys;
my $n = 1;
for my $i (1..$l) {
    $n = $n * $other % $mod;
}
say $n;
