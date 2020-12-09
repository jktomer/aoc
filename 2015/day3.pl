#!/usr/bin/perl

my $nSantas = shift;
my @x = (0) x $nSantas;
my @y = (0) x $nSantas;
my %visited = ("0,0" => 1);
my $santa = 0;

undef $/;
for (split(//, <>)) {
    /</ and $x[$santa]--;
    />/ and $x[$santa]++;
    /\^/ and $y[$santa]--;
    /v/ and $y[$santa]++;
    # print "$santa $x[$santa] $y[$santa] => ";
    $visited{"$x[$santa],$y[$santa]"} = 1;
    $santa = ($santa + 1) % $nSantas;
    # print join("; ", keys %visited), "\n";
}

print scalar keys %visited, "\n";
