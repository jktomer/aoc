#!/usr/bin/perl

while (<>) {
    chomp;
    $entries{$_}++;
}

for my $a (sort keys %entries) {
    if ($entries{2020 - $a}) {
        print $a * (2020 - $a), "\n";
    }
}
