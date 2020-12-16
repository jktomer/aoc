#!/usr/bin/perl

use Data::Dumper;
use Clone 'clone';

my %rules;
my @union;

sub coalesce(\@$$) {
    my ($ranges, $left, $right) = @_;
    for my $range (@$ranges) {
        my ($rl, $rr) = @$range;
        next if $right < $rl or $left > $rr;
        $range->[0] = $left if $left < $rl;
        $range->[1] = $right if $right > $rr;
        return;
    }
    push @$ranges, [$left, $right];
}

# read rules
while (<>) {
    last if /^$/;
    my ($field, $l1, $r1, $l2, $r2) = /^(.*): (\d+)-(\d+) or (\d+)-(\d+)$/ or die;
    $rules{$field} = [$l1, $r1, $l2, $r2];
    coalesce(@union, $l1, $r1);
    coalesce(@union, $l2, $r2);
}

# read your ticket
<> =~ /your ticket/ or die;
my @myTicket = split(/,/, scalar <>);
<> =~ /^$/ or die;

# read nearby tickets
my $errorRate = 0;
my @possible = map { clone(\%rules) } keys %rules;
my %possible = map { $_ => { map {$_ => 1} 0..$#possible } } keys %rules;

LINE:
while (<>) {
    my @numbers = split(/,/);
    next if @numbers < 2;
 NUM:
    for my $n (@numbers) {
        for my $range (@union) {
            next NUM if $n >= $range->[0] and $n <= $range->[1];
        }
        $errorRate += $n;
        next LINE;
    }
    for my $i (0..$#possible) {
        next if scalar keys %{$possible[$i]} == 1;
        my $n = $numbers[$i];
        while (my ($k, $ranges) = each %{$possible[$i]}) {
            next if $n >= $ranges->[0] and $n <= $ranges->[1];
            next if $n >= $ranges->[2] and $n <= $ranges->[3];
            delete $possible[$i]{$k};
            delete $possible{$k}{$i};
        }
        die "$n doesn't fit into any remaining possibility for field $i\n" if scalar keys %{$possible[$i]} == 0;
    }
}

my $changed;
do {
    $changed = 0;
    for my $i (0..$#possible) {
        next if scalar keys %{$possible[$i]} > 1;
        my ($winner) = (keys %{$possible[$i]});
        next if scalar keys %{$possible{$winner}} == 1;
        for my $j (keys %{$possible{$winner}}) {
            next if $j == $i;
            delete $possible[$j]{$winner};
            $changed++;
        }
        $possible{$winner} = { $i };
    }
} while ($changed);

my @winner = keys %{$possible[$i]};
for my $other (keys %{$possible{$winner[0]}}) {
    next if $other == $i;
    delete $possible[$other]{$winner[0]};
}

print "$errorRate\n";

my $part2 = 1;
for my $i (0..$#possible) {
    my ($field) = (keys %{$possible[$i]});
    next unless $field =~ /^departure/;
    print "$i $field $myTicket[$i]\n";
    $part2 *= $myTicket[$i];
}
print "$part2\n";
