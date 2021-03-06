#!/usr/bin/perl

# Passwords must include one increasing straight of at least three letters, like abc, bcd, cde, and so on, up to xyz. They cannot skip letters; abd doesn't count.
# Passwords may not contain the letters i, o, or l, as these letters can be mistaken for other characters and are therefore confusing.
# Passwords must contain at least two different, non-overlapping pairs of letters, like aa, bb, or zz.
# For example:

# hijklmmn meets the first requirement (because it contains the straight hij) but fails the second requirement requirement (because it contains i and l).
# abbceffg meets the third requirement (because it repeats bb and ff) but fails the first requirement.
# abbcegjk fails the third requirement, because it only has one double letter (bb).
# The next password after abcdefgh is abcdffaa.
# The next password after ghijklmn is ghjaabcc, because you eventually skip all the passwords that start with ghi..., since i is not allowed.

sub valid($) {
    my $pass = shift;
    return if $pass =~ /[iol]/;
    return unless $pass =~ /(\w)\1.*(\w)\2/;

    for my $i (0..length($pass)-3) {
        my ($x, $y, $z) = map { ord(substr($pass, $i+$_, 1)) } (0..2);
        return 1 if $y == $x + 1 and $z == $y + 1;
    }
    return;
}

my $pass = shift;
do { $pass++ } until (valid $pass);
print "$pass\n";
