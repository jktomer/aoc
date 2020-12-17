#!/usr/bin/perl

use strict;
use Clone 'clone';

my (%state3, %state4);
while (<>) {
    chomp;
    my @row = split(//);
    $state3{"0," . ($.-1) . ",$_"} = 1 for grep {$row[$_] eq '#'} (0..$#row);
    $state4{"0,0," . ($.-1) . ",$_"} = 1 for grep {$row[$_] eq '#'} (0..$#row);
}

sub step($%) {
    my ($dims, %in) = @_;
    my %out;
    my %neighbors;
    for my $coords (keys %in) {
        my @coords = split(/,/, $coords);
        my @neighborCoords = ("");
        for my $dim (0..$dims - 1)
        {
            @neighborCoords = map { my $prefix = length($_) ? "$_," : '' ; map { "$prefix$_" } ($coords[$dim]-1..$coords[$dim]+1) } @neighborCoords;
        }
        $neighbors{$_}++ for @neighborCoords;
        $neighbors{$coords}--;
    }
    while (my ($coords, $nbrs) = each %neighbors) {
        $out{$coords} = 1 if $nbrs == 3 or ($nbrs == 2 and $in{$coords});
    }
    return %out;
}

for my $i (1..6) {
    %state3 = step(3, %state3);
    %state4 = step(4, %state4);
}
my $on3 = values %state3;
my $on4 = values %state4;
print "$on3 $on4\n";
