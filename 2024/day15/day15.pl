#!/usr/bin/perl
use strict;

my %DIRS = ("^" => [-1, 0],
            ">" => [0, 1],
            "v" => [1, 0],
            "<" => [0, -1]);

my @map;
{
    local $/ = '';
    @map = map { [ split(//) ] } split(/\n/, scalar <>);
}

my @map2 = map {
    [map {
        /#/ ? qw/# #/ :
        /@/ ? qw/@ ./ :
        /O/ ? qw/[ ]/ :
        /\./ ? qw/. ./ : die "unrecognized char $_" } @$_] } @map;

my ($rr, $rc) = map { my $r = $_; map { $map[$r][$_] eq '@' ? ($r, $_) : () } 0..$#map } 0..$#map;
my ($rr2, $rc2) = map { my $r = $_; map { $map2[$r][$_] eq '@' ? ($r, $_) : () } 0..$#{$map2[0]} } 0..$#map2;

sub moveSimple(\@\$\$$$) {
    my ($m, $r, $c, $dr, $dc) = @_;
    my ($tr, $tc) = ($$r + $dr, $$c + $dc);
    while ($m->[$tr][$tc] =~ /[O\[\]]/) {
        $tr += $dr;
        $tc += $dc;
    }
    return if $m->[$tr][$tc] eq '#';

    while ($tr != $$r or $tc != $$c) {
        $m->[$tr][$tc] = $m->[$tr-$dr][$tc-$dc];
        $tr -= $dr;
        $tc -= $dc;
    }
    $m->[$$r][$$c] = '.';
    $$r += $dr;
    $$c += $dc;
}

sub moveWide($) {
    my $dr = shift;
    my @q = [$rr2, $rc2];
    my %mustMove;
    while (@q) {
        my ($tr, $tc) = @{shift @q};
        my $t = $map2[$tr][$tc];
        next if $t eq '.' or $mustMove{"$tr:$tc"}++;
        if ($t eq '#') {
            return;
        } elsif ($t eq '[') {
            push @q, [$tr, $tc+1];
        } elsif ($t eq ']') {
            push @q, [$tr, $tc-1];
        }
        push @q, [$tr+$dr, $tc];
    }
    for my $moveMe (sort { $b * $dr <=> $a * $dr } keys %mustMove) {
        my ($mr, $mc) = split(/:/, $moveMe);
        die "unmatched block $mr:$mc" if $map2[$mr][$mc] eq '[' and not $mustMove{"$mr:" . ($mc+1)};
        die "unmatched block $mr:$mc" if $map2[$mr][$mc] eq ']' and not $mustMove{"$mr:" . ($mc-1)};
        if ($map2[$mr+$dr][$mc] ne '.') {
            die "can't move $mr:$mc";
        }
        $map2[$mr+$dr][$mc] = $map2[$mr][$mc];
        $map2[$mr][$mc] = '.';
    }
    $rr2 += $dr;
}

# print "initially:\n";
# print @{$map2[$_]}, "\n" for 0..$#map2;
# print "\n\n";

while (<>) {
    chomp;

 Move:
    for my $move (split(//)) {
        my ($dr, $dc) = @{$DIRS{$move}};

        moveSimple(@map, $rr, $rc, $dr, $dc);
        if ($dc) {
            moveSimple(@map2, $rr2, $rc2, $dr, $dc);
        } else {
            moveWide($dr);
        }

        # print "after $move:\n";
        # print @{$map2[$_]}, "\n" for 0..$#map2;
        # for my $row (@map2) {
        #     die "bad board\n" if join("", @$row) =~ /\[[^\]]|[^\[]\]/;
        # }
        # print "\n\n";
    }
}


my ($part1, $part2);
for my $r (0..$#map) {
    for my $c (0..$#map) {
        $part1 += 100 * $r + $c if $map[$r][$c] eq 'O';
    }
    for my $c (0..$#{$map2[0]}) {
        $part2 += 100 * $r + $c if $map2[$r][$c] eq '[';
    }
}
print "$part1\n$part2\n";
