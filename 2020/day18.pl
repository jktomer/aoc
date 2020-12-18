#!/usr/bin/perl

sub parseFactor($$) {
    my ($havePrec, $text) = @_;
    if ($text->[0] eq '(') {
        shift @$text;
        my $ret = parse($havePrec, $text);
        die "expected )" unless shift @$text eq ')';
        return $ret;
    } elsif ($text->[0] =~ /\d/) {
        my $n = shift @$text;
        while ($text->[0] =~ /\d/) {
            $n = 10 * $n + shift @$text;
        }
        return $n;
    } else {
        die "unexpected token '$text->[0]' with " . scalar(@$text) . " left to go";
    }
}

sub parseTerm($$) {
    my ($havePrec, $text)  = @_;
    my $acc = parseFactor($havePrec, $text);
    while ($havePrec and $text->[0] eq '+') {
        shift @$text;
        $acc += parseFactor(1, $text);
    }
    return $acc;
}

sub parse($$)
{
    my ($havePrec, $text) = @_;
    my $acc = parseTerm($havePrec, $text);
    while (1) {
        return $acc unless scalar @$text;
        my $op = shift @$text;
        if ($op eq '+') {
            die "unhandled +?" if $havePrec;
            $acc += parseTerm($havePrec, $text);
        } elsif ($op eq '*') {
            $acc *= parseTerm($havePrec, $text);
        } elsif ($op eq ')') {
            unshift @$text, $op;
            return $acc;
        } else {
            die "Expected operator, saw $op";
        }
    }
}

my $totalFlat, $totalPrec;
while (<>) {
    chomp;
    y/ //d;
    my @tokens = split(//);
    my @tokens2 = @tokens;
    $totalFlat += parse(0, \@tokens);
    $totalPrec += parse(1, \@tokens2);
    die "flat didn't consume whole input" if @tokens;
    die "with prec didn't consume whole input" if @tokens2;
}
print "$totalFlat $totalPrec\n";
