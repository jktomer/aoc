#!/usr/bin/perl

sub cando {
    my ($result, $accum, @values) = @_;
    return $result == $accum unless @values;
    return undef if $accum > $result;
    my $next = shift @values;
    return cando($result, $accum + $next, @values) ||
        cando($result, $accum * $next, @values);
}

sub cando2 {
    my ($result, $accum, @values) = @_;
    return $result == $accum unless @values;
    return undef if $accum > $result;
    my $next = shift @values;
    return cando2($result, $accum + $next, @values) ||
        cando2($result, $accum * $next, @values) ||
        cando2($result, $accum . $next, @values);
}

my ($part1, $part2);
while (<>) {
    my @values = split;
    my $result = shift @values;
    my $accum = shift @values;
    if (cando($result, $accum, @values)) {
        $part1 += $result;
        $part2 += $result;
    } elsif (cando2($result, $accum, @values)) {
        $part2 += $result;
    }
}

print "$part1\n$part2\n";
