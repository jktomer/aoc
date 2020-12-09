#!/usr/bin/perl
use strict;
use Clone 'clone';

our %expr;
our %result;
our %deps;
our %rdeps;

sub val($$) {
    my ($v, $for) = @_;
    $v eq $v + 0 and return $v + 0;
    die "haven't yet solved for $v when solving for $for\n" unless exists $result{$v};
    return $result{$v};
}

sub result($) {
    my $w = shift;
    die "already solved for $w\n" if exists $result{$w};
    local $_ = $expr{$w};
    
    /^\w+$/ and return val($_, $w);
    /^(\w+) AND (\w+)$/ and return val($1, $w) & val($2, $w);
    /^(\w+) OR (\w+)$/ and return val($1, $w) | val($2, $w);
    /^(\w+) LSHIFT (\d+)$/ and return (val($1, $w) << $2) & 0xffff;
    /^(\w+) RSHIFT (\d+)$/ and return val($1, $w) >> $2;
    /^NOT (\w+)$/ and return val($1, $w) ^ 0xffff;
    die "unrecognized input [$w] -> [$_]\n";
}

sub deps($) {
     my ($x, $y) = /(\w*) ?(?:(?:AND|OR|NOT|LSHIFT|RSHIFT|) )?(\w*)/ or die $_;
     my %deps;
     $x =~ /[a-z]/ and $deps{$x}++;
     $y =~ /[a-z]/ and @deps{$y}++;
     return \%deps;
}

while (<>) {
    my ($expr, $out) = /(.*) -> (.*)/;
    $expr{$out} = $expr;
    $deps{$out} = deps $expr;
    for my $d (keys %{$deps{$out}}) {
        $rdeps{$d} = [] if not exists $rdeps{$d};
        push @{$rdeps{$d}}, $out;
    }
}

sub run_circuit() {
    my %ldeps = %{clone \%deps};
    my %lrdeps = %{clone \%rdeps};
    local %result;

 PICK:
    while (%ldeps)
    {
        while (my ($candidate, $deps) = each %ldeps)
        {
            next if defined $deps and %{$deps};
            $result{$candidate} = result($candidate);
            # print "$expr{$candidate} -> $candidate = $result{$candidate}\n";
            for my $rdep (@{$lrdeps{$candidate}})
            {
                delete $ldeps{$rdep}{$candidate};
            }
            delete $ldeps{$candidate};
            keys %ldeps;
            next PICK;
        }
        die "no wires without deps?\n";
    }
    return $result{a};
}

my $a = run_circuit();
print "$a\n";
$expr{b} = $a;
print run_circuit(), "\n";

# while (<>) {
#     my ($x, $y, $z) = /(\w* ?)(?:AND|OR|NOT|LSHIFT|RSHIFT|) ?(\w+) -> ([a-z]+)/ or die $_;
#     $x =~ /[a-z]/ and print "$x $z\n";
#     $y =~ /[a-z]/ and print "$y $z\n";
#     print "\n";
# }
