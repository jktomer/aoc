#!/usr/bin/perl
use strict;

my $size = shift || 70;
my $steps = shift || 1024;

my %bad;
my %cost;

sub sp() {
    undef %cost;
    my @q = ([0, 0, 0]);
    while (@q) {
        my ($x, $y, $cost) = @{shift @q};
        my $key = "$x,$y";
        next if exists $cost{$key} or exists $bad{$key};
        return $cost if $key eq "$size,$size";
        $cost{$key} = $cost;
        for my $dx (-1..1) {
            next if $x + $dx < 0 or $x + $dx > $size;
            for my $dy (-1..1) {
                next unless $dx xor $dy;
                next if $y + $dy < 0 or $y + $dy > $size;
                push @q, [$x + $dx, $y + $dy, $cost + 1];
            }
        }
    }
    return undef;
}

while (<>) {
    chomp;
    $bad{$_} = 1;
    print sp(), "\n" if ($. == $steps);
    next unless $cost{$_};
    last unless defined sp();
}
print "$_\n";
