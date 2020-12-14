#!/usr/bin/perl
use strict;

my %edges;
my $goal;
while (<>) {
    chomp;
    next if /^ *$/;
    if (/(.*) => (.*)/) {
        push @{$edges{qr/$1/}}, $2;
    } else {
        $goal = $_;
    }
}

my %oneaway;
while (my ($from, $tos) = each %edges) {
    while ($goal =~ /$from/g) {
        $oneaway{"$`$_$'"}++ for @$tos;
    }
}

print scalar keys %oneaway, "\n";

my $anyElt = join("|", keys %edges);
my $anyEltRE = qr/$anyElt/;
my $elts = ($goal =~ s/$anyEltRE/$&/g);
my $commas = ($goal =~ y/Y/Y/);
my $answer = $elts - $commas - 1;
print "$elts $commas $answer\n";
