#!/usr/bin/perl

while (<>) {
    chomp;
    my $l = $_;
    my $r = $_;
    $l =~ y/(//cd;
    $r =~ y/)//cd;
    print length($l) - length($r), "\n";

    my $where = 0;
    for my $i (1..length) {
        $where += (substr($_, $i - 1, 1) eq '(') ? 1 : -1;
        print "$i\n" and last if $where < 0;
    }
}
