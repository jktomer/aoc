#!/usr/bin/perl
use strict;

my @map = map { [ split(/\n?/) ] } <>;
my ($sr, $sc, $er, $ec);
Start:
for my $r (0..$#map) {
    for my $c (0..$#map) {
        ($sr, $sc) = ($r, $c) if $map[$r][$c] eq 'S';
        ($er, $ec) = ($r, $c) if $map[$r][$c] eq 'E';
    }
}

my @q = ([$sr, $sc, 0, 1, 0, {"$sr:$sc" => 1}]);

my %seen;
my ($bestCost, %onBest);

while (@q) {
    my ($r, $c, $dr, $dc, $partialCost, $partialPath) = @{shift @q};
    while (@q and $q[0][0] == $r and $q[0][1] == $c and $q[0][2] == $dr and $q[0][3] == $dc and $q[0][4] == $partialCost) {
        # all the equivalently-cheap ways to get here must be at the front of
        # the queue too, slurp them up and combine the different ways to get
        # here
        $partialPath->{$_} = 1 for keys %{$q[0][5]};
        shift @q;
    }
    next if $seen{"$r:$c:$dr:$dc"}++;

    if ($map[$r][$c] eq 'E') {
        print "$partialCost\n", scalar keys %$partialPath, "\n";
        last;
    }
    my ($nr, $nc) = ($r + $dr, $c + $dc);
    if ($nr >= 0 and $nr <= $#map and $nc >= 0 and $nc <= $#map and $map[$nr][$nc] ne '#') {
        push @q, [$nr, $nc, $dr, $dc, $partialCost + 1, { %$partialPath, "$nr:$nc" => 1 }];
    }
    push @q, [$r, $c, -$dc, $dr, $partialCost + 1000, $partialPath];
    push @q, [$r, $c, $dc, -$dr, $partialCost + 1000, $partialPath];
    @q = sort { $a->[4] <=> $b->[4] or $a->[0] <=> $b->[0] or $a->[1] <=> $b->[1] or $a->[2] <=> $b->[2] or $a->[3] <=> $b->[3]} @q; # priority queues are for dweebs
}
