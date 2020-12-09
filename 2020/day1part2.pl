#!/usr/bin/perl

while (<>) {
    chomp;
    $entries{$_}++;
    push @entries, $_;
}

for my $i (0..$#entries) {
    my $a = $entries[$i];
    for my $j ($i+1..$#entries) {
        my $b = $entries[$j];
        my $c = 2020 - $a - $b;
        if ($entries{$c}) {
            print "$a * $b * $c = ", $a * $b * $c, "\n";
        }
    }
}
