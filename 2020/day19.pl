#!/usr/bin/perl
use Parse::RecDescent;

my $grammar;
{
    local $/ = '';
    $grammar = <>;
}

$grammar =~ s/(\d+)/rule\1/g;
my $parser = new Parse::RecDescent($grammar);

my ($valid, $valid2);
while (<>) {
    next if /q/;
    my $l = $_;
    chomp;
    my $t = $_;
    $valid++ if defined $parser->rule0(\$_) and not $_;

    my @possibilities;
    push @possibilities, $t while $parser->rule42(\$t);
    while (my ($n, $rest) = each @possibilities) {
        my $m;
        $m++ while $m < $n and $parser->rule31(\$rest);
        if ($m and not $rest) {
            $valid2++;
            last;
        }
    }
}
print "$valid $valid2 $valid3\n";
