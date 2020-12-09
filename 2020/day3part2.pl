#!/usr/bin/perl

my @rows;
while (<>) {
    chomp;
    my @row;
    for my $i (0..length($_) - 1) {
        push @row, substr($_, $i, 1) eq '#';
    }
    push @rows, \@row;
}

if ($rows[0][0]) {
    die "Origin is a tree?!\n";
}

sub trees($$$) {
    my ($rows, $right, $down) = @_;
    my $x = 0;
    my $y = 0;
    my $trees = 0;
    my $width = @{$rows->[0]};
    
     do {
         $trees++ if $rows->[$y][$x];
         $x = ($x + $right) % $width;
         $y += $down;
    } while ($y < @$rows);
    return $trees;
}

my @results =
    (
     trees(\@rows, 1, 1),
     trees(\@rows, 3, 1),
     trees(\@rows, 5, 1),
     trees(\@rows, 7, 1),
     trees(\@rows, 1, 2)
    );

print join(" * ", @results), " = ";
my $n = 1;
$n *= $_ for @results;
print "$n\n";
