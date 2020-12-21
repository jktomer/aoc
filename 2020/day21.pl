#!/usr/bin/perl

use strict;
use feature 'say';
use Data::Dumper;

my %badfood;
my %goodfood;
while (<>) {
    my ($ingredients, $allergens) = /^(.*) \(contains (.*)\)$/ or die "bad input";
    my @ingredients = split(/ /, $ingredients);
    my @allergens = split(/, /, $allergens);
    $goodfood{$_}++ for @ingredients;
    push @{$badfood{$_}}, { map {$_ => 1} @ingredients } for @allergens;
}

my $acted;
do {
    undef $acted;
    while (my ($allergen, $food) = each %badfood) {
        next unless ref $food eq 'ARRAY';
        my @recipes = @$food;
        my @possibilities = keys %goodfood;
        for my $recipe (@recipes) {
            @possibilities = grep { exists $recipe->{$_} } @possibilities;
        }
        die "impossible allergen $allergen" if @possibilities == 0;
        if (@possibilities == 1) {
            $badfood{$allergen} = $possibilities[0];
            delete $goodfood{$possibilities[0]};
            $acted++;
        }
    }
} while ($acted);

my $good = 0;
$good += $_ for values %goodfood;
say scalar grep { ref $_ eq 'ARRAY' } values %badfood;
say $good;
say join(",", map { $badfood{$_} } sort keys %badfood)
