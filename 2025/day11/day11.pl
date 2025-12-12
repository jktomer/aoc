#!/usr/bin/perl

use strict;

my %graph;

while (<>) {
    my ($src, $dests) = /(.*): (.*)/;
    $graph{$src} = [ split ' ', $dests ];
}

my %cache;
sub search($$) {
    my ($start, $end) = @_;
    return 1 if $start eq $end;

    my $key = "$start:$end";
    if (exists $cache{$key}) {
        return $cache{$key};
    }

    my $ret;
    $ret += search($_, $end) for @{$graph{$start}};
    $cache{$key} = $ret;
    return $ret;
}

my $part1 = search "you", "out";

my ($a, $b) = qw/fft dac/;
my $mid = search $a, $b;
if (!$mid) {
    ($a, $b) = ($b, $a);
    $mid = search $a, $b;
}
my $part2 = search("svr", $a) * $mid * search($b, "out");

print "$part1 $part2\n";
