#!/usr/bin/perl

use strict;
use feature qw/say/;

our %DX = (e => 2, w => -2, ne => 1, se => 1, nw => -1, sw => -1);
our %DY = (ne => 1, se => -1, nw => 1, sw => -1);
my %blacktiles;
while (<>) {
    my ($x, $y);
    while (/[ns]?[ew]/g) {
        $x += $DX{$&};
        $y += $DY{$&};
    }
    if ($blacktiles{"$x:$y"}) {
        delete $blacktiles{"$x:$y"};
    } else {
        $blacktiles{"$x:$y"} = 1;
    }
    # say "$x, $y";
}
say scalar keys %blacktiles;

sub neighbors($) {
    my ($x, $y) = split(/:/, shift);
    my @neighbors;
    for my $dir (keys %DX) {
        my $xx = $x + $DX{$dir};
        my $yy = $y + $DY{$dir};
        push @neighbors, "$xx:$yy";
    }
    return @neighbors;
}

sub hexlife($) {
    my $in = shift;
    my %neighbors;
    for my $coords (keys %$in) {
        for my $neighbor (neighbors($coords)) {
            $neighbors{$neighbor}++;
        }
    }
    while (my ($coords, $neighbors) = each %neighbors) {
        delete $neighbors{$coords} unless $neighbors == 2 or ($neighbors == 1 and $in->{$coords});
    }
    return \%neighbors;
}

my $state = \%blacktiles;
for my $i (1..100) {
    $state = hexlife($state);
}
say scalar keys %$state;
