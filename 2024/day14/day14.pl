#!/usr/bin/perl

my @robots = map { [ /p=(\d+),(\d+) v=(-?\d+),(-?\d+)/ ] } <>;
my ($w, $h, $steps) = (101, 103, 100);
my @quads;
my $stem;

for my $step (0..$h * $w) {
    my %bots;
    open OUT, sprintf(">/tmp/step%05d.txt", $step);
    for my $r (@robots) {
        my ($px, $py, $vx, $vy) = @$r;
        $px = ($px + $step * $vx) % $w;
        $py = ($py + $step * $vy) % $h;
        $bots{"$px:$py"}++;
        $stem++ and next if $step != 100 or $px == int($w / 2) or $py == int($h / 2);
        $quads[($px < ($w / 2)) * 2 + ($py < ($h / 2))]++;
    }
    for my $y (0..$h-1) {
        for my $x (0..$w-1) {
            print OUT $bots{"$x:$y"} || ".";
        }
        print OUT "\n";
    }
    close OUT;
}

my $part1 = 1;
$part1 *= $_ for @quads;

print "$part1\n";
