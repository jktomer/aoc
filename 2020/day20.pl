#!/usr/bin/perl

use strict;
use Data::Dumper "Dumper";
use feature 'say';

$/ = '';
our %edge_cell;
our %cells;
while (<>) {
    my @rows = split('\n');
    my $id = shift @rows;
    ($id) = ($id =~ /(\d+)/);

    $cells{$id}{id} = $id;
    $cells{$id}{contents} = [ map { substr $_, 1, length($_)-2 } @rows[1..$#rows-1] ];

    # edges are read clockwise (L->R on top, R->L on bottom)
    my $top = $rows[0];
    my $bot = reverse $rows[-1];
    my $left = reverse join("", map { substr($_, 0, 1) } @rows);
    my $right = join("", map { substr($_, -1, 1) } @rows);
    my %borders = (T => $top, B => $bot, L => $left, R => $right);
    while (my ($side, $edge) = each %borders) {
        $edge_cell{$edge}{$id} = $side;
        $cells{$id}{$side} = $edge;
    }
}

# Find the cell that lines up with the given edge, if any.
# Return value is undef if the edge is exterior, or (cell ID, edge side, is flipped).
sub match($$) {
    my ($id, $edge) = @_;
    my $direct = $edge_cell{$edge};
    if ($direct) {
        my %direct = %$direct;
        delete $direct{$id};
        return %direct, 1 if %direct;
    }
    my $reverse = $edge_cell{reverse $edge};
    if ($reverse) {
        my %reverse = %$reverse;
        delete $reverse{$id};
        return %reverse;
    }
}

# Return the corner cell (one with two exterior edges), and which edges are
# the exterior ones.
sub findACorner() {
    for my $cell (sort { $a->{id} <=> $b->{id} } values %cells) {
        my @exteriorSides;
        for my $side (qw/T L R B/) {
            next if match($cell->{id}, $cell->{$side});
            push @exteriorSides, $side;
            return $cell->{id}, join("", sort @exteriorSides) if @exteriorSides == 2;
        }
    }
}

# Given a cell and a number of clockwise rotations, returns an appropriately rotated copy.
my @EDGE_ORDER = qw/T R B L/;
my %EDGE_ORDER = map { $EDGE_ORDER[$_] => $_ } (0..$#EDGE_ORDER);
sub rotate(+$) {
    my ($cell, $rotations) = @_;
    my %cell = %$cell;
    my @contents = @{$cell{contents}};
    for my $i (1..$rotations) {
        @contents = map {
            my $row = $_;
            join("", reverse map { substr($_, $row, 1) } @contents)
        } (0..$#contents);
        @cell{qw/T R B L/} = @cell{qw/L T R B/};
    }
    $cell{contents} = \@contents;
    $cell{rotated} = $rotations;
    return %cell;
}

# Given a cell, return a horizontally flipped copy.
sub hflip(+) {
    my $cell = shift;
    my %cell = %$cell;
    @cell{qw/R L/} = map { scalar reverse } @cell{qw/L R/};
    @cell{qw/T B/} = map { scalar reverse } @cell{qw/T B/};
    $cell{contents} = [ map { scalar reverse } @{$cell{contents}} ];
    $cell{flipped} .= "h";
    return %cell;
}

# Given a cell, return a vertically flipped copy.
sub vflip(+) {
    my $cell = shift;
    my %cell = %$cell;
    @cell{qw/T B/} = map { scalar reverse } @cell{qw/B T/};
    @cell{qw/R L/} = map { scalar reverse } @cell{qw/R L/};
    $cell{contents} = [ reverse @{$cell{contents}} ];
    $cell{flipped} .= "v";
    return %cell;
}

sub fmt(+) {
    my $cell = shift;
    sprintf "%4d+%01d%-2s", $cell->{id}, $cell->{rotated}, $cell->{flipped};
}

sub monsters(\@) {
    my $image = shift;
    my $monsters;
 LINE:
    for my $midline (1..$#$image-1) {
        while ($image->[$midline] =~ /#....##....##....###/og) {
            my $snout = pos $image->[$midline];
            next unless substr($image->[$midline-1], $snout - 2, 1) eq '#';
            next unless substr($image->[$midline+1], $snout - 19, 16) =~ /#..#..#..#..#..#/;
            $monsters++;
        }
    }
    return $monsters;
}

my %CORNER_MAPPING = (LT => 0, BL => 1, BR => 2, RT => 3);
my ($id, $outsides) = findACorner();
my $rotations = $CORNER_MAPPING{$outsides};
my %cell = rotate($cells{$id}, $rotations);
my @image = @{$cell{contents}};
my @usedCells = ([$id]);
my %used = ($id => 1);
my $part1 = 1;

while () {
    my %leftCell = %cell;
    my %rightCell;
    while () {
        my ($nextId, $side, $flip) = match($cell{id}, $cell{R});
        last unless $nextId;
        push @{$usedCells[-1]}, $nextId;
        die "double-use of cell $nextId" if $used{$nextId};
        $used{$nextId} = 1;
        my $rotations = ($EDGE_ORDER{L} - $EDGE_ORDER{$side}) % 4;
        %cell = rotate($cells{$nextId}, $rotations);
        %cell = vflip(%cell) if $flip;
        $image[-$_] .= $cell{contents}[-$_] for (1..@{$cell{contents}});
    }
    die "mismatched rows\n" if length($image[-1]) != length($image[0]);
    my ($nextRow, $side, $flip) = match($leftCell{id}, $leftCell{B});
    last unless $nextRow;
    push @usedCells, [$nextRow];
    die "double-use of cell $nextRow" if $used{$nextRow};
    $used{$nextRow} = 1;
    my $rotations = ($EDGE_ORDER{T} - $EDGE_ORDER{$side}) % 4;
    %cell = rotate($cells{$nextRow}, $rotations);
    %cell = hflip(%cell) if $flip;
    push @image, @{$cell{contents}};
}

my $monsters;
my $roughness;
$roughness += y/#/#/ for @image;
for (1..4) {
    last if $monsters = monsters(@image);
    @image = reverse @image;
    last if $monsters = monsters(@image);
    @image = map { my $row = $_; join("", map { substr($_, $row, 1) } @image) } 0..$#image;
}
say $usedCells[0][0] * $usedCells[0][-1] * $usedCells[-1][0] * $usedCells[-1][-1];
say "[$monsters] ", $roughness - 15 * $monsters;
