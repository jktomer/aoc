#!/usr/bin/perl

my ($good, $bad);
while (<>) {
    chomp;
    my ($min, $max, $letter, $pass) = /^(\d+)-(\d+) (\w): (\w+)$/ or die $_;
    eval "\$pass =~ tr/$letter//cd;";
    if (length $pass >= $min and length $pass <= $max) {
        $good++;
    } else {
        $bad++;
    }
}
print "$good\n$bad\n";
