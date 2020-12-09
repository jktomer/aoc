#!/usr/bin/perl

my %edges;
my %redges;

my $innerColor = shift;

while (<>) {
    my ($outcolor, $contents) = /^(.*?) bags contain (.*)$/ or die "no match";
    $edges{$outcolor} = {} unless exists $edges{$outcolor};
    next if $contents eq 'no other bags.';

    @contents = split(/, /, $contents);
    for my $content (@contents) {
        my ($number, $incolor) = ($content =~ /(\d+) (.*) bags?/);
        $edges{$outcolor}{$incolor} = $number;
        $redges{$incolor} = {} unless exists $redges{$incolor};
        $redges{$incolor}{$outcolor} = $number;
    }
}

my %visited;
my @queue = ($innerColor);
while (@queue) {
    my $color = shift @queue;
    next if $visited{$color}++;
    push @queue, keys %{$redges{$color}};
}

print scalar(keys %visited) - 1, "\n";
print scalar(grep { $_ > 1 } values %visited), "\n";

%visited = ();
my @stack = ([$innerColor, 1]);
my $total = -1;
while (@stack) {
    my $item = pop @stack;
    my ($color, $count) = @$item;
    $total += $count;
    $visited{$color}++;
    while (my ($c, $n) = each(%{$edges{$color}})) { push @stack, [$c, $n * $count] };
}

print "$total\n";
print scalar(grep { $_ > 1 } values %visited), "\n";
