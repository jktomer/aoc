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

my (%timeFromStart, %timeToEnd);
sub race($$$);
sub race($$$) {
    my ($r, $c, $time) = @_;
    my $key = "$r:$c";
    return if defined $timeToEnd{$key};
    return if $map[$r][$c] eq '#';

    $timeFromStart{$key} = $time unless exists $timeFromStart{$key} and $timeFromStart{$key} < $time;

    $timeToEnd{$key} = 0;
    return 0 if $key eq '$er:$ec';

    for my $dr (-1..1) {
        next if $r + $dr < 0 or $r + $dr > $#map;
        for my $dc (-1..1) {
            next if $c + $dc < 0 or $c + $dc > $#map;
            next unless $dr xor $dc;
            my ($nr, $nc) = ($r + $dr, $c + $dc);
            my $cost = race($nr, $nc, $time + 1);
            $timeToEnd{$key} = $cost + 1 if defined $cost;
        }
    }
    return $timeToEnd{$key};
}

my $noCheat = race($sr, $sc, 0);

sub cheats($$) {
    my ($cheatMaxDuration, $quality) = @_;
    my $goodCheats;
    for my $csr (0..$#map) {
        for my $csc (0..$#map) {
            my ($rmin, $rmax) = ($csr - $cheatMaxDuration, $csr + $cheatMaxDuration);
            $rmin = 0 if $rmin < 0;
            $rmax = $#map if $rmax > $#map;
            for my $cer ($rmin..$rmax) {
                my $vdist = abs($cer - $csr);
                my $remain = $cheatMaxDuration - $vdist;
                my ($cmin, $cmax) = ($csc - $remain, $csc + $remain);
                $cmin = 0 if $cmin < 0;
                $cmax = $#map if $cmax > $#map;
                for my $cec ($cmin..$cmax) {
                    my $dist = abs($cec - $csc) + $vdist;
                    next unless defined $timeFromStart{"$csr:$csc"} and defined $timeToEnd{"$cer:$cec"};
                    my $cheat = $timeFromStart{"$csr:$csc"} + $dist + $timeToEnd{"$cer:$cec"};
                    # print "$csr $csc $cer $cec $dist $cheat\n" and
                    $goodCheats++ if $cheat <= $noCheat - $quality;
                }
            }
        }
    }
    return $goodCheats;
}

print cheats(2, 100), " ", cheats(20, 100), "\n";
