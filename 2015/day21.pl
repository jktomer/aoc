#!/usr/bin/perl

use strict;
use POSIX 'ceil';
use Data::Dumper;

sub ttk($$)
{
    my ($attacker, $defender) = @_;
    my $admg = $attacker->{Damage} - $defender->{Armor};
    $admg = 1 if $admg < 1;
    return ceil($defender->{"Hit Points"} / $admg); 
}

sub survivable(\%\%)
{
    my ($player, $boss) = @_;
    return ttk($player, $boss) <= ttk($boss, $player);
}

my %items;
my $category;
while (<DATA>)
{
    /^(.*):/ and $category = $1;
    /^(.*?)\s+(\d+)\s+(\d+)\s+(\d+)$/ or next;
    push @{$items{$category}}, {name => $1, cost => $2, Damage => $3, Armor => $4};
}

my %bossStats = map { split(/: */) } <>;

# Armor is optional
push @{$items{Armoror}}, {name => "Nothing", cost => 0, Damage => 0, Armor => 0};

# 0, 1, or 2 rings are allowed
my $rc = $#{$items{Rings}};
for my $il (0..$rc)
{
    for my $ir ($il+1..$rc)
    {
        my $l = $items{Rings}[$il];
        my $r = $items{Rings}[$ir];
        push @{$items{Rings}}, {name => "$l->{name} + $r->{name}", map { $_ => $l->{$_} + $r->{$_} } qw/cost Damage Armor/};
    }
}
push @{$items{Rings}}, $items{Armoror}[-1];

my (%best, %worst);
for my $w (@{$items{Weapons}})
{
    for my $a (@{$items{Armoror}})
    {
        for my $r (@{$items{Rings}})
        {
            my %stats = (equip => join(" + ", map { $_->{name} } ($w, $a, $r)), map { $_ => $w->{$_} + $a->{$_} + $r->{$_} } qw/cost Damage Armor/);
            $stats{"Hit Points"} = 100;
            %best = %stats if survivable(%stats, %bossStats) and (not exists $best{cost} or $best{cost} > $stats{cost});
            %worst = %stats if !survivable(%stats, %bossStats) and $worst{cost} < $stats{cost};
        }
    }
}

print Dumper(\%best);
print Dumper(\%worst);

__DATA__
Weapons:    Cost  Damage  Armoror
Dagger        8     4       0
Shortsword   10     5       0
Warhammer    25     6       0
Longsword    40     7       0
Greataxe     74     8       0

Armoror:      Cost  Damage  Armoror
Leather      13     0       1
Chainmail    31     0       2
Splintmail   53     0       3
Bandedmail   75     0       4
Platemail   102     0       5

Rings:      Cost  Damage  Armoror
Damage +1    25     1       0
Damage +2    50     2       0
Damage +3   100     3       0
Defense +1   20     0       1
Defense +2   40     0       2
Defense +3   80     0       3
