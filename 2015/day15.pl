#!/usr/bin/perl

while (<>) {
    my ($ing, $props) = split(/: /);
    my @props = map { /([0-9-]+)/ } split(/, /, $props);
    push @ingredients, \@props;
}

my $counting_calories;

sub score(@) {
    return 0 if grep { $_ < 0 } @_;
    return 0 if $counting_calories and $_[4] != 500;
    my $t = 1;
    $t *= $_ for @_[0..3];
    return $t;
}

sub work($$@) {
    my ($accum, $room, @remaining) = @_;
    return score(@$accum) unless @remaining;
    my $ingredient = pop @remaining;
    my $best;
    my $min = 0;
    $min = $room unless @remaining;
    for my $quantity ($min..$room) {
        my @newaccum = map { $accum->[$_] + $quantity * $ingredient->[$_] } (0..$#$ingredient);
        my $value = work(\@newaccum, $room - $quantity, @remaining);
        $best = $value unless defined $best and $best > $value;
    }
    return $best;
}

print work([], 100, @ingredients), "\n";
$counting_calories = 1;
print work([], 100, @ingredients), "\n";
