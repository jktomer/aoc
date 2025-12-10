#!/usr/bin/perl

use strict;

my @input = <>;
chomp for @input;
my ($part1, $part2);

my @wrongInput = map { [ split ] } @input;
for my $col (0..$#{$wrongInput[0]}) {
    my @row = map { $_->[$col] } @wrongInput;
    my $op = pop @row;
    while ($#row > 0) {
        if ($op eq '+') {
            $row[0] += pop @row;
        } elsif ($op eq '*') {
            $row[0] *= pop @row;
        } else {
            die "unrecognized op $op in column $col\n";
        }
    }
    $part1 += $row[0];
}

my @operands;
@input = map { [ split // ] } @input;
my $width;
$width < $#{$_} and $width = $#{$_} for @input;

for (my $col = $width; $col >= 0; $col--) {
    my $n;
    for my $row(0..$#input-1) {
        next unless $input[$row][$col] + 0 eq $input[$row][$col];
        $n = $n * 10 + $input[$row][$col];
    }
    push @operands, $n if $n;

    my $op = $input[-1][$col];

    next unless $op =~ /[+*]/;
    while ($#operands > 0) {
        if ($op eq '+') {
            $operands[0] += pop @operands;
        } elsif ($op eq '*') {
            $operands[0] *= pop @operands;
        } else {
            die "unrecognized op $op in column $col\n";
        }
    }

    $part2 += pop @operands;
}

print "$part1 $part2\n";
