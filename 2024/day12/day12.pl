#!/usr/bin/perl
use strict;

my @map = map { [ split(/\n?/) ] } <>;
my %seen;

sub valid(@) {
    return not grep { $_ < 0 or $_ > $#map } @_;
}

sub haveWall(\%$$) {
    my ($walls, $wallKey, $crossPos) = @_;
    return undef unless exists $walls->{$wallKey};
    return grep { $_->[0] <= $crossPos and $_->[1] > $crossPos } @{$walls->{$wallKey}};
}

sub removeWall(\%$$) {
    my ($walls, $wallKey, $crossPos) = @_;
    die "removing nonexistent wall $wallKey" unless exists $walls->{$wallKey};
    my $segments = $walls->{$wallKey};
    for my $i (0..$#$segments) {
        my $s = $segments->[$i];
        if ($s->[0] > $crossPos) {
            die "removing nonexistent wall $wallKey:$crossPos";
        }
        next if $s->[1] <= $crossPos;
        my @newSegments;
        push @newSegments, [$s->[0], $crossPos, $s->[2]] if $s->[0] < $crossPos;
        push @newSegments, [$crossPos + 1, $s->[1], $s->[2]] if $s->[1] > $crossPos + 1;
        splice @$segments, $i, 1, @newSegments;
        delete $walls->{$wallKey} unless @$segments;
        return;
    }
}

sub insertWall(\%$$$) {
    my ($walls, $wallKey, $crossPos, $side) = @_;
    my $newSegment = [$crossPos, $crossPos + 1, $side];
    unless (exists $walls->{$wallKey}) {
        $walls->{$wallKey} = [ $newSegment ];
        return;
    }
    my $segments = $walls->{$wallKey};
    for my $i (reverse 0..$#$segments) {
        my $candidate = $segments->[$i];
        if ($candidate->[1] == $newSegment->[0] and $candidate->[2] == $side) {
            # we've found a segment we can merge into on our left; we're done
            $candidate->[1] = $newSegment->[1];
            return;
        } elsif ($candidate->[1] <= $newSegment->[0]) {
            # either there's a gap or we're butted up against the next segment but on the opposite side; insert here
            splice @$segments, $i + 1, 0, $newSegment;
            return;
        } elsif ($candidate->[0] == $newSegment->[1] and $candidate->[2] == $side) {
            # haven't found our insertion spot yet, but this segment can merge onto *us*; absorb and delete it
            $newSegment->[1] = $candidate->[1];
            splice @$segments, $i, 1;
        } elsif ($candidate->[0] < $newSegment->[1]) {
            # this is a span that includes the spot we're trying to add?!
            die "attempting to insert duplicate wall at $wallKey:$crossPos";
        }
    }
    # if we made it here, we have the new leftmost segment
    splice @$segments, 0, 0, $newSegment;
}

sub cost {
    my @queue = ([@_]);
    my $crop = $map[$_[0]][$_[1]];
    my ($area, %walls);    # walls: [orientation, coord] -> sorted list of ranges with the side we're on
    my $nextSide = 1;

    while (@queue) {
        my $loc = shift @queue;
        my ($row, $col) = @$loc;
        next unless valid @$loc;
        next if $map[$row][$col] ne $crop;
        next if $seen{"$row:$col"};
        $seen{"$row:$col"} = $crop;
        $area++;

        for my $coord (0, 1) {
            for my $offset (0, 1) {
                my @neighborLoc = @$loc;
                $neighborLoc[$coord] += $offset || -1;
                push @queue, \@neighborLoc;

                my $wallPos = $loc->[$coord] + $offset;
                my $crossPos = $loc->[1 - $coord];
                my $wallKey = "$coord:$wallPos";

                # if there's already a wall here, we're on both sides of it; delete it
                if (haveWall %walls, $wallKey, $crossPos) {
                    removeWall %walls, $wallKey, $crossPos;
                } else {
                    # insert a wall, noting which side we're on for appropriate merging
                    insertWall %walls, $wallKey, $crossPos, $offset;
                }
            }
        }
    }

    my ($perimeter, $totalSides);
    for my $wall (values %walls) {
        $totalSides += @$wall;
        $perimeter += $_->[1] - $_->[0] for @$wall;
    }
    return ($area * $perimeter, $area * $totalSides);
}

my ($part1, $part2);
for my $row (0..$#map) {
    for my $col (0..$#map) {
        next if $seen{"$row:$col"};
        my ($c1, $c2) = cost($row, $col);
        $part1 += $c1;
        $part2 += $c2;
    }
}

print "$part1\n$part2\n";
