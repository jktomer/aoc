#!/usr/bin/perl
use strict;

my @initialRegs;
my @insns;
while (<>) {
    /Register (.): (\d+)/ and $initialRegs[ord($1) - ord('A')] = $2;
    /Program: (.*)/ and @insns = split(",", $1);
}

sub combo($@) {
    my ($operand, @regs) = @_;
    return $operand if $operand < 4;
    return $regs[$operand - 4] if $operand < 7;
}

sub run {
    my @outs;

    my @regs = @initialRegs;
    my $ip = 0;
    while ($ip <= $#insns) {
        my $insn = $insns[$ip];
        my $operand = $insns[$ip + 1];
        $ip += 2;
        if ($insn == 0 or $insn == 6 or $insn == 7) {
            # 0 is adv, 6 is bdv, 7 is cdv; mod 5 turns those into 0,1,2
            $regs[$insn % 5] = $regs[0] >> combo($operand, @regs);
        } elsif ($insn == 1) {  # bxl
            $regs[1] ^= $operand;
        } elsif ($insn == 2) {  # bst
            $regs[1] = combo($operand, @regs) & 7;
        } elsif ($insn == 3) {  # jnz
            $ip = $operand if $regs[0];
        } elsif ($insn == 4) {  # bxc
            $regs[1] ^= $regs[2];
        } elsif ($insn == 5) {  # out
            push @outs, combo($operand, @regs) & 7;
        } else {
            die "bad opcode $insn at " . $ip - 2 . "\n";
        }
    }
    return @outs;
}

print join(",", run()), "\n";

# part 2: we make some very specific undocumented assumptions about the structure of the program
die "oops, i wasn't general enough\n" unless join(",", @insns) =~ /^2,4,1,([0-7]),7,5,4,.,1,\1,0,3,5,5,3,0$/;
my $mask = $1;

sub solve {
    my ($a, $i) = @_;
    return $a if $i < 0;
    $a <<= 3;
    my $expectedOut = $insns[$i];
    for my $candidate (0..7) {
        # we can't let the leading bits all be zero, because then we wouldn't be in this loop iteration!
        next unless $a | $candidate;

        my $c = ($a | $candidate) >> ($candidate ^ $mask);
        next unless (($candidate ^ $c) & 7) == $expectedOut;
        my $res = solve($a | $candidate, $i - 1);
        return $res if defined $res;
    }
    return undef;
}

my $a = solve(0, $#insns);
$initialRegs[0] = $a;
my @out = run();
print "$a ", join(",", @out), "\n";
