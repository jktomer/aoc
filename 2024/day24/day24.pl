#!/usr/bin/perl
use strict;

my (%wires, @pending, %gates, %partialGates, $inBits);
my $z;
while (<>) {
    if (/([xy])(.*): ([01])/) {
        $wires{"$1$2"} = $3;
        $inBits = $2 if $inBits < $2;
    }
    /(\w+) (\w+) (\w+) -> (\w+)/ or next;
    push @pending, [$4, $2, $1, $3];
    my @ins = sort($1, $3);
    $gates{"$ins[0] $2 $ins[1]"} = $4;

    $partialGates{"$2:$1"} = $3;
    $partialGates{"$2:$3"} = $1;
}

while (@pending) {
    my $next = shift @pending;
    my ($out, $op, $in1, $in2) = @$next;
    push @pending, $next and next unless exists $wires{$in1} and exists $wires{$in2};
    if ($op eq 'AND') {
        $wires{$out} = $wires{$in1} && $wires{$in2};
    } elsif ($op eq 'OR') {
        $wires{$out} = $wires{$in1} || $wires{$in2};
    } elsif ($op eq 'XOR') {
        $wires{$out} = $wires{$in1} != $wires{$in2};
    }
    if ($out =~ /z(\d+)/) {
        $z |= $wires{$out} << $1;
    }
}

my %swaps;
sub getGate($$$) {
    my ($op, @ins) = @_;
    @ins = sort @ins;
    my $res = $gates{"$ins[0] $op $ins[1]"};
    unless ($res) {
        for my $c (0..1) {
            my $b = 1-$c;
            my $other = $partialGates{"$op:$ins[$c]"};
            next unless $other;
            $swaps{$other}++;
            $swaps{$ins[$b]}++;
            my @newIns = sort ($ins[$c], $other);
            $res = $gates{"$newIns[0] $op $newIns[1]"};
        }
    }
    return $res;
}

print "$z\n";
my (@rawAdds, @baseCarries, @cascadedCarries, @carries, @outs);
for my $bit (0..$inBits) {
    $bit = "0$bit" if $bit < 10;
    $rawAdds[$bit] = getGate("XOR", "x$bit", "y$bit");
    $baseCarries[$bit] = getGate("AND", "x$bit", "y$bit");
    if ($bit > 0) {
        $cascadedCarries[$bit] = getGate("AND", $rawAdds[$bit], $carries[$bit - 1]);
        $carries[$bit] = getGate("OR", $baseCarries[$bit], $cascadedCarries[$bit]);
        $outs[$bit] = getGate("XOR", $rawAdds[$bit], $carries[$bit-1]);
    } else {
        $outs[$bit] = $rawAdds[$bit];
        $carries[$bit] = $baseCarries[$bit];
    }
}
print join(",", sort keys %swaps), "\n";
