#!/usr/bin/perl

my $turns = shift;
my @latest;
$latest[$ARGV[$_]] = $_+1 for (0..$#ARGV - 1);
my $next = $ARGV[-1];
for (my $time = scalar @ARGV; $time < $turns; $time++) {
    my $age = $latest[$next];
    $age = $time - $age if $age;
    $latest[$next] = $time;
    $next = $age;
}

print "$next\n";
