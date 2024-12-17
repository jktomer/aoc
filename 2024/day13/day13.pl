#!/usr/bin/perl
use strict;
use bignum;

sub gcd($$) {
    my ($x, $y) = @_;
    ($x, $y) = ($y, $x % $y) while $y;
    return $x;
}

sub solve($$$$$$) {
    my ($ax, $ay, $bx, $by, $px, $py) = @_;
    return 0 if $px % gcd($ax, $bx) != 0;
    return 0 if $py % gcd($ay, $by) != 0;
    die if $ax*$by == $ay*$bx;
    return 0 if ($px*$by-$py*$bx) % ($ax*$by-$ay*$bx) != 0;
    my $aPresses = ($px*$by-$py*$bx)/($ax*$by-$ay*$bx);

    return 0 if ($px - ($aPresses * $ax)) % $bx != 0;
    my $bPresses = ($px - ($aPresses * $ax)) / $bx;

    return 0 if $aPresses < 0 or $bPresses < 0;
    unless ($aPresses * $ax + $bPresses * $bx == $px) {
        die "wrong x: " . join(" ", @_);
    }
    die "wrong y: " . join(" ", @_) unless $aPresses * $ay + $bPresses * $by == $py;
    return $aPresses * 3 + $bPresses;
}

$/ = "";
my ($part1, $part2);
while (<>) {
    my ($ax, $ay, $bx, $by, $px, $py) = /Button A: X\+(\d+), Y\+(\d+)\nButton B: X\+(\d+), Y\+(\d+)\nPrize: X=(\d+), Y=(\d+)/m or die;
    $part1 += solve ($ax, $ay, $bx, $by, $px, $py);
    $part2 += solve ($ax, $ay, $bx, $by, $px + 10000000000000, $py + 10000000000000);
}
print "$part1\n$part2\n";

__END__

hi
    A * ax + B * bx = px
    A * ay + B * by = py
    B*by = py - A*ay
    B = (py - A*ay)/by
    A*(ax*by - bx*ay) = px*by-bx*py



    n*ax*by + m*bx*by = 0
    n*bx*ay + m*bx*by = 0
    n*ax*by-n*bx*ay = 0
    ax*by=bx*ay
