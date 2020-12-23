#!/usr/bin/perl

use strict;
use feature qw/say/;

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

my ($input, $iters) = @ARGV;
my @digits = sort split(//, $input);
my ($min, $max) = @digits[0, -1];
my ($part1, $index) = ($input, 0);
($part1, $index) = rotate($part1, $index, $min, $max) for (1..$iters);
$part1 =~ /1/;
say "$'$`";
