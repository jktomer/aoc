#!/usr/bin/perl

my $total_volume = shift;
our @containers = <>;
my %cache;

sub ways($$)
{
    my ($volume, $index) = @_;
    my $key = "$volume:$index";
    return $cache{$key} if exists $cache{$key};

    return [] if $index > $#containers and $volume != 0;
    return [1] if $index > $#containers;

    my @with = map { $_ + 1 } @{ways($volume - $containers[$index], $index + 1)};
    my @without = @{ways($volume, $index + 1)};
    push @with, @without;
    $cache{$key} = \@with;
}

my $allWays = ways($total_volume, 0);
my ($min, $minWays);
for my $use (@$allWays) {
    next if defined($min) and $min < $use;
    $minWays++, next if $min == $use;
    $min = $use;
    $minWays = 1;
}

print scalar(@$allWays), " $minWays\n";
