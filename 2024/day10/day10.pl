#!/usr/bin/perl
use strict;

my @map = map { [ split(/\n?/) ] } <>;

sub bfs($$$) {
    my ($part1, @q) = @_;
    my %seen;
    my $score;

    while (@q) {
        my ($r, $c) = splice(@q, 0, 2);
        my $h = $map[$r][$c];
        next if $part1 and $seen{"$r:$c"}++;
        $score++ and next if $h == 9;
        for my $dr (-1..1) {
            next if $r + $dr < 0 or $r + $dr > $#map;
            for my $dc (-1..1) {
                next if $c + $dc < 0 or $c + $dc > $#map;
                next unless $dr xor $dc;
                push @q, $r+$dr, $c+$dc if $map[$r+$dr][$c+$dc] == $h + 1;
            }
        }
    }
    return $score;
}

my ($part1, $part2);
for my $r (0..$#map) {
    for my $c (0..$#map) {
        next if $map[$r][$c] ne '0';
        $part1 += bfs(1, $r, $c);
        $part2 += bfs(0, $r, $c);
    }
}

print "$part1\n$part2\n";
