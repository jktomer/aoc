#!/usr/bin/perl

my @map = split(/\n?/, <>);
my @blocks;
my (%files, @free);
for my $i (0..$#map) {
    my $l = $map[$i];
    if ($i %2) {
        push @free, [scalar @blocks, $l];
        push @blocks, (undef) x $l;
    } else {
        my $id = $i / 2;
        $files{$id} = [scalar @blocks, $l];
        push @blocks, ($id) x $l;
    }
}

# print "$_: $files{$_}[1] @ $files{$_}[0]\n" for sort keys %files;
# print "x: $_->[1] @ $_->[2]\n" for @free;

my $firstFree = 0;
$firstFree++ while defined($blocks[$firstFree]);
my $lastUsed = $#blocks;
$lastUsed-- until defined($blocks[$lastUsed]);

while ($firstFree < $lastUsed) {
    $firstFree++ and next if defined($blocks[$firstFree]);
    $lastUsed-- and next unless defined($blocks[$lastUsed]);
    $blocks[$firstFree] = $blocks[$lastUsed];
    undef $blocks[$lastUsed];
    $firstFree++;
    $lastUsed--;
}

my $part1;
for my $i (0..$firstFree) {
    $part1 += $i * $blocks[$i];
}

print "$part1\n";

File:
for my $file (sort { $b <=> $a } keys %files) {
    my ($fpos, $fsize) = @{$files{$file}};
 Free:
    for my $space (@free) {
        my ($spos, $ssize) = @$space;
        next File if $spos > $fpos;
        next Free if $ssize < $fsize;
        $space->[0] += $fsize;
        $space->[1] -= $fsize;
        $files{$file}[0] = $spos;
        # print "moving $file from $fpos to $spos\n";
        next File;
    }
}

# @blocks = (undef) x $#blocks;
my $part2;
while (my ($id, $file) = each %files) {
    my ($fpos, $fsize) = @$file;
    for my $i ($fpos .. $fpos + $fsize - 1) {
        $part2 += $i * $id;
    }
}
print "$part2\n";
