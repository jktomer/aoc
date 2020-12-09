#!/usr/bin/perl

my $valid = 0;
my @expected = qw/byr iyr eyr hgt hcl ecl pid/; # and cid, but not;
$/ = "";

RECORD:
while (<>) {
    chomp;
    my @values = split(" ");
    my %card;
    for my $field (@values) {
        my ($key, $val) = split(":", $field);
        $card{$key} = $val;
    }

    for my $expected (@expected) {
        next RECORD unless exists $card{$expected};
    }
    $valid++;
}

print "$valid\n";
