#!/usr/bin/perl

my @deer;
my $length = shift;

while (<>) {
    my ($speed, $burst, $rest) = /\w+ can fly (\d+) km.s for (\d+) seconds.*rest for (\d+) seconds/;
    push @deer, [$speed, $burst, $rest, 0, $burst, 0];
}

sub SPD() { 0 }
sub BURST() { 1 }
sub REST() { 2 }
sub POS() { 3 }
sub STATE() { 4 }
sub POINTS() { 5 }

for (1..$length) {
    for my $deer (@deer) {
        if ($deer->[STATE] > 0) {
            $deer->[POS] += $deer->[SPD];
        }
        $deer->[STATE]--;
        $deer->[STATE] = $deer->[BURST] if $deer->[STATE] == -$deer->[REST];
    }
    @deer = sort { $b->[POS] <=> $a->[POS] } @deer;
    for my $deer (@deer) {
        last if $deer->[POS] < $deer[0][POS];
        $deer->[POINTS]++;
    }
}

my $oldwinner = (sort { $b->[POS] <=> $a->[POS] } @deer)[0]->[POS];
my $newwinner = (sort { $b->[POINTS] <=> $a->[POINTS] } @deer)[0]->[POINTS];
print "$oldwinner $newwinner\n";
