#!/usr/bin/perl

my %evidence;
my ($part1, $part2);
my %P2OP = (trees => "<=", cats => "<=", pomeranians => ">=", goldfish => ">=");

ROW:
while (<>) {
    unless (/^Sue/) {
        my ($req, $count) = /^(.*): (\d+)$/;
        $evidence{$req} = $count;
        next;
    }
    my ($id, $clues) = /^Sue (\d+): (.*)$/;
    my %clues = map { /(.*): (\d+)/ } split(/, /, $clues);

    keys(%evidence);
    my ($part1ok, $part2ok) = (1, 1);
    while (my ($req, $count) = each(%evidence)) {
        $part1ok = 0 if exists($clues{$req}) and $clues{$req} != $count;
        my $p2op = ($P2OP{$req} or "!=");
        $part2ok = 0 if exists($clues{$req}) and eval "$clues{$req} $p2op $count";
        die "[$req] [$p2op] [$count] $clues{$req} $p2op $count: $@" if $@;
    }
    $part1 = $id if $part1ok;
    $part2 = $id if $part2ok;
}

print "$part1 $part2\n";
