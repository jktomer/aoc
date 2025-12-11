#!/usr/bin/perl

use PDL;
use PDL::NiceSlice;
use PDL::Opt::GLPK;

use strict;

sub lights($\@) {
    my ($target, $buttons) = @_;
    my @q = ([ 0, "." x length($target) ]);
    my %seen;

    while (@q) {
        my ($cost, $here) = @{shift @q};
        return $cost if $here eq $target;
        next if $seen{$here}++;

        for my $b (@$buttons) {
            my $next = $here;
            for my $i (@$b) {
                substr $next, $i, 1, chr(81 - ord(substr $next, $i, 1));
            }
            push @q, [$cost + 1, $next];
        }
    }
    die "no path to $target using ", join(", ", map { "(" . join(", ", @$_) . ")" } @$buttons), "\n";
}

sub joltage(\@\@) {
    my ($joltages, $buttons) = @_;
    my $nb = scalar @$buttons;
    my $nj = scalar @$joltages;

    # objective function c; metric is c'x. we just want the sum
    my $c = ones($nb);

    # constraint coefficients matrix; A_ij=1 means button j increments counter i, but note that PDL calls this A->(j, i)
    # $buttons[j] contains the list of i such that A_ij should be 1, so for
    # each inner list we slice out the column with that index and broadcast to
    # the rows named in the list
    my $A = zeroes $nb, $nj;
    $A->(($_), pdl $buttons->[$_]) .= 1 for 0..$nb-1;

    # constraints vector (target joltages)
    my $b = pdl @$joltages;

    # bounds: all values must be >=0, and we have an implicit upper bound of the highest joltage
    my $lb = zeroes($nb);
    my $ub = ones($nb) * max $b;

    my $ctypes = ones($nj) * GLP_FX; # all constraints are equality constraints
    my $vtypes = ones($nb) * GLP_IV; # all results must be integers

    my ($res, $status) = (null, null);
    glpk($c, $A, $b, $lb, $ub, $ctypes, $vtypes, GLP_MIN, null, $res, $status);

    if ($status != GLP_OPT) {
        die "status was $status\n";
    }
    return $res->at(0);
}

my ($part1, $part2);
while (<>) {
    my ($lights, $buttons, $joltage) = /^\[([.#]*)] ([()0-9, ]*) {([0-9,]*)}/ or die "invalid input";
    $buttons =~ y/()//d;
    my @buttons = map { [ split ',' ] } split ' ', $buttons;
    my @joltage = split(',', $joltage);

    $part1 += lights $lights, @buttons;
    $part2 += joltage @joltage, @buttons;
}

print "$part1 $part2\n";
