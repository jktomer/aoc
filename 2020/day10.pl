#!/usr/bin/perl
use strict;

my @ratings = <>;
@ratings = sort { $a <=> $b } @ratings;

my $last = 0;
my ($ones, $threes);
for my $rating (@ratings) {
    die "i don't understand: $last $rating\n" if $rating - $last > 3;
    $ones++ if $rating - $last == 1;
    $threes++ if $rating - $last == 3;
    $last = $rating;
}

$threes++;
print "$ones $threes ", $ones * $threes, "\n";

my %ratings = map { $_ + 0 => 1 } @ratings;
my %cache; # jolts -> ways

sub ways($) {
    my $jolts = shift;

    return 1 if $jolts == $ratings[-1];
    return $cache{$jolts} if exists $cache{$jolts};

    my $ways = 0;
    for my $bump ($jolts + 1 .. $jolts + 3) {
        $ways += ways($bump) if $ratings{$bump};
    }
    $cache{$jolts} = $ways;
}

print ways(0), "\n";
