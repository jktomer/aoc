#!/usr/bin/perl
use strict;

my $towels = <>;
chomp $towels;
my %towels = map { $_ => 1 } split(/,\s*/m, $towels);

my %knownPossible;
sub possible($);
sub possible($) {
    my $pattern = shift;
    return 1 unless $pattern;
    return $knownPossible{$pattern} if exists $knownPossible{$pattern};

    for my $l (1..length $pattern) {
        next unless $towels{substr($pattern, 0, $l)};
        $knownPossible{$pattern} += possible(substr($pattern, $l));
    }
    return $knownPossible{$pattern};
}

my ($possible, $ways);

while (<>) {
    chomp;
    next unless $_;
    my $w = possible($_);
    $possible++ if $w;
    $ways += $w;
}
print "$possible\n$ways\n";
