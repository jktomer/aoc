#!/usr/bin/perl

my ($good, $bad) = (0, 0); 
while (<>) {
    chomp;
    my ($min, $max, $letter, $pass) = /^(\d+)-(\d+) (\w): (\w+)$/ or die $_;
    if ((substr($pass, $min-1, 1) eq $letter) xor (substr($pass, $max-1, 1) eq $letter)) {
        $good++;
    } else {
        $bad++;
    }
}
print "$good\n$bad\n";
