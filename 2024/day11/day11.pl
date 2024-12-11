#!/usr/bin/perl
use strict;

$_ = <>;
chomp;
my @stones = split;

my %memo;
sub step($$);
sub step($$) {
    my ($start, $steps) = @_;
    my $memoized = $memo{"$start:$steps"};
    return $memoized if defined $memoized;

    my $res;
    if ($steps == 0) {
        $res = 1;
    } elsif ($start == 0) {
        $res = step(1, $steps - 1);
    } elsif (length($start) % 2 == 0) {
        $res = step(substr($start, 0, length($start)/2) + 0, $steps - 1)
            + step(substr($start, length($start)/2) + 0, $steps - 1);
    } else {
        $res = step($start * 2024, $steps - 1);
    }
    $memo{"$start:$steps"} = $res;
    return $res;
}

sub stones($@) {
    my $steps = shift;
    my $total;
    for my $stone (@_) {
        $total += step($stone, $steps);
    }
    return $total;
}

print stones(25, @stones), "\n";
print stones(75, @stones), "\n";
