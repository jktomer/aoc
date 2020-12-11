#!/usr/bin/perl

use strict;
use integer;

my ($input, $width, $height);
    
while (<>) {
    chomp;
    $width = length;
    $height++;
    $input .= $_;
}

sub neighborIndex($$$$) {
    my ($input, $w, $h, $maxdist, $tol) = @_;
    my @output = map { [] } length($input);
    
    for (my $i = 0; $i < length $input; $i++) {
        next if substr($input, $i, 1) eq '.'; # floors don't need neighbor checks
        my ($x, $y) = ($i % $w, $i / $w);
        for my $dy (-1 .. 1) {
        DIR:
            for my $dx (-1 .. 1) {
                next DIR unless $dy or $dx;
                my ($xx, $yy) = ($x, $y);
                for my $dist (1..$maxdist) {
                    $xx += $dx;
                    $yy += $dy;
                    next DIR if $xx < 0 or $xx >= $w or $yy < 0 or $yy >= $h;
                    next if substr($input, $yy * $w + $xx, 1) eq '.';
                    push @{$output[$i]}, $yy * $w + $xx;
                    next DIR;
                }
            }
        }
    }
    return @output;
}

sub advance($\@$) {
    my ($input, $neighborIndex, $tol) = @_;
    my $output;
    
    for (my $i = 0; $i < length $input; $i++) {
        my $c = substr($input, $i, 1);
        if ($c eq '.') {
            $output .= '.';
            next;
        }

        my $neighbors;
        for my $j (@{$neighborIndex->[$i]}) {
            my $o = substr($input, $j, 1);
            $neighbors++ if $o eq '#';
        }
        if ($c eq 'L') {
            $output .= $neighbors ? 'L' : '#';
        } else {
            $output .= $neighbors >= $tol ? 'L' : '#';
        }
    }
    return $output;
}

sub compute($$$$$) {
    my ($state, $w, $h, $maxdist, $tol) = @_;
    my $oldstate;
    my @neighborIndex = neighborIndex($state, $w, $h, $maxdist);
    while ($oldstate ne $state) {
        $oldstate = $state;
        $state = advance($oldstate, @neighborIndex, $tol);
    }
    $state =~ y/#//cd;
    return length $state;
}

print compute($input, $width, $height, 1, 4), "\n";
print compute($input, $width, $height, $width + $height, 5), "\n";
