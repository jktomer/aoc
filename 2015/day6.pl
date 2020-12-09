#!/usr/bin/perl

my $size = shift;
my $lights = scalar(("0" x $size) . "\n") x $size;
my @newlights = (0) x ($size * $size);

while (<>) {
    my ($left, $top, $right, $bot) = / (\d+),(\d+) through (\d+),(\d+)$/;
    my $width = $right + 1 - $left;
    for my $i ($top .. $bot) {
        # print "$i ", $i * ($size + 1) + $left, " $width\n";
        /turn on/ and substr($lights, $i * ($size+1) + $left, $width) = "1" x $width;
        /turn off/ and substr($lights, $i * ($size+1) + $left, $width) = "0" x $width;
        /toggle/ and substr($lights, $i * ($size+1) + $left, $width) =~ y/01/10/;

        for my $newlight ($i * $size + $left .. $i * $size + $right) {
            if (/turn on/) { $newlights[$newlight]++ }
            elsif (/toggle/) { $newlights[$newlight] += 2 }
            elsif ($newlights[$newlight] > 0) { $newlights[$newlight]-- }
        }
    }
}

$lights =~ y/1//cd;
print length($lights), "\n";

my $total = 0;
$total += $_ for @newlights;
print "$total\n";
