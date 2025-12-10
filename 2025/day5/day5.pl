#!/usr/bin/perl

use strict;
my ($part1, $part2);

my @fresh;

# invariant: @fresh is an ordered list of *disjoint* ranges r_i = [s_i, e_i]
# to insert [s, e], we find range r_i, the first range that ends after (or adjacent to) s,
# and range r_j, the first range that starts after (and not adjacent to) e,
# and replace ranges [r_i, r_j) with the single range [min(s, s_i), max(e, e_{j-1])]
# note that [i, j) may be an empty interval, in which case we're just inserting before i
while (<>) {
    chomp;
    my ($s, $e) = /^(\d+)-(\d+)$/ or last;

    my ($ri, $rj);
    for my $i (0..$#fresh) {
        if ($fresh[$i][1] >= $s - 1 and not defined $ri) {
            $ri = $i;
            $s = $fresh[$i][0] if $fresh[$i][0] < $s;
        }
        if ($fresh[$i][0] > $e + 1 and not defined $rj) {
            $rj = $i;
            $e = $fresh[$i-1][1] if $i > 0 and $fresh[$i-1][1] > $e;
        }
        last if defined $ri and defined $rj;
    }
    if (not defined $ri) {
        $ri = $#fresh + 1;
    }
    if (not defined $rj) {
        $rj = $#fresh + 1;
        $e = $fresh[-1][1] if $#fresh >= 0 and $fresh[-1][1] > $e;
    }

    splice @fresh, $ri, $rj - $ri, [$s, $e];
}

for my $range (@fresh) {
    # print "[$range->[0], $range->[1]]\n";
    $part2 += $range->[1] + 1 - $range->[0];
}

while (<>) {
    chomp;
    for my $range (@fresh) {
        next if $_ > $range->[1];
        last if $_ < $range->[0];

        $part1++;
        last;
    }
}

print "$part1 $part2\n";
