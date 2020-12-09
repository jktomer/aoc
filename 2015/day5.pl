#!/usr/bin/perl

# It contains at least three vowels (aeiou only), like aei, xazegov, or aeiouaeiouaeiou.
# It contains at least one letter that appears twice in a row, like xx, abcdde (dd), or aabbccdd (aa, bb, cc, or dd).
# It does not contain the strings ab, cd, pq, or xy, even if they are part of one of the other requirements.

sub nice($) {
    local $_ = shift;
    return unless /[aeiou].*[aeiou].*[aeiou]/;
    return unless /(\w)\1/;
    return if /ab/ or /cd/ or /pq/ or /xy/;
    return 1;
}

# It contains a pair of any two letters that appears at least twice in the string without overlapping, like xyxy (xy) or aabcdefgaa (aa), but not like aaa (aa, but it overlaps).
# It contains at least one letter which repeats with exactly one letter between them, like xyx, abcdefeghi (efe), or even aaa.

sub newnice($) {
    local $_ = shift;
    return unless /(\w\w).*\1/;
    return unless /(\w).\1/;
    return 1;
}

# For example:

# qjhvhtzxzqqjkmpb is nice because is has a pair that appears twice (qj) and a letter that repeats with exactly one letter between them (zxz).
# xxyxx is nice because it has a pair that appears twice and a letter that repeats with one between, even though the letters used by each rule overlap.
# uurcxstgmygtbstg is naughty because it has a pair (tg) but no repeat with a single letter between them.
# ieodomkazucvgmuy is naughty because it has a repeating letter with one between (odo), but no pair that appears twice.

my ($nice, $newnice);
while (<>) {
    $nice++ if nice $_;
    $newnice++ if newnice $_;
}

print "$nice $newnice\n";
