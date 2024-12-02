#!/usr/bin/perl

sub safe(@) {
    my @levels = @_;
    my $last = shift @levels;
    my $dir = $levels[0] < $last;
    for my $next (@levels) {
        if (($next < $last) != $dir) {
            return undef;
        }
        my $mag = abs($next - $last);
        return undef if $mag < 1 or $mag > 3;
        $last = $next;
    }
    return 1;
}

my ($part1, $part2);
Report:
while (<>) {
    my @levels = split;
    if (safe(@levels)) {
        $part1++;
        $part2++;
        next Report;
    }
    my $skipped = shift @levels;
    $part2++ and next Report if safe @levels;
    for my $i (0..$#levels) {
        ($levels[$i], $skipped) = ($skipped, $levels[$i]);
        $part2++ and next Report if safe @levels;
    }
}

print "$part1 $part2\n";
