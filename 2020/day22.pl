#!/usr/bin/perl

use strict;
use feature 'say';

$/ = '';
my @deck1 = split("\n", <>);
my @deck2 = split("\n", <>);
shift @deck1;
shift @deck2;

sub score(@) {
    my @score = map { ($_+1) * $_[$#_-$_] } (0..$#_);
    my $score;
    $score += $_ for @score;
    return $score;
}

sub classic(\@\@) {
    my ($deck1, $deck2) = @_;
    my @deck1 = @$deck1;
    my @deck2 = @$deck2;
    while (@deck1 and @deck2)
    {
        my ($c1, $c2) = (shift @deck1, shift @deck2);
        if ($c1 > $c2)
        {
            push @deck1, $c1, $c2;
        }
        else
        {
            push @deck2, $c2, $c1;
        }
    }
    return @deck1, @deck2;
}
say score(classic(@deck1, @deck2));

sub recursive(\@\@) {
    my ($deck1, $deck2) = @_;

    my @deck1 = @$deck1;
    my @deck2 = @$deck2;

    my %cache;
    while (@deck1 and @deck2) {
        my $cacheKey = "@deck1:@deck2";
        return 1 if exists $cache{$cacheKey};
        $cache{$cacheKey}++;

        my ($c1, $c2) = (shift @deck1, shift @deck2);
        my $p1wins;
        if ($c1 <= @deck1 and $c2 <= @deck2) {
            my @sub1 = @deck1[0..$c1 - 1];
            my @sub2 = @deck2[0..$c2 - 1];
            $p1wins = (recursive(\@sub1, \@sub2) == 1);
        } else {
            $p1wins = ($c1 > $c2);
        }
        if ($p1wins) {
            push @deck1, $c1, $c2;
        } else {
            push @deck2, $c2, $c1;
        }
    }

    if (wantarray) {
        return @deck1, @deck2;
    } else {
        return @deck1 ? 1 : 2;
    }
}
say score(recursive(@deck1, @deck2));
