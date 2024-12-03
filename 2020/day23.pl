#!/usr/bin/perl

use strict;
use feature qw/say/;

my $input = <>;
chomp $input;
my ($iters, $count, $iters2) = (100, 1000000, 10000000);

## part 1

sub rotate($$$$) {
    my ($cups, $index, $min, $max) = @_;
    my $curCup = substr($cups, $index, 1);

    # remove three cups after index
    my $removed = substr($cups, $index + 1, 3, "");
    $removed .= substr($cups, 0, 3 - length($removed), "");

    # find destination index
    my $dest = $curCup;
    do {
        $dest--;
        $dest = $max if $dest < $min;
    } until ($cups =~ /$dest/);

    my $new = "$`$dest$removed$'";
    return $new, (index($new, $curCup) + 1) % length($new);
}

my @digits = sort split(//, $input);
my ($min, $max) = @digits[0, -1];
my ($part1, $index) = ($input, 0);
($part1, $index) = rotate($part1, $index, $min, $max) for (1..$iters);
$part1 =~ /1/;
say "$'$`";

## part 2

our @nextCup;
sub initCups($$) {
    my ($input, $count) = @_;
    my @digits = map { $_ - 1 } split(//, $input);

    for my $i (0..$#digits-1) {
        $nextCup[$digits[$i]] = $digits[$i+1];
    }
    my ($last, $next) = ($digits[-1], scalar @digits);
    while ($next < $count) {
        $nextCup[$last] = $next;
        $last = $next;
        $next++;
    }
    $nextCup[$last] = $digits[0];
    return $digits[0];
}

sub advance($) {
    my $curCup = shift;
    my @toMove = ($curCup);
    for (1..3) {
        push @toMove, $nextCup[$toMove[-1]];
    }
    shift @toMove;
    
    $nextCup[$curCup] = $nextCup[$toMove[-1]];

    my $destCup = ($curCup - 1) % @nextCup;
    while (grep {$_ == $destCup} @toMove) {
        $destCup = ($destCup - 1) % @nextCup;
    }
    $nextCup[$toMove[-1]] = $nextCup[$destCup];
    $nextCup[$destCup] = $toMove[0];
    return $nextCup[$curCup];
}

my $curCup = initCups($input, $count);

for (1..$iters2) {
    $curCup = advance($curCup);
}

say (($nextCup[0] + 1) * ($nextCup[$nextCup[0]] + 1));
