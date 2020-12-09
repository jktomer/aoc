#!/usr/bin/perl

my @instructions = <>;

my %FLIPPED = (nop => "jmp", jmp => "nop", acc => "acc");

sub check_state($)
{
    my $flipIp = shift;
    my @history = (0) x @instructions;
    my $acc = 0;
    my $ip = 0;
    
    while (1)
    {
        return (1, $acc) if $ip > $#instructions;
        return (0, $acc) if $history[$ip]++;
        my $inst = $instructions[$ip++];
        $ip == $flipIp and substr($inst, 0, 3) = $FLIPPED{substr($inst, 0, 3)};
        $inst =~ /^nop/ and next;
        $inst =~ /^acc ([+-]\d+)$/ and $acc += $1;
        $inst =~ /^jmp ([+-]\d+)$/ and $ip += $1 - 1;
    }
}

my ($zero, $acc) = check_state(-1);
print "$acc\n";

for my $i (0..$#instructions) {
    my ($success, $acc) = check_state($i);
    print "$i: $acc\n" and last if $success;
}
