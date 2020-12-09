#!/usr/bin/perl
use JSON;
use Data::Dumper;

my $ignore_red;

local $/;
my $j = decode_json(<>);

sub count($) {
    my $arg = shift;
    if (ref $arg eq "ARRAY") {
        my $total = 0;
        $total += count($_) for @$arg;
        return $total;
    } elsif (ref $arg eq "HASH") {
        return 0 if $ignore_red and grep { $_ eq "red" } values(%{$arg});
        my $total;
        $total += count($_) for values %{$arg};
        return $total;
    }
    return $arg + 0;
}

print count($j), "\n";
$ignore_red = 1;
print count($j), "\n";
