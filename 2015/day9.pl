#!/usr/bin/perl

use Data::Dumper;

our %dist;
our %places;

while (<>) {
    my ($a, $b, $dist) = /^(\w+) to (\w+) = (\d+)$/;
    $dist{"$a$b"} = $dist{"$b$a"} = $dist;
    $places{$a} = $places{$b} = 1;
}

sub cost($%) {
    my ($here, %remaining) = @_;
    
    my $min;
    my $max;
    for my $next (keys %remaining) {
        my %then = %remaining;
        delete %then{$next};
        my ($mincost, $maxcost) = cost($next, %then);
        $mincost += $dist{"$here$next"}; $maxcost += $dist{"$here$next"};
        $min = $mincost unless defined $min and $min < $mincost;
        $max = $maxcost unless defined $max and $max > $maxcost;
    }
    return ($min, $max);
}

print join(", ", cost("", %places)), "\n";
