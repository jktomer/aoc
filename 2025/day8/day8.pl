#!/usr/bin/perl

use strict;
use Time::HiRes qw(gettimeofday tv_interval);

# my $start = [gettimeofday];

my $count = shift;

my @boxes = map {  [ map { $_+0 } split /,/ ] } <>;
my %circuits = map { $_ => [ $_ ] } 0..$#boxes;

sub distsq($) {
    my ($x, $y) = @{$_[0]};
    my @ds = map { $_ * $_ } map { $boxes[$x][$_] - $boxes[$y][$_] } 0..2;
    return $ds[0] + $ds[1] + $ds[2];
}

my @connections = map { $_->[0] } sort { $a->[1] <=> $b->[1] } map { [ $_, distsq $_ ] } map { my $i = $_; map { [ $_, $i ] } 0..$i-1 } 0..$#boxes;

my $nCircuits = @boxes;

for my $i (0..$#connections) {
    if ($i == $count) {
        my @circuitSizes;
        for my $k (keys %circuits) {
            next unless $k == $circuits{$k}[0];
            push @circuitSizes, scalar @{$circuits{$k}};
        }
        @circuitSizes = sort { $b <=> $a } @circuitSizes;
        print $circuitSizes[0] * $circuitSizes[1] * $circuitSizes[2], "\n";
    }

    my ($l, $r) = @{$connections[$i]};
    next if $circuits{$l} == $circuits{$r};

    @{$circuits{$l}} = sort { $a <=> $b } (@{$circuits{$l}}, @{$circuits{$r}});
    $circuits{$_} = $circuits{$l} for @{$circuits{$r}};
    if (--$nCircuits == 1) {
        print $boxes[$l][0] * $boxes[$r][0], "\n";
    }
}
