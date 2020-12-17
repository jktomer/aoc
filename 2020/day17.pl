#!/usr/bin/perl

use strict;
use Clone 'clone';

my %state;
while (<>) {
    chomp;
    my @row = split(//);
    $state{0}{$.-1}{$_} = 1 for grep {$row[$_] eq '#'} (0..$#row);
}

sub step3($) {
    my $in = shift;
    my %out;
    my %neighbors;
    while (my ($z, $plane) = each %$in) {
        while (my ($y, $row) = each %$plane) {
            while (my ($x, $cell) = each %$row) {
                my $neighbors = -$cell;
                for my $zz ($z - 1 .. $z + 1) {
                    for my $yy ($y - 1 .. $y + 1) {
                        for my $xx ($x - 1 .. $x + 1) {
                            next if $xx == $x and $yy == $y and $zz == $z;
                            $neighbors{$zz}{$yy}{$xx}++;
                        }
                    }
                }
            }
        }
    }
    while (my ($z, $plane) = each %neighbors) {
        while (my ($y, $row) = each %$plane) {
            while (my ($x, $nbrs) = each %$row) {
                $out{$z}{$y}{$x} = 1 if $nbrs == 3 or ($nbrs == 2 and $in->{$z}{$y}{$x});
            }
        }
    }
    return \%out;
}

sub step4($) {
    my $in = shift;
    my %out;
    my %neighbors;
    while (my ($w, $cube) = each %$in)
    {
        while (my ($z, $plane) = each %$cube)
        {
            while (my ($y, $row) = each %$plane)
            {
                while (my ($x, $cell) = each %$row)
                {
                    my $neighbors = -$cell;
                    for my $ww ($w - 1 .. $w + 1)
                    {
                        for my $zz ($z - 1 .. $z + 1)
                        {
                            for my $yy ($y - 1 .. $y + 1)
                            {
                                for my $xx ($x - 1 .. $x + 1)
                                {
                                    next if $xx == $x and $yy == $y and $zz == $z and $ww == $w;
                                    $neighbors{$ww}{$zz}{$yy}{$xx}++;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    while (my ($w, $cube) = each %neighbors)
    {
        while (my ($z, $plane) = each %$cube)
        {
            while (my ($y, $row) = each %$plane)
            {
                while (my ($x, $nbrs) = each %$row)
                {
                    $out{$w}{$z}{$y}{$x} = 1 if $nbrs == 3 or ($nbrs == 2 and $in->{$w}{$z}{$y}{$x});
                }
            }
        }
    }
    return \%out;
}

my $state4 = { 0 => clone(\%state) };

my $state3 = \%state;
for my $i (1..6) {
    $state3 = step3($state3);
    $state4 = step4($state4);
}
my $on3 = map { map { values %$_ } values %$_ } values %$state3;
my $on4 = map { map { map { values %$_ } values %$_ } values %$_ } values %$state4;
print "$on3 $on4\n";
