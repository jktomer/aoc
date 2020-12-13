#!/usr/bin/perl

use strict;

my $ts = <>;
my @ids = split(/,/, <>);
chomp for @ids;

my ($minTime, $minId);
for my $id (@ids) {
    use integer;
    next if $id eq 'x';
    my $nextTime = $id * (($ts + $id - 1) / $id);
    next if defined $minTime and $minTime < $nextTime;
    ($minTime, $minId) = ($nextTime, $id);
}

my $part1 = (($minTime - $ts) * $minId);
print "$part1\n";

my @mods = map { [ -$_->[0] % $_->[1], $_->[1] ] } sort { $b->[0] <=> $a->[0] } grep { $_->[1] ne 'x' } map { [ $_, $ids[$_] ] } (0..$#ids);
print join("; ", map { join(", ", @$_) } @mods), "\n";
# exit 0;

# invariant $t % $mods[j][1] == $mods[j][0] forall j < i; $incr = $mods[0][1] * ... * $mods[i-1][1]
my $t = $mods[0][0];
my $incr = $mods[0][1];
shift @mods;
for my $mod (@mods) {
    $t += $incr until $t % $mod->[1] == $mod->[0];
    $incr *= $mod->[1];
}

print "$t\n";
