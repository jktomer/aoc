#!/usr/bin/perl

my $turns = 2020;
my @starts = split(/,/, <>);
my @latest;
$latest[$starts[$_]] = $_+1 for (0..$#starts - 1);
my $next = $starts[-1];
for (my $time = scalar @starts; $time <= 30000001; $time++) {
    print "$next\n" if $time == 2020 or $time == 30000000;
    my $age = $latest[$next];
    $age = $time - $age if $age;
    $latest[$next] = $time;
    $next = $age;
}
