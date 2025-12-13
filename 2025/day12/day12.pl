#!/usr/bin/perl

use List::Util qw/reduce zip/;

use strict;

my @shapes;
my @areas;

sub read_shape {
    local $/ = "";
    my $shape = <>;
    $shape =~ y/\n//d;
    my @coords = grep { substr($shape, $_, 1) eq '#' } 0..8;

    my %rotations;
    for my $r (0..3) {
        @coords = sort map { 3 * ($_%3) + 2 - $_/3 } @coords;
        $rotations{join("", @coords)} = [map { [ $_ % 3, $_ % 3 ] } @coords];

        @coords = sort map { $_ - 2 * ($_ % 3 - 1) } @coords;
        $rotations{join("", @coords)} = [map { [ $_ % 3, $_ % 3 ] } @coords];
    }

    push @shapes, [ values %rotations ];
    push @areas, scalar @coords;
}

my $part1;

while (<>) {
    if (/:$/) {
        read_shape();
        next;
    }
    my ($width, $height, $items) = /(\d+)x(\d+): ([\d ]*)/;
    my @items = split ' ', $items;
    my $nItems = reduce { $a + $b } @items;

    my $minArea = reduce { $a + $b } map { $_->[0] * $_->[1] } zip \@items, \@areas;
    $part1++ if $width * $height >= $minArea;
}

print "$part1\n";
