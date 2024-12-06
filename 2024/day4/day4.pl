#!/usr/bin/perl

# three extra columns and rows means we don't have to bounds check
# don't need them at the top and left because perl handles negative indices with wraparound
my @chars = map { [ split(//), qw/. . ./ ] } <>;
push @chars, [], [], [];

my ($h, $w) = (scalar @chars, scalar @{$chars[0]});
my ($part1, $part2);
for my $r (0..$h - 1) {
    my @row = @{$chars[$r]};
    for my $c (0..$w - 1) {
        for my $dr (-1..1) {
            for my $dc (-1..1) {
                next unless $dr or $dc;
                $part1++ if join('', map { $chars[$r + $_ * $dr][$c + $_ * $dc] } (0..3)) eq 'XMAS';
                $part2++ if $dr and $dc and
                    join('', map { $chars[$r + $_ * $dr][$c + $_ * $dc] } (-1..1)) eq 'MAS' and
                    join('', map { $chars[$r + $_ * $dc][$c - $_ * $dr] } (-1..1)) eq 'MAS';
            }
        }
    }
}

print "$part1\n$part2\n";
