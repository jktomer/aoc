#!/usr/bin/perl

my $paper = 0;
while (<>) {
    my @dims = sort { $a <=> $b } split("x");
    $paper += 3*$dims[0]*$dims[1] + 2*($dims[0]+$dims[1])*$dims[2];
    $ribbon += 2*($dims[0]+$dims[1]) + $dims[0]*$dims[1]*$dims[2];
}
print "$paper $ribbon\n";
