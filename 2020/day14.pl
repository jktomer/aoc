#!/usr/bin/perl

use strict;

my @masks = (0, 0xfffffffff); # or, and
my ($constmask, $varmask, $xcount);
my (%mem1, %mem2);
my @memsums;                    # part 1, part 2
my @lines = <>;
for (@lines) {
    chomp;
    if (/mask = (.*)/) {
        my $m = $1;
        $masks[0] = oct("0b" . ($m =~ y/X/0/r));
        $masks[1] = oct("0b" . ($m =~ y/X/1/r));
        my $next = 'A';
        $constmask = oct("0b" . (($m =~ y/01X/110/r)));
        $varmask = ($m =~ s/X/$next++/ger);
        $varmask =~ y/1/0/;
        $xcount = s/X/X/g;
        next;
    }

    my ($addr, $val) = /mem\[(\d+)\] = (\d+)/ or die;

    my $v1val = ($val & $masks[1]) | $masks[0];
    $memsums[0] += $v1val - $mem1{$addr};
    $mem1{$addr} = $v1val;

    my $v2addrbase = ($addr | $masks[0]) & $constmask;
    my $limit = (1<<$xcount) - 1;
    my $chronly = ($varmask =~ y/A-Z//cdr);
    my $chrs = length($chronly);
    for my $i (0..$limit) {
        my $ibin = sprintf "%0${chrs}b", $i;
        my $binmask = eval "\$varmask =~ y/$chronly/$ibin/r";
        my $mask = oct("0b" . $binmask);
        my $v2addr = $v2addrbase | $mask;
        $memsums[1] += $val - $mem2{$v2addr};
        $mem2{$v2addr} = $val;
    }
}

print join(" ", @memsums), "\n";
