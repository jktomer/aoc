#!/usr/bin/perl

my %antennas;
while (<>) {
    my $row = $. - 1;
    chomp;
    for my $col (0..length() - 1) {
        my $c = substr($_, $col, 1);
        next if $c eq '.';
        $antennas{$c} = [] unless exists $antennas{$c};
        push @{$antennas{$c}}, [$row, $col];
    }
}
my $size = $.;

my (%part1, %part2);
for my $locs (values %antennas) {
    for my $a1 (0..$#$locs) {
        my ($r1, $c1) = @{$locs->[$a1]};
        for my $a2 ($a1 + 1..$#$locs) {
            my ($r2, $c2) = @{$locs->[$a2]};
            my ($dr, $dc) = ($r2 - $r1, $c2 - $c1);
            for my $m (-$size .. $size) {
                my ($ar, $ac) = ($r2 + $m * $dr, $c2 + $m * $dc);
                next unless $ar >= 0 and $ar < $size and $ac >= 0 and $ac < $size;
                $part2{"$ar:$ac"}++;
                $part1{"$ar:$ac"}++ if $m == 1 or $m == -2;
            }
        }
    }
}

print scalar keys %part1, "\n";
print scalar keys %part2, "\n";
