#!/usr/bin/perl
use strict;

my %numMap = (
              7 => [0, 0],
              8 => [0, 1],
              9 => [0, 2],
              4 => [1, 0],
              5 => [1, 1],
              6 => [1, 2],
              1 => [2, 0],
              2 => [2, 1],
              3 => [2, 2],
              0 => [3, 1],
              A => [3, 2],
              maxRow => 3,
             );

my %dirMap = (
              "^" => [0, 1],
              A => [0, 2],
              "<" => [1, 0],
              "v" => [1, 1],
              ">" => [1, 2],
             maxRow => 1);

my %dirKeys = map { join(":", @{$dirMap{$_}}) => $_ } grep { length == 1 } keys %dirMap;

my %cmds = (
            "^" => [-1, 0],
            "v" => [1, 0],
            "<" => [0, -1],
            ">" => [0, 1]);

my %cachedCost;
sub getCost($$$);
sub getCost($$$) {
    my ($src, $target, $depth) = @_;
    return 1 if $depth == 0 or $src eq $target;
    my $cacheKey = "$src$target$depth";
    return $cachedCost{$cacheKey} if exists $cachedCost{$cacheKey};

    my $map = ($cacheKey =~ /^.?[0-9]/) ? \%numMap : \%dirMap;
    my ($sr, $sc) = @{$map->{$src}};
    my ($tr, $tc) = @{$map->{$target}};
    my @q = ([0, $sr, $sc, "A"]);
    while (@q) {
        my ($cost, $r, $c, $lower) = @{shift @q};
        return $cachedCost{$cacheKey} = $cost if $r == $tr and $c == $tc and $lower eq 'A';
        next if $r < 0 or $r > $map->{maxRow} or $c < 0 or $c > 2 or ($r == $map->{A}[0] and $c == 0);
        for my $cmd (keys %cmds) {
            my ($dr, $dc) = @{$cmds{$cmd}};
            push @q, [$cost + getCost($lower, $cmd, $depth - 1), $r + $dr, $c + $dc, $cmd];
        }
        push @q, [$cost + getCost($lower, 'A', $depth - 1), $r, $c, 'A'] if $r == $tr and $c == $tc;
        @q = sort { $a->[0] <=> $b->[0] } @q;
    }
    die "no route from $src to $target at depth $depth\n";
}

sub score($$) {
    my ($seq, $depth) = @_;
    my $pos = 'A';
    my $cost = 0;
    for my $char (split(//, $seq)) {
        $cost += getCost($pos, $char, $depth);
        $pos = $char;
    }
    return $cost * $seq;
}

# print bfs('A', '0', 25), "\n";

my ($part1, $part2);
while (<>) {
    chomp;
    $part1 += score $_, 3;
    $part2 += score $_, 26;
}
print "$part1\n$part2\n";
