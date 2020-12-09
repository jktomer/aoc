#!/usr/bin/perl

my $valid = 0;
my @expected = qw/byr iyr eyr hgt hcl ecl pid/; # and cid, but not;
$/ = "";

sub year($$$) {
    my ($year, $min, $max) = @_;
    return $year =~ /^\d{4}$/ && $year >= $min && $year <= $max;
}

my $nr;
RECORD:
while (<>) {
    $nr++;
    chomp;
    my @values = split(" ");
    my %card;
    for my $field (@values) {
        my ($key, $val) = split(":", $field);
        $card{$key} = $val;
    }

    for my $expected (@expected) {
        next RECORD unless exists $card{$expected};
    }

    print "$nr: ";
    print "byr $card{byr}\n" and next RECORD unless year($card{byr}, 1920, 2002);
    print "iyr $card{iyr}\n" and next RECORD unless year($card{iyr}, 2010, 2020);
    print "eyr $card{eyr}\n" and next RECORD unless year($card{eyr}, 2020, 2030);

    my $h = $card{hgt};
    my ($n, $unit) = ($h =~ /^(\d+)(cm|in)$/);
    print "hgt $card{hgt}\n" and next RECORD unless $n and $unit;
    print "hgtin $card{hgt}\n" and next RECORD if $unit eq 'in' and ($n < 59 or $n > 76);
    print "hgtcm $card{hgt}\n" and next RECORD if $unit eq 'cm' and ($n < 150 or $n > 193);
    
    print "hcl $card{hcl}\n" and next RECORD unless $card{hcl} =~ /^#[0-9a-f]{6}$/;
    print "ecl $card{ecl}\n" and next RECORD unless $card{ecl} =~ /^(?:amb|blu|brn|gry|grn|hzl|oth)$/;
    print "pid $card{pid}\n" and next RECORD unless $card{pid} =~ /^\d{9}$/;
    
    print "good\n";
    $valid++;
}

print "$valid\n";
