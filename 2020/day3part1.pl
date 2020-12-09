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

my $x = 0;
my $y = 0;
my $trees = 0;
my $width = @{$rows[0]};

for my $row (@rows) {
    print "tree at ($y, $x)\n" and $trees++ if $row->[$x];
    $x = ($x + 3) % $width;
    $y++;
}

print $trees, "\n";
