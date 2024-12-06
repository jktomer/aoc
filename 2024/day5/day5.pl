#!/usr/bin/perl

my %rules;
{
    local $/ = '';
    %rules = map { $_ => 1 } split("\n", <>);
}

my ($part1, $part2);
Manual:
while (<>) {
    chomp;
    my @pages = split(/,/);
    my @sorted = sort { $rules{"$a|$b"} ? -1 : $rules{"$b|$a"} ? 1 : 0 } @pages;
    if (join("", @pages) eq join("", @sorted)) {
        $part1 += $pages[$#pages / 2];
    } else {
        $part2 += $sorted[$#pages / 2];
    }
}

print "$part1\n$part2\n";
