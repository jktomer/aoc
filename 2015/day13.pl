#!/usr/bin/perl

my %prefs;
my %people;

while (<>) {
    my ($a, $verb, $count, $b) = /^(\w+) would (\w+) (\d+) happiness units by sitting next to (\w+)\.$/;
    $count = -$count if $verb eq 'lose';
    $prefs{"$a$b"} = $count;
    $people{$a} = 1;
}

sub happy_path(@) {
    my $happiness = 0;
    for my $i (0..$#_) {
        my $me = $_[$i];
        my $left = $_[$i-1];
        my $mehappy = $prefs{"$me$left"};
        my $lefthappy = $prefs{"$left$me"};
        $happiness += $mehappy + $lefthappy;
        
        print "$i, $me, $left, $mehappy, $lefthappy\n" if join(", ", @_) eq "Alice, Bob, Carol, David";
    }
    # print join(", ", @_), ": $happiness\n";
    return $happiness;
}

sub work($@) {
    my $sofar = shift;
    if (scalar @_ == 0) {
        return happy_path(@{$sofar});
    }

    my $max;
    for my $next (@_) {
        my @copy = @{$sofar};
        push @copy, $next;
        my $choice = work(\@copy, grep { $_ ne $next } @_);
        $max = $choice unless defined $max and $max > $choice;
    }
    return $max;
}

print work([], keys %people), "\n";
print work([""], keys %people), "\n";
