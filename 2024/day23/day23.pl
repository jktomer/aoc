#!/usr/bin/perl
use strict;

my %connections;
while (<>) {
    chomp;
    /(..)-(..)/;
    $connections{$1} = {} unless exists $connections{$1};
    $connections{$2} = {} unless exists $connections{$2};
    $connections{$1}{$2} = $connections{$2}{$1} = 1;
}

my %tccs;
for my $a (keys %connections) {
    next unless $a =~ /^t/;
    for my $b (keys %{$connections{$a}}) {
        for my $c (keys %{$connections{$b}}) {
            $tccs{join(",", sort ($a, $b, $c))}++ if $a ne $c and $connections{$a}{$c};
        }
    }
}

print scalar keys %tccs, "\n";

my $max = 0;
keys %$_ > $max and $max = keys %$_ for values %connections;

my @nodes = sort keys %connections;

sub clique($@);
sub clique($@) {
    my ($needed, @soFar) = @_;
    return @soFar if @soFar >= $needed;
    return if @soFar and $#nodes - $soFar[-1] < $needed;
 Candidate:
    for my $next ($soFar[-1]..$#nodes) {
        for my $member (@soFar) {
            next Candidate unless $connections{$nodes[$member]}{$nodes[$next]};
        }
        my @res = clique($needed, @soFar, $next);
        return @res if @res == $needed;
    }
}

for my $size (reverse 1..$max) {
    my @clique = clique $size;
    if (@clique) {
        print join(",", map { $nodes[$_] } @clique), "\n";
        exit;
    }
}
