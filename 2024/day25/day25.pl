#!/usr/bin/perl
use strict;

$/ = '';
my @schematics = <>;
my (@locks, @keys);
for my $schematic (@schematics) {
    chomp $schematic;
    my $target = $schematic =~ /^#/ ? \@locks : \@keys;
    my @lines = split("\n", $schematic);
    my @pins;
    push @pins, 0 for 1..length($lines[0]);
    for my $line (@lines[1..$#lines-1]) {
        for my $i (0..length($line)-1) {
            $pins[$i]++ if substr($line, $i, 1) eq '#';
        }
    }
    push @$target, [@pins];
}

my $fits;

Lock:
for my $lock (@locks) {
 Key:
    for my $key (@keys) {
    Pin:
        for my $i (0..$#$lock) {
            next Key if $lock->[$i] + $key->[$i] > 5;
        }
        $fits++;
    }
}

print "$fits\n";
