#!/usr/bin/perl

my $in = shift;
my $iters = shift;

for (1..$iters) {
    my ($next, $sofar);
    while ($sofar < length $in) {
        my $what = substr($in, $sofar, 1);
        my $howmany = 1;
        $howmany++ while substr($in, $sofar + $howmany, 1) eq $what;
        $next .= "$howmany$what";
        $sofar += $howmany;
    }
    $in = $next;
    print "$_: ", length($in), "\n";
}
