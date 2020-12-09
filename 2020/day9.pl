#!/usr/bin/perl

my $size = shift;
my @data = <>;
chomp for @data;
my %buffer = map { ($_, 1) } @data[0..$size-1];
my $key;

for my $i ($size..$#data) {
    my ($e, $o) = ($data[$i], $data[$i - $size]);
    my $found;
    for my $c (keys %buffer) {
        next if $c * 2 == $e;
        $found++, last if $buffer{$e - $c};
    }
    unless ($found) {
        $key = $e;
        last;
    }
    $buffer{$e}++;
    $buffer{$o}--; delete $buffer{$o} unless $buffer{$o};
}

my ($l, $r, $sum) = (0, 1, $data[0] + $data[1]);
while ($sum != $key or $r == $l + 1) {
    die if $r > $#data;
    if ($sum < $key) {
        $sum += $data[++$r];
    } else {
        $sum -= $data[$l++];
    }
}

my ($min, $max) = ($data[$l], $data[$l]);
for my $e (@data[$l..$r]) {
    $min = $e if $min > $e;
    $max = $e if $max < $e;
}
my $res = $min + $max;
print "$key $res\n"; # $leftEl $rightEl $secret\n";
