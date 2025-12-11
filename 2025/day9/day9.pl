#!/usr/bin/perl

use strict;

my @points = map { chomp; [ split /,/ ] } <>;

my ($part1, $part2) = (-1, -1);

sub check($$) {
    my ($x0, $x1) = sort { $a <=> $b } map { $points[$_][0] } @_;
    my ($y0, $y1) = sort { $a <=> $b } map { $points[$_][1] } @_;
    my $area = ($x1 + 1 - $x0) * ($y1 + 1 - $y0);

    # if any line of the shape crosses our rectangle, it's not acceptable for part 2
    for my $v (0..$#points) {
        my ($vx0, $vx1) = sort { $a <=> $b } map { $points[$_][0] } ($v-1, $v);
        my ($vy0, $vy1) = sort { $a <=> $b } map { $points[$_][1] } ($v-1, $v);
        die "$v $vx0 $vy0 $vx1 $vy1\n" if ($vx0 - $vx1) * ($vy0 - $vy1);

        return ($area, 0) if ($vx1 > $x0 && $vx0 < $x1 && $vy0 < $y1 && $vy1 > $y0)
    }

    return ($area, 1);
}

my ($p2i, $p2j);
for my $i (0..$#points) {
    for my $j ($i + 1..$#points) {
        my ($area, $valid) = check $i, $j;
        $part1 = $area if $area > $part1;
        ($part2, $p2i, $p2j) = ($area, $i, $j) if $area > $part2 and $valid;
    }
}

print "$part1 $part2\n";

my ($xmax, $ymax) = (1, 1);
for my $p (@points) {
    $xmax *= 10 while $xmax < $p->[0];
    $ymax *= 10 while $ymax < $p->[1];
}

exit 0 if !$ENV{WRITE_SVG};

open SVGOUT, ">/tmp/out.svg" or die $!;
print SVGOUT <<"EOH";
<svg xmlns="http://www.w3.org/2000/svg" width="$xmax" height="$ymax" viewBox="0 0 $xmax $ymax">
<rect x="0" y="0" width="$xmax" height="$ymax" fill="white" />
EOH

for my $p (0..$#points) {
    my ($x0, $y0, $x1, $y1) = (@{$points[$p - 1]}, @{$points[$p]});
    print SVGOUT qq[<line x1="$x0" y1="$y0" x2="$x1" y2="$y1" stroke="black" stroke-width="1" stroke-linecap="square" />\n];
}

my ($x0, $x1) = sort { $a <=> $b } map { $points[$_][0] } ($p2i, $p2j);
my ($y0, $y1) = sort { $a <=> $b } map { $points[$_][1] } ($p2i, $p2j);
print SVGOUT qq[<polyline points="$x0, $y0 $x0, $y1 $x1, $y1 $x1, $y0 $x0, $y0" stroke="#800080" fill="none" />\n];
print SVGOUT "</svg>\n";
close SVGOUT;

print "$part1 $part2\n";
