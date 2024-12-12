#!/usr/bin/perl
use strict;

my @map = map { [ split(/\n?/) ] } <>;
my %seen;

sub cost($$) {
    my @queue = @_;
    my $crop = $map[$queue[0]][$queue[1]];
    my ($area, $perimeter);

    while (@queue) {
        my ($row, $col) = splice(@queue, 0, 2);
        next if $map[$row][$col] ne $crop;
        next if $seen{"$row:$col"};
        $seen{"$row:$col"} = $crop;
        $perimeter += 4;
        $area++;
        for my $dr (-1..1) {
            next if $row + $dr < 0 or $row + $dr > $#map;
            for my $dc (-1..1) {
                next unless $dr xor $dc;
                next if $col + $dc < 0 or $col + $dc > $#map;
                my ($nr, $nc) = ($row + $dr, $col + $dc);
                if ($seen{"$nr:$nc"} eq $crop) {
                    $perimeter -= 2;
                } else {
                    push @queue, $nr, $nc;
                }
            }
        }
    }
    return $perimeter * $area;
}

my $part1;
for my $row (0..$#map) {
    for my $col (0..$#map) {
        next if $seen{"$row:$col"};
        $part1 += cost($row, $col);
    }
}

print "$part1\n";
