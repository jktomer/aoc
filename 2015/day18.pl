#!/usr/bin/perl

use strict;

my $board = [];
my $iters = shift;
my $stuck;
if ($iters < 0) {
    $iters = -$iters;
    $stuck = "stuck";
}

while (<>) {
    chomp;
    push @$board, [ map { $_ eq '#' ? 1 : 0 } split(//)];
}

sub step(+@) {
    my $inBoard = shift;
    my @outBoard;

    if ($stuck) {
        $inBoard->[0][0] = 1;
        $inBoard->[0][$#$inBoard] = 1;
        $inBoard->[$#$inBoard][0] = 1;
        $inBoard->[$#$inBoard][$#$inBoard] = 1;
    }
    
    for my $i (0..$#$inBoard) {
        push @outBoard, [];
        for my $j (0..$#{$inBoard->[$i]}) {
            my $neighbors = 0;
            for my $di (-1..1) {
                for my $dj (-1..1) {
                    next unless $di or $dj;
                    my ($ii, $jj) = ($i + $di, $j + $dj);
                    next if $ii < 0 or $ii > $#$inBoard;
                    next if $jj < 0 or $jj > $#$inBoard;
                    $neighbors += $inBoard->[$ii][$jj];
                    # print "$i $j $ii $jj $inBoard->[$ii][$jj] $neighbors\n";
                }
            }
            # print "$i $j $inBoard->[$i][$j] $neighbors -> ", !!($neighbors == 3 or ($neighbors == 2 and $inBoard->[$i][$j])), "\n";
            push @{$outBoard[$i]}, !!($neighbors == 3 or ($neighbors == 2 and $inBoard->[$i][$j]));
        }
    }

    if ($stuck) {
        $outBoard[0][0] = 1;
        $outBoard[0][$#$inBoard] = 1;
        $outBoard[$#$inBoard][0] = 1;
        $outBoard[$#$inBoard][$#$inBoard] = 1;
    }

    return \@outBoard;
}

for my $step (1..$iters) {
    $board = step($board);
}

my $count = 0;
for my $row (@$board) {
    $count += $_ for @$row;
    # for my $c (@$row) 
    # {
    #     print "#" if $c;
    #     print "X" unless $c;
    # }
    # print "\n";
}

print "$count\n";
