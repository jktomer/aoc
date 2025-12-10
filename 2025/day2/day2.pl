#!/usr/bin/perl

use strict;

my $input = <>;
chomp $input;
my @ranges = map { [ split /-/ ] } split /,/, $input;

my ($part1, $part2);

sub sillyTotal(\%) {
    my $ids = shift;
    my $total;
    $total += $_ for keys %$ids;
    #print join(", ", keys %$ids), " -> $total\n" if $total;
    $total;
}

sub sillies($$$\%) {
    my ($l, $h, $cycles, $seen) = @_;

    my $sillyLow;
    # can't have a silly id that doesn't divide the length, so pad with
    # zeroes, but leading zeroes aren't IDs at all, so go up to the next power
    # of ten
    if (length($l) % $cycles) {
        $sillyLow = 1 . 0 x (length($l)/$cycles);
    } else {
        $sillyLow = substr($l, 0, length($l)/$cycles);
    }

    if ("$sillyLow" x $cycles < $l) {
        $sillyLow++;
    }

    my $sillyHigh;
    # can't have a silly id that doesn't divide the length, so drop to the longest sequence of 9s that does
    if (length($h) % $cycles) {
        $sillyHigh = 9 x (length($h)/$cycles);
    } else {
        $sillyHigh = substr($h, 0, length($h)/$cycles);
    }
    while ("$sillyHigh" x $cycles > $h) {
        $sillyHigh--;
    }

    return if $sillyLow > $sillyHigh;

    my @new;
    $seen->{$_ x $cycles}++ or push @new, $_ x $cycles for $sillyLow..$sillyHigh;
    return unless scalar @new > 0;
    #print "${l}-${h} has ", scalar @new, " silly IDs of repeat count $cycles: ", join(", ", @new), ($sillyLow > $sillyHigh and scalar @new) ? "?!" : "", "\n";
}

for my $range (@ranges) {
    my ($l, $h) = @$range;
    my %seen;

    sillies $l, $h, 2, %seen;
    $part1 += sillyTotal %seen;

    for my $cycles (3..length($h)) {
        sillies $l, $h, $cycles, %seen;
    }
    $part2 += sillyTotal %seen;
}

print "$part1 $part2\n";
